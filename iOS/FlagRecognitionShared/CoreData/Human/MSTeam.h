#import "_MSTeam.h"
#import "MSShowableData.h"

@interface MSTeam : _MSTeam {}
// Custom logic goes here.

- (NSString *)shortNameOrName;
- (NSString*)teamColorHex;
- (UIImage *)logoImage;
- (NSArray *)players;
- (MSShowableData *) viewObject;
@end
