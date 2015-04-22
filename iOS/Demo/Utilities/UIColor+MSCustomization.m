//
//  UIColor+MSCustomization.m
//  FlagRecognition
//
//  Created by Lexiren on 2/10/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#import "UIColor+MSCustomization.h"

#pragma mark - Color HSB

typedef struct MSColorHSBA {
    CGFloat h, s, b, a;
} MSColorHSBA;

static inline MSColorHSBA MSColorHSBAFromColor(UIColor *color) {
    MSColorHSBA hsba = { 0.0, 0.0, 0.0, 0.0 };
    [color getHue:&hsba.h saturation:&hsba.s brightness:&hsba.b alpha:&hsba.a];
    return hsba;
}

static inline UIColor * MSColorFromHSBA(MSColorHSBA hsba) {
    return [UIColor colorWithHue:hsba.h saturation:hsba.s brightness:hsba.b alpha:hsba.a];
}

#pragma mark - Color RGB

typedef struct MSColorRGBA {
    CGFloat r, g, b, a;
} MSColorRGBA;

static inline MSColorRGBA MSColorRGBAFromColor(UIColor *color) {
    MSColorRGBA rgba = { 0.0, 0.0, 0.0, 0.0 };
    [color getRed:&rgba.r green:&rgba.g blue:&rgba.b alpha:&rgba.a];
    return rgba;
}

static inline float getLumaFromColor(MSColorRGBA color) {
//    return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
    return color.r * 0.2126 + color.g * 0.7152 +color.b * 0.0722;
}

#pragma mark -

static const float MSColorContrastRatioThreshold = 3.0;

@implementation UIColor (MSCustomization)

- (UIColor *)MS_darkerColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.3, 0.0)
                               green:MAX(g - 0.3, 0.0)
                                blue:MAX(b - 0.3, 0.0)
                               alpha:a];
    return nil;
}

- (UIColor *)MS_lighterColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.4, 1.0)
                               green:MIN(g + 0.4, 1.0)
                                blue:MIN(b + 0.4, 1.0)
                               alpha:a];
    return nil;
}

- (UIImage *)MS_pixelImage
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [self setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/// Check current color contrast ratio on the given background according to W3C recommendations http://www.w3.org/TR/2008/REC-WCAG20-20081211/#visual-audio-contrast-contrast
- (BOOL)checkColorContrastRatioWithColor:(UIColor *)backgroundColor {
    MSColorRGBA colorRGBA = MSColorRGBAFromColor(self);
    MSColorRGBA bgRGBA    = MSColorRGBAFromColor(backgroundColor);

    //see http://www.w3.org/TR/WCAG20/#relativeluminancedef for details
    float(^modifyComponent)(float) = ^(float comp) {
        return (float)(comp <= 0.03928 ? comp / 12.92 : powf(((comp + 0.055) / 1.055), 2.4));
    };
    
    float *p  = (float *)&colorRGBA;
    float *p1 = (float *)&bgRGBA;
    
    for(int i = 0; i < 4; i++) {
        *(p + i)  = modifyComponent(*(p + i));
        *(p1 + i) = modifyComponent(*(p1 + i));
    }
    
    float l1 = getLumaFromColor(bgRGBA);
    float l2 = getLumaFromColor(colorRGBA);
    
    //see http://www.w3.org/TR/WCAG20/#contrast-ratiodef for details
    float l = l1 > l2 ? (l1 + 0.05) / (l2 + 0.05) : (l2 + 0.05) / (l1 + 0.05);
    
    return l >= MSColorContrastRatioThreshold;
}

/// Validate color contrast on white background and reduce its brightness if needed
- (UIColor *)MS_validatedColor {
    if(![self checkColorContrastRatioWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]) {
        DLog(@"color contrast is not valid. reducing color brightness...");
        MSColorHSBA hsba = MSColorHSBAFromColor(self);
        hsba.b -= 0.2;
        if(hsba.b < 0) {
            DLog(@"cannot reduce brightness anymore");
            return self;
        }
        UIColor *darkerColor = MSColorFromHSBA(hsba);
        return [darkerColor MS_validatedColor];
    }
    DLog(@"color contrast is valid");
    return self;
}

+ (UIColor *)MS_imageAverageColor:(UIImage *)image {
    
    if (!image) return nil;
    
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int color[4] = {0};
    int count = 0;
    
    for (int i = 0; i < height; i++){
        for (int j = 0; j < bytesPerRow; j+= bytesPerPixel){
            unsigned char * pixel = &rawData[i * bytesPerRow + j];
            if ((pixel[0] < 20 && pixel[1] < 20 && pixel[2] < 20) || (pixel[0] > 200 && pixel[1] > 200 && pixel[2] > 200)){
                continue;
            }
            color[0] += pixel[0];
            color[1] += pixel[1];
            color[2] += pixel[2];
            color[3] += pixel[3];
            count++;
        }
    }
    
    int maxColorIndex = 0;
    int prevMaxIdx = 0;
    int value = color[0];
    for (int i = 0; i < bytesPerPixel - 1; i++){
        if (color[i] > value){
            prevMaxIdx = maxColorIndex;
            maxColorIndex = i;
            value = color[i];
        }
    }
    
    if (maxColorIndex == 0){
        prevMaxIdx = color[1] > color[2] ? 1 : 2;
    }
    
    for (int i = 0; i < bytesPerPixel - 1; i++){
        if (i == maxColorIndex){
            if (count != 0)
                color[maxColorIndex] = (value * 2 / count > 1) ? count * 255 : value * 2;
        } else if (i != prevMaxIdx) {
            color[i] = color[i] / 2;
        }
    }
    
    UIColor * resultColor = [UIColor colorWithRed:((float)color[0] / (float)count)/255.0f green:((float)color[1] / (float)count)/255.0f blue:((float)color[2] / (float)count)/255.0f alpha:1];
    
    free(rawData);
    return resultColor;
}


@end
