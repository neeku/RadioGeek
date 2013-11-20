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
//#import "SGdownloader.h"

@implementation NIKDetailViewController

@synthesize feedEntry;
@synthesize selectedItem;
@synthesize webView;
@synthesize downloadButton;
@synthesize progress;
@synthesize currentURL;
@synthesize seekSlider;
@synthesize audioPlayer;
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


#pragma mark - Managing the File Download

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //make sure we have a 2xx reponse code
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	
    if ([httpResponse statusCode]/100 == 2)
	{
        NSLog(@"file exists");
    } else {
        NSLog(@"file does not exist");
    }
}

- (IBAction)downloadTheFile:(id)sender
{
//	downloadButton.highlighted = YES;
	downloadButton.enabled = NO;
	progress.progress = 0.0;
	
    currentURL=[feedEntry podcastDownloadURL];
	currentFileName = [currentURL lastPathComponent];
	
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:currentURL]];
    AFURLConnectionOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:currentFileName];

    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];

    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        progress.progress = (float)totalBytesRead / totalBytesExpectedToRead;
		
    }];
	
    [operation setCompletionBlock:^{
        NSLog(@"downloadComplete!");
		[self hideDownloadView];
    }];
    [operation start];
	

}

#pragma mark - Managing the Audio Playback

- (IBAction)togglePlayingState:(id)button
{
    //Handle the button pressing
    [self togglePlayPause];
}



- (void)playAudio
{
    //Play the audio and set the button to represent the audio is playing
    [audioPlayer play];
	[playPauseButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];

}

- (void)pauseAudio
{
    //Pause the audio and set the button to represent the audio is paused
    [audioPlayer pause];
	[playPauseButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
}

- (void)togglePlayPause
{
    //Toggle if the music is playing or paused
    if (!self.audioPlayer.playing)
	{
        [self playAudio];
    }
	else if (self.audioPlayer.playing)
	{
        [self pauseAudio];
    }
}


- (void)streamAudio
{
//	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jadi" ofType:@"mp3"];
	
	currentFileName = [[feedEntry podcastDownloadURL] lastPathComponent];
	
	NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* path = [documentPath stringByAppendingPathComponent:currentFileName];
	NSURL* movieURL = [NSURL fileURLWithPath: path];
	

	
	
//	url = [NSURL fileURLWithPath:currentFileName];
//	url = [NSURL fileURLWithPath:[currentFileName, [NSBundle mainBundle] resourcePath]];
	NSLog(@"%@",currentFileName);
	
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:movieURL error:nil];
//	[theSound setDelegate:self];
	[audioPlayer setVolume:1.0];
	
	
	NSError *error;
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        
//        [[self volumeControl] setEnabled:NO];
        [[self playPauseButton] setEnabled:NO];
        
//        [[self alertLabel] setText:@"Unable to load file"];
//        [[self alertLabel] setHidden:NO];
//    } else {
//        [[self alertLabel] setText:[NSString stringWithFormat:@"%@ has loaded", @"HeadspinLong.caf"]];
//        [[self alertLabel] setHidden:NO];
    }
	// Set a timer which keep getting the current music time and update the UISlider in 1 sec interval
	playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	// Set the maximum value of the UISlider
	seekSlider.maximumValue = audioPlayer.duration;

	
	currentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60, nil];
	remainingTime.text = [NSString stringWithFormat:@"%d:%02d", (int)(audioPlayer.duration - audioPlayer.currentTime) / 60, (int)(audioPlayer.duration - audioPlayer.currentTime) % 60, nil];


	
	// Set the valueChanged target
	[seekSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
	
	[audioPlayer prepareToPlay]; //Add the audio to the memory.
}




- (void)updateSlider
{
	// Update the slider about the music time
	seekSlider.value = audioPlayer.currentTime;
}

- (IBAction)sliderChanged:(UISlider *)sender {
	// Fast skip the music when user scrolls the slider
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


- (IBAction)forwardAudio:(id)sender
{
	int currentTime = [audioPlayer currentTime];
	[audioPlayer setCurrentTime:currentTime+10];
}

- (IBAction)rewindAudio:(id)sender
{
	int currentTime = [audioPlayer currentTime];
	[audioPlayer setCurrentTime:currentTime-10];
}


//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [self playAudio];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [self pauseAudio];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self togglePlayPause];
        }
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
	
	
	
	[downloadView setHidden:NO];

	
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

	
	descriptionText.text = content;
	[descriptionText setTextAlignment:NSTextAlignmentRight];
	[descriptionText setFont:[UIFont fontWithName:@"X Yekan" size:14.0]];
	titleLabel.text = title;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	
	[downloadView addSubview:downloadButton];
	[downloadView addSubview:progress];
	
	[audioView addSubview:playPauseButton];
	[audioView addSubview:seekSlider];
	[audioView addSubview:fastForward];
	[audioView addSubview:fastRewind];
	audioView.userInteractionEnabled = YES;
	

	//Make sure the system follows our playback status - to support the playback when the app enters the background mode.
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	

	[self loadWebView];
	[self streamAudio];
	
	
	//checks to see if the file is already downloaded and exists in the documents folder of the app.
	NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* audioFile = [documentsPath stringByAppendingPathComponent:[[feedEntry podcastDownloadURL] lastPathComponent]];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:audioFile];
	
	if (fileExists)
	{
		[self hideDownloadView];
	}

	
}

- (void)viewWillAppear:(BOOL)animated
{
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
	activityIndicator.color = [UIColor purpleColor];
    //set the initial property
    [activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
    //Create an instance of Bar button item with custome view which is of activity indicator
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    //Set the bar button the navigation bar
    [self navigationItem].rightBarButtonItem = barButton;
}

-(void)startActivity:(id)sender{
    //Send startAnimating message to the view
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
}

-(void)stopActivity:(id)sender{
    //Send stopAnimating message to the view
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
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

#pragma mark - UIWebViewDelegate



- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopActivity:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self startActivity:nil];
}

- (void)loadWebView
{
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
