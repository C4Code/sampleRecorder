//
//  MySample.h
//  audioRecord2
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Sample.h"

@interface MySample : C4Sample
+(MySample *)sampleURL:(NSURL *)sampleURL;
-(id)initWithURL:(NSURL *)sampleURL;
@property (readwrite, strong) AVAudioPlayer* player;
@end