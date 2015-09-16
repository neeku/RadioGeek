//
//  NIKAudioManager.m
//  RadioGeek
//
//  Created by Neeku on 10/29/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKAudioManager.h"
#import "NIKMasterViewController.h"
#import "NSHFarsiNumerals.h"

NIKAudioManager *currentAudioManager;

@implementation NIKAudioManager

@synthesize detailViewController;
@synthesize soundPlayer;

- (id) initWithURL:(NSURL *)fileURL viewController:(id)detailVC title:(NSString *) title
{
	podcastTitle = title;
	detailViewController = detailVC;
	audioURL = fileURL;
	soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
	[soundPlayer setVolume:1.0];
	
	//to synchronize the slider updates with the actual duration of the audio.
	detailViewController.seekSlider.maximumValue = soundPlayer.duration;
	
	NSError *error;
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        
		//        [[self volumeControl] setEnabled:NO];
        [[detailViewController playPauseButton] setEnabled:NO];
        
		//        [[self alertLabel] setText:@"Unable to load file"];
		//        [[self alertLabel] setHidden:NO];
		//    } else {
		//        [[self alertLabel] setText:[NSString stringWithFormat:@"%@ has loaded", @"HeadspinLong.caf"]];
		//        [[self alertLabel] setHidden:NO];
    }
	[self refreshButton];
	[self displayNowPlayingItemInfo];
	return self;
}

- (void) togglePlayPause
{
    //Toggle if the music is playing or paused
    if (!soundPlayer.playing)
	{
		[self playAudio];
    }
	else if (soundPlayer.playing)
	{
        [self pauseAudio];
    }
	[self displayNowPlayingItemInfo];
	[self refreshButton];
}

- (void)refreshButton
{
	if ([soundPlayer isPlaying])
    {
		[detailViewController.playPauseButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    }
    else
    {
		[detailViewController.playPauseButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    }
}

- (void)playAudio
{
	if (self != currentAudioManager)
	{
		if (nil != currentAudioManager && currentAudioManager.soundPlayer.playing)
		{
			[currentAudioManager togglePlayPause];
		}
		currentAudioManager = self;
	}
	
    //Play the audio and set the button to represent the audio is playing
	if ([soundPlayer isPlaying])
    {
        [soundPlayer pause];
        [self deleteTimer];
    }
    else
    {
        [self createTimer];
        [soundPlayer play];
    }
	
	[self refreshButton];
//	[[NIKMasterViewController sharedController] markEntryAsPlaying:detailViewController.feedEntry];
}

- (void)pauseAudio
{
    //Pause the audio and set the button to represent the audio is paused
    [soundPlayer pause];
	[self deleteTimer];
	[self refreshButton];
}

//- (void)stopAudio
//{
//	if(audioPlayer && [audioPlayer isPlaying]){
//		[audioPlayer stop];
//		audioPlayer=nil;
//	}
//}


- (void)getTime:(NSTimer *)timer
{
    [detailViewController.seekSlider setValue:soundPlayer.currentTime];
	
	int currentHour = (int) soundPlayer.currentTime / 3600;
	int currentMinute = (int)(soundPlayer.currentTime / 60) % 60;
	int currentSecond = (int) soundPlayer.currentTime % 60;
	
	int remainingHour = (int)(soundPlayer.duration - soundPlayer.currentTime) / 3600;
	int remainingMinute = (int)((soundPlayer.duration - soundPlayer.currentTime) / 60) % 60;
 	int remainingSecond = (int)(soundPlayer.duration - soundPlayer.currentTime) % 60;
	
	//to avoid displaying extra 00: when duration is less than an hour.
	if (remainingHour == 0 )
	{
		detailViewController.remainingTime.text = [NSHFarsiNumerals convertNumeralsToFarsi:[NSString stringWithFormat:@"%02d:%02d", remainingMinute, remainingSecond, nil]];
		[detailViewController.remainingTime setFont:[UIFont fontWithName:@"XM Yekan" size:10]];
	}
	else if (remainingHour != 0)
	{
		detailViewController.remainingTime.text = [NSHFarsiNumerals convertNumeralsToFarsi:[NSString stringWithFormat:@"%02d:%02d:%02d", remainingHour, remainingMinute, remainingSecond, nil]];
		[detailViewController.remainingTime setFont:[UIFont fontWithName:@"XM Yekan" size:10]];
	}
	if (currentHour == 0)
	{
		detailViewController.currentTime.text = [NSHFarsiNumerals convertNumeralsToFarsi:[NSString stringWithFormat:@"%02d:%02d", currentMinute, currentSecond, nil]];
		[detailViewController.currentTime setFont:[UIFont fontWithName:@"XM Yekan" size:10]];
	}
	else if (currentHour != 0)
	{
		detailViewController.currentTime.text = [NSHFarsiNumerals convertNumeralsToFarsi:[NSString stringWithFormat:@"%02d:%02d:%02d", currentHour, currentMinute, currentSecond, nil]];
		[detailViewController.currentTime setFont:[UIFont fontWithName:@"XM Yekan" size:10]];
		
	}
	
}

- (void)createTimer
{
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getTime:) userInfo:nil repeats:YES];
}

- (void)deleteTimer
{
    [playbackTimer invalidate];
	playbackTimer = nil;
}

- (void)updateSlider
{
	// Update the slider about the music time
	detailViewController.seekSlider.value =  soundPlayer.currentTime;
	[self displayNowPlayingItemInfo];
}

- (void) seekSliderChanged
{
	BOOL wasPlaying = FALSE;
	// Fast skip the music when user scrolls the slider
	if (soundPlayer.isPlaying)
	{
		[soundPlayer stop];
		wasPlaying = TRUE;
	}
	
	[soundPlayer setCurrentTime:detailViewController.seekSlider.value];
	if (wasPlaying)
	{
		[soundPlayer prepareToPlay];
		[soundPlayer play];
	}
	[self getTime:nil];
}


// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	// Music completed
	if (flag)
	{
		[playbackTimer invalidate];
	}
}

- (void) fastForwardTheAudio
{
	int current = [soundPlayer currentTime];
	[soundPlayer setCurrentTime:current+15];
}

- (void) rewindTheAudio
{
	int current = [soundPlayer currentTime];
	[soundPlayer setCurrentTime:current-15];
}

- (void) setSliderChanges
{
	// Set a timer which keep getting the current music time and update the UISlider in 1 sec interval
	playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	// Set the maximum value of the UISlider
	detailViewController.seekSlider.maximumValue = soundPlayer.duration;
	
	// Set the valueChanged target
	[detailViewController.seekSlider addTarget:self action:@selector(seekSliderChanged) forControlEvents:UIControlEventValueChanged];
	
}

- (void) displayNowPlayingItemInfo
{
	// Displays the now-playing file information including the podcast title, author, elapsed time and duration, and an artwork.
	NSNumber *durationNumber = [NSNumber numberWithDouble:currentAudioManager.soundPlayer.duration];
	NSNumber *elapsedNumber = [NSNumber numberWithDouble:currentAudioManager.soundPlayer.currentTime];
	MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"RadioGeekArtwork.png"]];
	NSDictionary *info = @{ MPMediaItemPropertyArtist: @"جادی",
							MPMediaItemPropertyTitle: podcastTitle,
                            MPMediaItemPropertyPlaybackDuration:durationNumber,
							MPNowPlayingInfoPropertyElapsedPlaybackTime:elapsedNumber,
							MPNowPlayingInfoPropertyPlaybackRate:[NSNumber numberWithInt:1],
							MPMediaItemPropertyArtwork:artwork};
	
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
}


@end