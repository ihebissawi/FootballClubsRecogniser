//
//  MSBaseDataViewController.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 18.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "UIImage+MSUtils.h"

@implementation UIImage (MSUtils)

+ (UIImage *)MS_imageFromView:(UIView *)view {
    NSParameterAssert(view);
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)MS_shirtImageWithColor:(UIColor *)color fromImage:(UIImage *)image {
    UIImage *blackShirtImage = image;
    if (!blackShirtImage) {
        DLog(@"missed image");
        return nil;
    }
    
    CGSize size = blackShirtImage.size;
    //Create a context of the appropriate size
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);

    //Invert context to get correct orientation for clipping
    CGContextTranslateCTM(currentContext, 0, fillRect.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    //Clip context according mask
    CGContextClipToMask(currentContext, fillRect, blackShirtImage.CGImage);

    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    //Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    //Snap the picture and close the context
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


+ (UIImage *)MS_imageFromCountryName:(NSString *)countryName{
    NSString * morphedName = countryName;
    if ([morphedName isEqualToString:@"St. Lucia"]){
        morphedName = @"Saint Lucia";
    } else if ([morphedName isEqualToString:@"Republic of Ireland"]){
        morphedName = @"Ireland Republic";
    } else if ([morphedName isEqualToString:@"Sierra Leone"]){
        morphedName = @"Sierra-Leone";
    } else if ([morphedName isEqualToString:@"FYR Macedonia"]){
        morphedName = @"Macedonia";
    } else if ([morphedName isEqualToString:@"Côte d'Ivoire"]){
        morphedName = @"Cote-d'Ivoire";
    } else if ([morphedName isEqualToString:@"Korea Republic"]){
        morphedName = @"South Korea";
    }
    
    UIImage *image = [UIImage imageNamed:morphedName];
    return [image cropImageInset:UIEdgeInsetsMake(10, 3, 14, 3)];
}

- (UIImage *) cropImageInset: (UIEdgeInsets) inset{
    CGRect frame = CGRectZero;
    frame.size = self.size;
    frame = UIEdgeInsetsInsetRect(frame, inset);
    
    if (self.scale > 1.0f) {
        frame = CGRectMake(frame.origin.x * self.scale,
                          frame.origin.y * self.scale,
                          frame.size.width * self.scale,
                          frame.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, frame);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end
