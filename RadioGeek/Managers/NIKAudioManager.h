//
//  NIKAudioManager.h
//  RadioGeek
//
//  Created by Neeku on 10/29/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NIKDetailViewController.h"

@interface NIKAudioManager : NSObject <AVAudioPlayerDelegate>
{
	NSURL *url;
	NSURLRequest * loadRequest;
	NSString* documentPath;
	NSString* filePath;
	NSURL* audioURL;
	NSTimer	*playbackTimer;
	NSTimer	*updateTimer;
	int viewDidLoadCounter;
	NSMutableData *responseData;
	NSUInteger responseDataSize;
	NSFileHandle *file;
	NSString *podcastTitle;

}

@property (nonatomic, strong) NIKDetailViewController *detailViewController;
@property (nonatomic, strong) AVAudioPlayer *soundPlayer;

-(id) initWithURL: (NSURL *) fileURL viewController: (NIKDetailViewController *) detailVC title:(NSString *) title;

- (void) playAudio; //play the audio
- (void) pauseAudio; //pause the audio
- (void) togglePlayPause;
- (void) fastForwardTheAudio;
- (void) rewindTheAudio;
- (void) seekSliderChanged;
- (void) setSliderChanges;
- (void) refreshButton;

@end

extern NIKAudioManager *currentAudioManager;
