//
//  NIKPlayer.m
//  RadioGeek
//
//  Created by Neeku on 11/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKPlayer.h"

@implementation NIKPlayer
@synthesize currentPlayer;

+(NIKPlayer *) sharedPlayer
{
	static NIKPlayer* sharedPlayer;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedPlayer = [[NIKPlayer alloc] init];
	});
	return sharedPlayer;
}

-(void)playURL:(NSURL*)url
{
	if (currentPlayer.isPlaying)
	{
		if (![currentPlayer.url isEqual:url])
		{
			[currentPlayer stop];
			currentPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
			[currentPlayer prepareToPlay];

		}
	}
	else
	{
		currentPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		[currentPlayer prepareToPlay];
	}
}

@end
