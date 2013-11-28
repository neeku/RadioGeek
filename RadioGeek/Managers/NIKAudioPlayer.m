//
//  NIKAudioPlayer.m
//  RadioGeek
//
//  Created by Neeku on 11/25/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKAudioPlayer.h"

@interface NIKAudioPlayer ()
- (void)playerItemDidFinishPlaying:(id)sender;
@end

@implementation NIKAudioPlayer
{
	AVPlayer *player;
}

@synthesize isPlaying;
@synthesize delegate;

- (void)playAudioAtURL:(NSURL *)URL
{
    if (player)
    {
        [player removeObserver:self forKeyPath:@"status"];
        [player pause];
    }
	
    player = [AVPlayer playerWithURL:URL];
    [player addObserver:self forKeyPath:@"status" options:0 context:nil];
	
    if (delegate && [delegate respondsToSelector:@selector(audioPlayerDidStartBuffering)])
        [delegate audioPlayerDidStartBuffering];
	apView = [[NIKAudioPlayerView alloc] init];

}

- (void)play
{
    if (player)
    {
        [player play];
		
        if (delegate && [delegate respondsToSelector:@selector(audioPlayerDidStartPlaying)])
            [delegate audioPlayerDidStartPlaying];
    }
}

- (void)pause
{
    if (player)
    {
        [player pause];
		
        if (delegate && [delegate respondsToSelector:@selector(audioPlayerDidPause)])
            [delegate audioPlayerDidPause];
    }
}

- (void) fastForward
{
	self.currentPlaybackTime += 15.0f;
}

- (void) rewind
{
	self.currentPlaybackTime -= 15.0f;
}

- (BOOL)isPlaying
{
    NSLog(@"%f", player.rate);
    return (player.rate > 0);
}

#pragma mark - AV player

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == player && [keyPath isEqualToString:@"status"])
    {
        if (player.status == AVPlayerStatusReadyToPlay)
        {
            [self play];
        }
    }
}

///* ---------------------------------------------------------
// **  Get the duration for a AVPlayerItem.
// ** ------------------------------------------------------- */
//
//- (CMTime)playerItemDuration
//{
//	AVPlayerItem *playerItem = [player currentItem];
//	if (playerItem.status == AVPlayerItemStatusReadyToPlay)
//	{
//        /*
//         NOTE:
//         Because of the dynamic nature of HTTP Live Streaming Media, the best practice
//         for obtaining the duration of an AVPlayerItem object has changed in iOS 4.3.
//         Prior to iOS 4.3, you would obtain the duration of a player item by fetching
//         the value of the duration property of its associated AVAsset object. However,
//         note that for HTTP Live Streaming Media the duration of a player item during
//         any particular playback session may differ from the duration of its asset. For
//         this reason a new key-value observable duration property has been defined on
//         AVPlayerItem.
//         
//         See the AV Foundation Release Notes for iOS 4.3 for more information.
//         */
//		
//		return([playerItem duration]);
//	}
//	
//	return(kCMTimeInvalid);
//}
//
//
//
//
//used for fastforwarding and rewinding in audioplayer vc
- (NSTimeInterval)currentPlaybackTime
{
    return CMTimeGetSeconds(player.currentItem.currentTime);
}


- (void)setCurrentPlaybackTime:(NSTimeInterval)time
{
    CMTime cmTime = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
    [player.currentItem seekToTime:cmTime];
}

/* Requests invocation of a given block during media playback to update the movie scrubber control. */
-(void)initScrubberTimer
{
	double interval = .1f;
	
	CMTime playerDuration = [[NIKAudioPlayer sharedAudioPlayer] playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		return;
	}
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration))
	{
		
		CGFloat width = CGRectGetWidth([apView.seekSlider bounds]);
		interval = 0.5f * duration / width;
	}
	
	/* Update the scrubber during normal playback. */
	__unsafe_unretained typeof(self) weakSelf = self;
	mTimeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
																														 queue:NULL /* If you pass NULL, the main queue is used. */
																													usingBlock:^(CMTime time)
														 {
															 [weakSelf syncScrubber];
														 }];
	
}

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
	CMTime playerDuration = [self playerItemDuration];
	if (CMTIME_IS_INVALID(playerDuration))
	{
		apView.seekSlider.minimumValue = 0.0;
		return;
	}
	
	double duration = CMTimeGetSeconds(playerDuration);
	if (isfinite(duration))
	{
		float minValue = [apView.seekSlider minimumValue];
		float maxValue = [apView.seekSlider maximumValue];
		double time = CMTimeGetSeconds([player currentTime]);
		
		[apView.seekSlider setValue:(maxValue - minValue) * time / duration + minValue];
	}
}

/* The user is dragging the movie controller thumb to scrub through the movie. */
- (void)beginScrubbing
{
	mRestoreAfterScrubbingRate = [player rate];
	[player setRate:0.f];
	
	/* Remove previous timer. */
	[self removePlayerTimeObserver];
}

/* Set the player current time to match the scrubber position. */
- (void)scrub: (id)sender
{
	if ([sender isKindOfClass:[UISlider class]])
	{
		UISlider* slider = sender;
		
		CMTime playerDuration = [self playerItemDuration];
		if (CMTIME_IS_INVALID(playerDuration)) {
			return;
		}
		
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
			float minValue = [slider minimumValue];
			float maxValue = [slider maximumValue];
			float value = [slider value];
			
			double time = duration * (value - minValue) / (maxValue - minValue);
			
			[player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
		}
	}
}

/* The user has released the movie thumb control to stop scrubbing through the movie. */
- (void)endScrubbing:(id)sender
{
	if (!mTimeObserver)
	{
		CMTime playerDuration = [self playerItemDuration];
		if (CMTIME_IS_INVALID(playerDuration))
		{
			return;
		}
		__unsafe_unretained typeof(self) weakSelf = self;
		double duration = CMTimeGetSeconds(playerDuration);
		if (isfinite(duration))
		{
			CGFloat width = CGRectGetWidth([apView.seekSlider bounds]);
			double tolerance = 0.5f * duration / width;
			
			mTimeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(tolerance, NSEC_PER_SEC) queue:NULL usingBlock:
							  ^(CMTime time)
							  {
								  [weakSelf syncScrubber];
							  }];
		}
	}
	
	if (mRestoreAfterScrubbingRate)
	{
		[player setRate:mRestoreAfterScrubbingRate];
		mRestoreAfterScrubbingRate = 0.f;
	}
}

- (BOOL)isScrubbing
{
	return mRestoreAfterScrubbingRate != 0.f;
}

-(void)enableScrubber
{
    apView.seekSlider.enabled = YES;
}

-(void)disableScrubber
{
    apView.seekSlider.enabled = NO;
}

/* Cancels the previously registered time observer. */
-(void)removePlayerTimeObserver
{
	if (mTimeObserver)
	{
		[player removeTimeObserver:mTimeObserver];
		mTimeObserver = nil;
	}
}

#pragma mark - Private methods

- (void)playerItemDidFinishPlaying:(id)sender
{
    NSLog(@"%@", sender);
	
    if (delegate && [delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying)])
        [delegate audioPlayerDidFinishPlaying];
}

+ (NIKAudioPlayer *)sharedAudioPlayer
{
    static dispatch_once_t pred;
    static NIKAudioPlayer *sharedAudioPlayer = nil;
    dispatch_once(&pred, ^
				  {
					  sharedAudioPlayer = [[self alloc] init];
					  
					  [[NSNotificationCenter defaultCenter] addObserver:sharedAudioPlayer selector:@selector(playerItemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
				  });
    return sharedAudioPlayer;
}

@end
