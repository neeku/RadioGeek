//
//  NIKAudioManager.h
//  RadioGeek
//
//  Created by Neeku on 10/29/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVPlayerDemoPlaybackView;

@interface NIKAudioManager : NSObject <AVAudioPlayerDelegate>
{
	NSString* path;
	NSURL *url;
	NSTimer *playbackTimer;
	AVAudioPlayer *audioPlayer; //Plays the audio
	NSString *buttonTitle;
}

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVQueuePlayer* backgroundMusicPlayer;
@property (nonatomic, retain) UISlider *seekSlider;
@property (nonatomic, retain) NSString *buttonTitle;

- (void)playAudio; //play the audio
- (void)pauseAudio; //pause the audio
- (void)togglePlayPause; //toggle the state of the audio
- (void)checkAudioSessionCategory;
- (void)streamAudio;
+ (NIKAudioManager*) sharedManager;

@end
