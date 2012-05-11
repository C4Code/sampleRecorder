//
//  SampleRecorder.h
//  audioRecord2
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"
#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>

@interface SampleRecorder : C4Object <AVAudioRecorderDelegate>
-(void)recordSample;
-(void)stopRecording;
-(void)playSample;

@property (readwrite, strong) NSMutableDictionary *settings;
@property (readwrite, strong) NSURL *fileURL;
@property (readwrite, strong) AVAudioRecorder *audioRecorder;
@property (readonly, strong) C4Sample *sample;
@end
