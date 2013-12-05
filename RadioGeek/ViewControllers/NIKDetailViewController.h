//
//  NIKDetailViewController.h
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIKFeedEntry.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NIKMasterViewController.h"
#import "NIKPlayer.h"

@interface NIKDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate, UIScrollViewDelegate, NSURLConnectionDelegate, AVAudioPlayerDelegate>
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
	UIAlertView *alertView;
	float progress;
//	UISlider *volumeControl; //Sets the volume for the audio player

}

@property (strong, nonatomic) id detailItem;

@property (nonatomic) NIKFeedEntry *feedEntry;
@property (nonatomic) NSString *selectedItem;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UISlider *seekSlider;
@property (nonatomic, retain) IBOutlet UIButton *fastForward;
@property (nonatomic, retain) IBOutlet UIButton *fastRewind;
@property (nonatomic, retain) IBOutlet UIView *downloadView;
@property (weak, nonatomic) IBOutlet MPVolumeView *volumeView;
@property (nonatomic, retain) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//@property (nonatomic, retain) IBOutlet UISlider *volumeControl; //Sets the volume for the audio player

@property (weak, nonatomic) IBOutlet UIImageView *speakerMinimum;
@property (weak, nonatomic) IBOutlet UIImageView *speakerMaximum;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *remainingTime;


@property (nonatomic, retain) NSURLRequest * loadRequest;

@property (strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) NSString *currentURL;
@property (nonatomic, retain) NSString *currentFileName;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *playerButton;

- (IBAction)downloadTheFile:(id)sender;
- (IBAction)togglePlayingState:(id)button; //handle the button tapping
- (IBAction)forwardAudio:(id)sender;
- (IBAction)rewindAudio:(id)sender;
- (IBAction)showAudioPlayerView:(id)sender;
- (IBAction)sliderChanged:(UISlider *)sender;

+ (NIKDetailViewController *)sharedController;


@end
