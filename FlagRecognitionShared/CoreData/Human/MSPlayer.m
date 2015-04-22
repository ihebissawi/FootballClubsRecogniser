#import "MSPlayer.h"
#import "MSTeam.h"

#define kMSPlayerDefaultPhotoName @""

@interface MSPlayer ()

// Private interface goes here.

@end


@implementation MSPlayer

// Custom logic goes here.

#pragma mark - public

- (NSString *)shortNameOrName {
    if (self.nameShort.length) {
        return self.nameShort;
    }
    return [self fullName];
}

- (NSString *)fullName {
    NSString *name = [NSString stringWithFormat:@"%@%@%@",
                       (self.lastName.length) ? self.lastName : @"",
                       (self.lastName.length && self.firstName.length) ? @" ": @"",
                      (self.firstName.length) ? self.firstName : @""];
    if (!name.length) {
        name = @"NO NAME";
    }
    return name;
}


- (UIImage *)photoImage {
    if (self.imageFilePath) {
        return [UIImage imageWithContentsOfFile:self.imageFilePath];
    }
    if (!self.photoLink) {
//        return [UIImage imageNamed:kMSPlayerDefaultPhotoName];
        return nil;
    }
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.photoLink]];
    
    if (!imageData) {
//        return [UIImage imageNamed:kMSPlayerDefaultPhotoName];
        return nil;
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        [self cacheImage:image withImageName:[self shortNameOrName]];
    });
    return image;
}

- (MSShowableData *)viewObject{
    NSString * namePart = self.positionName;
    NSString * countryPart = self.countryName;
    NSString * combinedString = [NSString stringWithFormat:@"%@, %@", namePart, countryPart];
    NSRange countryRange = [combinedString rangeOfString:countryPart];
    if (countryPart.length == 0){
        combinedString = namePart;
        countryRange = NSMakeRange(0, 0);
    }
    
    NSMutableAttributedString * resultString = [[NSMutableAttributedString alloc] initWithString:combinedString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:12.0f]}];
    [resultString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"OpenSans-Bold" size:12.0f] range:countryRange];
    
    return [MSShowableData objectWith:self.fullName subtitle:resultString.copy imageUrl:self.team.logo];
}

#pragma mark - private

+ (id) MR_importFromObject:(id)objectData inContext:(NSManagedObjectContext *)context {
    MSPlayer *newEntity = [super MR_importFromObject:objectData inContext:context];
    if (newEntity.playsForTeamID) {
        MSTeam *team = [MSTeam MR_findFirstByAttribute:@"iD" withValue:newEntity.playsForTeamID];
        newEntity.team = team;
    }
    
    if ([newEntity.positionName isEqualToString:@"Attacker"]) {
        newEntity.positionName = @"Forward";
    } else if ([newEntity.positionName isEqualToString:@"coach"]){
        newEntity.positionName = @"Coach";
    }
    
    return newEntity;
}

@end
