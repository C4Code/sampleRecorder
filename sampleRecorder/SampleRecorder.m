//
//  SampleRecorder.m
//  audioRecord2
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "SampleRecorder.h"
#import "MySample.h"

@implementation SampleRecorder 
@synthesize sample = _sample, settings, audioRecorder, fileURL;

-(id)init {
    self = [super init];
    if(self != nil) {
        _sample = [MySample new];
    }
    return self;
}

-(void)recordSample {	
    C4Log(@"started to record a sample");
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err){
        NSLog(@"audioSession setCategory:error -> %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	err = nil;
	[audioSession setActive:YES error:&err];
	if(err){
        NSLog(@"audioSession setActive:error -> %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	
	self.settings = [[NSMutableDictionary alloc] init];
	
	// We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
	[self.settings setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    
	// We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
	[self.settings setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
	
	// We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
	[self.settings setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
	
	// These settings are used if we are using kAudioFormatLinearPCM format
	//[self.settings setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	//[self.settings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	//[self.settings setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	
	
	
	// Create a new dated file
	//NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    //	NSString *caldate = [now description];
    //	recorderFilePath = [[NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, caldate] retain];
	
	self.fileURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/MySound.caf", NSTemporaryDirectory()]];
	
	err = nil;
	
	NSData *audioData = [NSData dataWithContentsOfFile:[self.fileURL path] options: 0 error:&err];
	if(audioData)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[self.fileURL path] error:&err];
	}
	
	err = nil;
	self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:self.fileURL settings:self.settings error:&err];
	if(!self.audioRecorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
	}
	
	//prepare to record
	[self.audioRecorder setDelegate:self];
	[self.audioRecorder prepareToRecord];
	self.audioRecorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (! audioHWAvailable) {
        C4Log(@"Audio Session unavailable, have to exit now, sorry...");
        return;
	}
	
	// start recording
	[self.audioRecorder record];
}

- (void) stopRecording {
	[self.audioRecorder stop];
    if(self.sample != nil) {
        [self.sample stop];
        _sample = nil;
    }
    _sample = (C4Sample *)[MySample sampleURL:self.fileURL];
}

- (void)playSample {
    [self.sample prepareToPlay];
    [self.sample play];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)aRecorder 
                           successfully:(BOOL)flag {
	C4Log(@"successfully recorded a sample");
}

-(void)dealloc {
	NSError *err = nil;
	NSFileManager *fm = [NSFileManager defaultManager];
	
	err = nil;
	[fm removeItemAtPath:[self.fileURL path] error:&err];
	if(err)
        NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
}

@end
