//
//  MSLoadingTableViewCell.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 24.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#import "MSTableViewCell.h"

@interface MSLoadingTableViewCell : MSTableViewCell

- (void)startAnimating;
- (void)stopAnimating;

@end
