//
//  NIKAudioManager.m
//  RadioGeek
//
//  Created by Neeku on 10/29/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKAudioManager.h"

@implementation NIKAudioManager
@synthesize theSound;
@synthesize aSlider;

-(id) init {
	
	self = [super init];
	
	if (self != nil) {
		// do setup stuff;
		theSound.delegate = self;
		
		
	}
	
	return self;
	
}


-(void) playMusic
{
//	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jadi" ofType:@"mp3"];
	url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/jadi.mp3", [[NSBundle mainBundle] resourcePath]]];

	theSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[theSound setDelegate:self];
	[theSound setVolume:1.0];
	
	// Set a timer which keep getting the current music time and update the UISlider in 1 sec interval
	asliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	// Set the maximum value of the UISlider
	aSlider.maximumValue = theSound.duration;
	// Set the valueChanged target
	[aSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	
	// Play the audio
	[theSound prepareToPlay];
	[theSound play];
}

- (void)updateSlider {
	// Update the slider about the music time
	aSlider.value = theSound.currentTime;
}

- (IBAction)sliderChanged:(UISlider *)sender {
	// Fast skip the music when user scroll the UISlider
	[theSound stop];
	[theSound setCurrentTime:aSlider.value];
	[theSound prepareToPlay];
	[theSound play];
}

// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	// Music completed
	if (flag) {
		[asliderTimer invalidate];
	}
}


-(void) pauseMusic
{
	[theSound pause];
}




+(NIKAudioManager*) sharedManager {
	static NIKAudioManager* staticInstance;
	
	if (staticInstance == nil) {
		staticInstance = [[NIKAudioManager alloc] init];
	}
	
	return staticInstance;
}
@end
