//
//  MSRoundedImage.h
//  FlagRecognition
//
//  Created by Igor Litvinenko on 12/16/14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSRoundedImageView : UIView

@property (nonatomic, strong, readonly) UIImageView * imageView;
@property (nonatomic, strong) UIColor * borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, assign) BOOL disableImageSizeAdjusting;

- (void) setImageWithUrlPath: (NSString *) urlPath;
- (void) cancelLoadingImage;
- (void) setupDefaultValues;

@end
