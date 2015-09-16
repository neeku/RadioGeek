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
	NSTimer *asliderTimer;
}

@property (nonatomic, strong) AVAudioPlayer* theSound;
@property (nonatomic, strong) AVQueuePlayer* backgroundMusicPlayer;
@property (nonatomic, retain) UISlider *aSlider;

- (void) playMusic;
- (void) pauseMusic;

+ (NIKAudioManager*) sharedManager;

@end
