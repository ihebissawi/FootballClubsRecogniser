//
//  MSMatchDetailInterfaceController.m
//  FlagRecognition
//
//  Created by Alexander Peresadchenko on 4/1/15.
//  Copyright (c) 2015 DataArt Solutions, Inc. All rights reserved.
//

#import "MSMatchDetailInterfaceController.h"


@interface MSMatchDetailInterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *matchTitle;
@property (nonatomic, strong) NSArray *matchEvents;

@end


@implementation MSMatchDetailInterfaceController



- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    NSDictionary *contextDict = (NSDictionary *)context;
    if (contextDict) {
        self.matchTitle = [contextDict valueForKey:@"matchTitle"];
        
        if([contextDict valueForKey:@"matchEvents"]) {
            self.matchEvents = [contextDict valueForKey:@"matchEvents"];
        }
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


#pragma mark - Segue
-(id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    
    return self.matchEvents;
    
}

@end



