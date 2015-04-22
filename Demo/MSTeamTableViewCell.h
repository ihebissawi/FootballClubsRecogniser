//
//  MSTeamTableViewCell.h
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 3/18/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSDataTableViewCell.h"

@class MSTeamTableViewCell;
@protocol MSTeamTableViewCellDelegate  <NSObject>

-(void)teamTableViewCell:(MSTeamTableViewCell*)cell setFavoritesState:(BOOL)state;

@end

@interface MSTeamTableViewCell : MSDataTableViewCell

@property (nonatomic, weak) id <MSTeamTableViewCellDelegate> delegate;

@end
