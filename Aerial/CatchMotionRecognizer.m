//
//  CatchMotionRecognizer.m
//  Aerial
//
//  Created by Gord Parke on 4/30/12.
//  Copyright (c) 2012 PPG Technologies. All rights reserved.
//

#import "CatchMotionRecognizer.h"
#import "MotionRecognizerSubclass.h"

#define kNotFreeFallMag         0.5 /* g's */
#define kCatchDuration          0.5  /* Second */

@interface CatchMotionRecognizer () {
    NSTimeInterval catchTime;
}
// Redefinitions to read-writes
@property (nonatomic, readwrite, getter = isFumble) BOOL fumble;
@end


@implementation CatchMotionRecognizer
@synthesize fumble = _fumble;

#pragma mark - Motion Analysis

- (void)analyzeNewMotionSample:(MotionSample_t *)newSample
{    
    // Get magnitude of acceleration in newSample
    GSFloat mag = GSVectorMagnitudeD(newSample->vbAcceleration, 3);
    
    MotionRecognizerState state = self.state;
    switch (state) {
            
            // Record the possible start of a throw when acceleration falls below threshold
        case MotionRecognizerStatePossible:
            if (mag > kNotFreeFallMag){
                catchTime = newSample->timestamp;
                self.state = MotionRecognizerStateBegan;
            }
            break;
            
            // End catch after catch interval
        case MotionRecognizerStateBegan:
            // If the acceleration drops back into the free fall zone it's a fumble
            if (mag < 0.8*kNotFreeFallMag)
                self.fumble = YES;
            
            // Check if the catch is over
            if (newSample->timestamp - catchTime >= kCatchDuration){
                self.state = MotionRecognizerStateEnded;
            }
            break;
            
        default:
            NSAssert(0,@"Invalid state in analyzeNewMotionSample in %@",NSStringFromClass([self class]));
    }
}

#pragma mark - State Entry
- (void)didEnterStateReset
{    
    catchTime = 0;
    self.fumble = NO;
}

#pragma mark - State Exit

#pragma mark - Lifecycle

@end