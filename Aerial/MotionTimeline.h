//
//  MotionTImeline.h
//  Aerial
//
//  Created by Gord Parke on 4/19/12.
//  Copyright (c) 2012 PPG Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GolfSwing_types.h"


// Motion Structures
typedef struct {
    NSTimeInterval timestamp;
    
    GSDouble vbAcceleration[3];
    
    GSDouble vbAngularVelocity[3];
    GSDouble mBodyToRelease[9];
    
    GSDouble vbAccelerationDerivative[3];
    GSDouble vbAngularVelocityDerivative[3];
} MotionSample_t;

@interface MotionTimeline : NSObject

// Size of the timeline in number of samples 
@property (nonatomic, readonly) NSUInteger capacity;  

// Number of samples currently in timeline. Set to 0 to reset, or n to remember only the past n samples
@property (nonatomic) NSUInteger count;     


/*** Sample Retrival *********/
// These methods return nil if the request is invalid 
   
// Returns past samples in the timeline. A index of 0 is the most recent sample 
-(MotionSample_t *)sampleAtPastIndex:(NSInteger)index;
-(MotionSample_t *)newestSample;
-(MotionSample_t *)oldestSample;

//*** Sample Input **********/
// Adds a new sample to the end of the timeline
-(void)addSample:(MotionSample_t *)newSample;

//*** Sample Statistics *****/
// Only some fields are averaged.  Range.location is a past sample index - similar to sampleAtPastIndex:
-(MotionSample_t)averageOfSamplesInRange:(NSRange)range;

@end