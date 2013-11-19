//
//  NIKAudioManager.m
//  RadioGeek
//
//  Created by Neeku on 10/29/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKAudioManager.h"

@implementation NIKAudioManager
@synthesize audioPlayer;
@synthesize seekSlider;
@synthesize buttonTitle;

-(id) init
{
	self = [super init];
	if (self != nil)
	{
		// do setup stuff;
		audioPlayer.delegate = self;
	}
	return self;
}

- (void)streamAudio
{
	NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:@"HeadspinLong" withExtension:@"caf"];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
	//Load the audio into memory
	[audioPlayer prepareToPlay];
	
	[audioPlayer setDelegate:self];
	[audioPlayer setVolume:1.0];
	
	// Set a timer which keep getting the current music time and update the UISlider in 1 sec interval
	playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];

	
}

- (void)playAudio {
    //Play the audio and set the button to represent the audio is playing
    [audioPlayer play];
	buttonTitle = @"Pause";
}

- (void)pauseAudio {
    //Pause the audio and set the button to represent the audio is paused
    [audioPlayer pause];
	buttonTitle = @"Play";
}

- (void)togglePlayPause {
    //Toggle if the music is playing or paused
    if (!self.audioPlayer.playing) {
        [self playAudio];
        
    } else if (self.audioPlayer.playing) {
        [self pauseAudio];
        
    }
}

- (void)checkAudioSessionCategory
{
	//Make sure the system follows our playback status
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	


}

- (void)updateSlider {
	// Update the slider about the music time
	seekSlider.value = audioPlayer.currentTime;
}

- (IBAction)sliderChanged:(UISlider *)sender {
	// Fast skip the music when user scroll the UISlider
	[audioPlayer stop];
	[audioPlayer setCurrentTime:seekSlider.value];
	[audioPlayer prepareToPlay];
	[audioPlayer play];
}

// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	// Music completed
	if (flag) {
		[playbackTimer invalidate];
	}
}

+(NIKAudioManager*) sharedManager {
	static NIKAudioManager* staticInstance;
	
	if (staticInstance == nil) {
		staticInstance = [[NIKAudioManager alloc] init];
	}
	
	return staticInstance;
}
@end
