//
//  MySample.m
//  audioRecord2
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "MySample.h"

@implementation MySample
@synthesize player = _player;
+(MySample *)sampleURL:(NSURL *)sampleURL {
    MySample *s = [[MySample alloc] initWithURL:sampleURL];
    return s;
}

-(id)initWithURL:(NSURL *)sampleURL {
    self = [super init]; 
    if(self != nil) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:sampleURL error:nil];
        self.player.delegate = self;
    }
    return self;
}
@end