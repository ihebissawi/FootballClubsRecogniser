//
//  MSDataTableViewCell.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 24.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSTableViewCell.h"
#import "MSShowableData.h"

@interface MSDataTableViewCell : MSTableViewCell

@property (nonatomic, strong) MSShowableData * viewObject;
@property (nonatomic, getter = isSeparatorHidden) BOOL separatorHidden;
@property (nonatomic, getter = isInvertedColor) BOOL invertedColor;

- (void) updateUI;

@end
