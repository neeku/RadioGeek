//
//  NIKDetailViewController.h
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIKFeedEntry.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface NIKDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate, UIScrollViewDelegate, NSURLConnectionDelegate>
{
	NSURL *url;
	NSTimer	*playbackTimer;
	UIWebView *webView;
	NSURLRequest * loadRequest;
//	UISlider *volumeControl; //Sets the volume for the audio player

}

@property (strong, nonatomic) id detailItem;

@property (nonatomic) NIKFeedEntry *feedEntry;
@property (nonatomic) NSString *selectedItem;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UISlider *seekSlider;
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, retain) IBOutlet UIButton *fastForward;
@property (nonatomic, retain) IBOutlet UIButton *fastRewind;
@property (nonatomic, retain) IBOutlet UIView *downloadView;
@property (nonatomic, retain) IBOutlet UIView *audioView;


//@property (nonatomic, retain) IBOutlet UISlider *volumeControl; //Sets the volume for the audio player

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) NSURLRequest * loadRequest;




@property (nonatomic, retain) UIProgressView *progress;
@property (nonatomic, retain) NSString *currentURL;
@property (nonatomic, retain) NSString *currentFileName;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;


- (IBAction)downloadTheFile:(id)sender;
- (IBAction)volumeDidChange:(id)slider; //handle the slider movement
- (IBAction)togglePlayingState:(id)button; //handle the button tapping
- (IBAction)forwardAudio:(id)sender;
- (IBAction)rewindAudio:(id)sender;

- (void)playAudio; //play the audio
- (void)pauseAudio; //pause the audio
- (void)togglePlayPause; //toggle the state of the audio
- (void)streamAudio;

- (void)startActivity:(id)sender;

- (void)stopActivity:(id)sender;

+ (NIKDetailViewController *)sharedController;


@end
