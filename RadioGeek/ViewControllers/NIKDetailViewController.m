//
//  NIKDetailViewController.m
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKDetailViewController.h"
#import "NSString_StripHTML.h"
#import "RadioGeek.h"
#import "NSHFarsiNumerals.h"
#import "NIKAppDelegate.h"
#import "NIKDownloadManager.h"
#import "NIKAudioManager.h"


@implementation NIKDetailViewController

@synthesize feedEntry;
@synthesize selectedItem;
@synthesize downloadButton;
@synthesize progressView;
@synthesize currentURL;
@synthesize seekSlider;
@synthesize playPauseButton;
@synthesize fastForward;
@synthesize fastRewind;
@synthesize volumeView;
@synthesize loadRequest;
@synthesize currentFileName;
@synthesize downloadView;
@synthesize audioView;
@synthesize descriptionText;
@synthesize speakerMinimum;
@synthesize speakerMaximum;
@synthesize titleLabel;
@synthesize currentTime;
@synthesize remainingTime;
@synthesize playerButton;
#pragma mark - Managing the view


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedItem = [[NSString alloc]init];
    }
    return self;
}

- (NIKAppDelegate *) appDelegate
{
	// Get the instance of your delegate created by the framework when the app starts
	NIKAppDelegate* appDelegate = (NIKAppDelegate*)[[UIApplication sharedApplication] delegate];
	return appDelegate;
}


- (IBAction)downloadTheFile:(id)sender
{
	downloadButton.enabled = NO;
	progressView.progress = 0.0;
	
    currentURL=[feedEntry podcastDownloadURL];
	currentFileName = [currentURL lastPathComponent];
	
	feedEntry.downloadManager = [[NIKDownloadManager alloc] initWithURL:[NSURL URLWithString:currentURL] viewController:self];
}

- (BOOL) fileExists
{
	//checks to see if the file is already downloaded and exists in the downloads folder of the app.
	NSString* audioFile = [[[self appDelegate] applicationDocumentsDirectory] stringByAppendingPathComponent:[[feedEntry podcastDownloadURL] lastPathComponent]];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:audioFile];
	return fileExists;
}


#pragma mark - Managing the Audio Playback

- (IBAction)togglePlayingState:(id)button
{
	[feedEntry.audioManager togglePlayPause];

}

//- (void) seekingBegan
//{
//	// Fast skip the music when user scrolls the slider
//	[soundPlayer stop];
//}
//
//- (void) seekingEnded
//{
//	[soundPlayer setCurrentTime:seekSlider.value];
//	[soundPlayer prepareToPlay];
//	[soundPlayer play];
//
//}

- (IBAction)sliderChanged:(UISlider *)sender
{
	[feedEntry.audioManager seekSliderChanged];
}


- (IBAction)forwardAudio:(id)sender
{
	[feedEntry.audioManager fastForwardTheAudio];
}

- (IBAction)rewindAudio:(id)sender
{
	[feedEntry.audioManager rewindTheAudio];
}



//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl)
	{
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
		{
            [feedEntry.audioManager playAudio];
        }
		else if (event.subtype == UIEventSubtypeRemoteControlPause)
		{
            [feedEntry.audioManager pauseAudio];
        }
		else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
		{
            [feedEntry.audioManager togglePlayPause];
        }
		else if (event.subtype == UIEventSubtypeRemoteControlBeginSeekingBackward)
		{
			[feedEntry.audioManager rewindTheAudio];
		}
		else if (event.subtype == UIEventSubtypeRemoteControlBeginSeekingForward)
		{
			[feedEntry.audioManager fastForwardTheAudio];
		}
//		else if (event.subtype == UIEventSubtypeRemoteControlEndSeekingBackward)
//		{
//			[self seekingEnded];
//		}
    }
}



#pragma mark - Managing the view


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
	
	//todo: change it to yes
	[downloadView setHidden:NO];
	[audioView setHidden:NO];
	
	downloadView.backgroundColor = [UIColor whiteColor];
	
	
	NSString *content = [[feedEntry podcastContent] stripHtml];
    
	NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"–-:"];
	NSString *podcastName;
	
	//gets the podcast mp3 file name
	NSString *fileName = [[[feedEntry podcastDownloadURL] lastPathComponent] stringByDeletingPathExtension];
	//fetches the difits out of the file name
	NSString *fileNumber = [[fileName componentsSeparatedByCharactersInSet:
							 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
							componentsJoinedByString:@""];
	//converts the fetched decimal string to integer to avoid having '0' at the beginning of a number.
	NSInteger number = [fileNumber integerValue];
	
	//substrings the podcast name from the whole title
	if ([[feedEntry podcastTitle] rangeOfCharacterFromSet:charSet].location != NSNotFound)
	{
		podcastName = [[feedEntry podcastTitle] substringFromIndex:[[feedEntry podcastTitle] rangeOfCharacterFromSet:charSet].location+2];
	}
	else
	{
		podcastName = [[feedEntry podcastTitle] substringFromIndex:[[feedEntry podcastTitle] rangeOfString:@"،"].location+2];
	}
	//merges the podcast number and title
	NSString *podcastNumber = [NSString stringWithFormat:@"%ld",(long)number];
	
	NSString *title = [NSHFarsiNumerals convertNumeralsToFarsi:[podcastNumber stringByAppendingFormat:@". %@",podcastName]];
	
	titleLabel.text = title;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	
	descriptionText.text = content;
	[descriptionText setTextAlignment:NSTextAlignmentCenter];
	[descriptionText setFont:[UIFont fontWithName:@"BNazanin" size:14.0]];
	
	[downloadView addSubview:downloadButton];
	[downloadView addSubview:progressView];

	if (!feedEntry.audioManager) {
		currentFileName = [[feedEntry podcastDownloadURL] lastPathComponent];
		
		filePath = [[[self appDelegate] applicationDocumentsDirectory] stringByAppendingPathComponent:currentFileName];
		audioURL = [NSURL fileURLWithPath: filePath];

		feedEntry.audioManager = [[NIKAudioManager alloc] initWithURL:audioURL viewController:self title:[feedEntry podcastTitle]];
	} else {
		((NIKAudioManager *)(feedEntry.audioManager)).detailViewController = self;
	}
	
	[audioView addSubview:playPauseButton];
	[((NIKAudioManager *)(feedEntry.audioManager)) refreshButton];
	[audioView addSubview:seekSlider];
	[audioView addSubview:fastForward];
	[audioView addSubview:fastRewind];
	audioView.userInteractionEnabled = YES;

	//Make sure the system follows our playback status - to support the playback when the app enters the background mode.
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	
	if ([self fileExists])
	{
		[self hideDownloadView];
	}
	
}


- (void)viewWillAppear:(BOOL)animated
{
	
   [feedEntry.audioManager setSliderChanges];
	
}

- (void) hideDownloadView
{
	if (!downloadView.hidden)
	{
		downloadView.hidden = YES;
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Shared Instance

+ (NIKDetailViewController *)sharedController
{
	static NIKDetailViewController *staticVar = nil;
	
	if (staticVar == nil)
		staticVar = [[NIKDetailViewController alloc] init];
	return staticVar;
	
}

@end
