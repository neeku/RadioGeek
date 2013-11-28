//
//  NIKAudioPlayer.h
//  RadioGeek
//
//  Created by Neeku on 11/25/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	<AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVFoundation.h>
#import "NIKAudioPlayerView.h"

@protocol NIKAudioPlayerDelegate;

@interface NIKAudioPlayer : NSObject
{
	id mTimeObserver;
	float mRestoreAfterScrubbingRate;

	NIKAudioPlayerView *apView;
}
@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign) id <NIKAudioPlayerDelegate> delegate;


- (void) playAudioAtURL:(NSURL *)URL;
- (void) play;
- (void) pause;
- (void) fastForward;
- (void) rewind;
- (CMTime)playerItemDuration;
- (void)scrub: (id)sender;


+ (NIKAudioPlayer *)sharedAudioPlayer;

@end



@protocol NIKAudioPlayerDelegate <NSObject>
@optional
- (void)audioPlayerDidStartPlaying;
- (void)audioPlayerDidStartBuffering;
- (void)audioPlayerDidPause;
- (void)audioPlayerDidFinishPlaying;
@end