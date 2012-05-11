//
//  C4WorkSpace.m
//  sampleRecorder
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"
#import "SampleRecorder.h"
#import "MySample.h"

@interface C4WorkSpace ()
@property (readwrite, strong) C4Sample *audioSample;
@property (readwrite, strong) SampleRecorder *sampleRecorder;
@end

@implementation C4WorkSpace {
}
@synthesize audioSample, sampleRecorder;

-(void)setup {
    sampleRecorder = [SampleRecorder new];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touch = [[touches anyObject] locationInView:self.canvas];
    if(touch.x < 384) {
        if (touch.y < 512) {
            [sampleRecorder recordSample];
        } else {
            C4Log(@"should play a sample");
            self.audioSample = nil;
            self.audioSample = sampleRecorder.sample;
            if(self.audioSample != nil)
                [self.audioSample play];
            else
                C4Log(@"something went wrong with setting the new sample");
        }
    } else {
        if (touch.y < 512) {
            [sampleRecorder stopRecording];
        }
    }
}
@end