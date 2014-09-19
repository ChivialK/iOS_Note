//  Created by Phillipus on 20/09/2013.
//  Copyright (c) 2013 Dada Beatnik. All rights reserved.
//

#import "CustomUnwindSegue.h"

@implementation CustomUnwindSegue

- (void)perform
{
    UIView *sv = ((UIViewController *)self.sourceViewController).view;
    UIView *dv = ((UIViewController *)self.destinationViewController).view;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    dv.center = CGPointMake(sv.center.x - sv.frame.size.width, dv.center.y);
    [window insertSubview:dv belowSubview:sv];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         dv.center = CGPointMake(sv.center.x, dv.center.y);
                         sv.center = CGPointMake(sv.center.x + sv.frame.size.width, dv.center.y);
                     }
                     completion:^(BOOL finished){
                         [[self destinationViewController]
                          dismissViewControllerAnimated:NO completion:nil];
                     }];
}

@end
