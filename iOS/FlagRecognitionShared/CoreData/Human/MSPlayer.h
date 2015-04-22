#import "_MSPlayer.h"
#import "MSShowableData.h"

@interface MSPlayer : _MSPlayer {}
// Custom logic goes here.

- (NSString *)shortNameOrName;
- (NSString *)fullName;
- (UIImage *)photoImage;
- (MSShowableData *) viewObject;

@end
