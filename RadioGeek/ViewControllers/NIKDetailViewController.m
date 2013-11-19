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
//#import "NSString+Shaping.h"
#import "NSHFarsiNumerals.h"
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
@synthesize loadRequest;
@synthesize currentFileName;
@synthesize downloadView;
@synthesize audioView;
//@synthesize volumeControl;

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
	downloadButton.highlighted = YES;
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
		downloadView.hidden = YES;
		audioView.hidden = YES;
//		downloadButton.hidden = YES;
//		progress.hidden = YES;
		
		
    }];
    [operation start];
	
}

#pragma mark - Managing the Audio Playback

- (IBAction)volumeDidChange:(UISlider *)slider
{
    //Handle the slider movement
    [audioPlayer setVolume:[slider value]];
}

- (IBAction)togglePlayingState:(id)button
{
    //Handle the button pressing
    [self togglePlayPause];
}



- (void)playAudio
{
    //Play the audio and set the button to represent the audio is playing
    [audioPlayer play];
    [playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
}

- (void)pauseAudio
{
    //Pause the audio and set the button to represent the audio is paused
    [audioPlayer pause];
    [playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
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
	[downloadView addSubview:downloadButton];
	[downloadView addSubview:progress];
	
	[audioView addSubview:playPauseButton];
	[audioView addSubview:seekSlider];
	[audioView addSubview:fastForward];
	[audioView addSubview:fastRewind];
	
//	NSString *currentPodcastNumber;
//	NSString *currentPodcastName;
//	NSString *currentPodcastTitle;
//	
//	currentPodcastTitle = [feedEntry podcastTitle];
//	NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"–-:،"];
//	if ([currentPodcastTitle rangeOfCharacterFromSet:charSet].location != NSNotFound)
//	{
//		currentPodcastNumber = [currentPodcastTitle substringWithRange:NSMakeRange(0, [currentPodcastTitle rangeOfCharacterFromSet:charSet].location)];
//		currentPodcastName = [currentPodcastTitle substringFromIndex:[currentPodcastTitle rangeOfCharacterFromSet:charSet].location];
//	}
//	else
//		currentPodcastName = [currentPodcastTitle substringFromIndex:[currentPodcastTitle rangeOfString:@"،"].location+2];

	//Make sure the system follows our playback status - to support the playback when the app enters the background mode.
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];

	
	//checks to see if the file is already downloaded and exists in the documents folder of the app.
	NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* audioFile = [documentsPath stringByAppendingPathComponent:[[feedEntry podcastDownloadURL] lastPathComponent]];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:audioFile];

	if (fileExists) {
		downloadView.hidden = YES;
		audioView.hidden = NO;
	}
	else
	{
		downloadView.hidden = NO;
		audioView.hidden = YES;
	}
	
	self.navigationItem.title = NAV_BAR_TITLE;

	[self loadWebView];
	[self streamAudio];
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

//- (void) toggleSubViews
//{
//	if (downloadView.hidden && !audioView.hidden)
//	{
//		downloadView.hidden = NO;
//		audioView.hidden = YES;
//	}
//	else if (!downloadView.hidden && audioView.hidden)
//	{
//		downloadView.hidden = YES;
//		audioView.hidden = NO;
//	}
//}


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
	// If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    NSString *path = [[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"htmlPattern" ofType:@"html"]];
    
    /*
     /Users/nshamekhi/Library/Application Support/iPhone Simulator/5.0/Applications/FE14D377-4835-4458-A87F-D78FD49775B6/Javan.app */
	//	NSString *paths = [[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"table-web-bgP" ofType:@"png"]];
    //NSLog(@"path=%@",paths);
    NSError *error;
    NSString *pattern = [[NSString alloc]initWithContentsOfFile:path
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
	//    NSLog(@"pattern=%@",pattern);
    
	
    NSString *backgroundPath = [[NSBundle mainBundle] pathForResource:@"Background" ofType:@"png"];
    NSURL    *backgroundURL  = [NSURL fileURLWithPath:backgroundPath];
    NSString *htmlPage;
    NSString *fullDescription = [[feedEntry podcastContent] stripHtml];
    //NSLog(@"shortened text:%@", shortenedFullDescription);
    
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
	NSString *title = [podcastNumber stringByAppendingFormat:@". %@",podcastName];
	title = [NSHFarsiNumerals convertNumeralsToFarsi:title];

	
	
    htmlPage = [[NSString  alloc]initWithFormat:pattern,
                backgroundURL,
                title,
                [feedEntry podcastURL],
                fullDescription];
	//    webView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 240, 120, 120)];
    [webView loadHTMLString:htmlPage baseURL:[NSURL URLWithString:path]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pattern]]];
	
    
	webView.userInteractionEnabled  = YES;
    
	
    //if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= __IPHONE_5_0  ) {
	//       webView.scrollView.contentSize=CGSizeMake(1000, 1500); //NOT COMPATIBLE WITH OLDER iOS VERSIONS.
	//   webView.scrollView.maximumZoomScale = 6;              //NOT COMPATIBLE WITH OLDER iOS VERSIONS.
	
	//  }
	
    
    webView.scalesPageToFit = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight
    |UIViewAutoresizingFlexibleBottomMargin ;
    [webView setOpaque:NO];
	
    //webView.scrollView.minimumZoomScale = 0.5;            //NOT COMPATIBLE WITH OLDER iOS VERSIONS.
    
	//    webView.backgroundColor = [UIColor whiteColor];
    
    self.webView.delegate = self;
	//    self.view =webView;
	//
	//    if (!globalFeedName)
	//    {
	//        globalCategoryName = [[NSString alloc] init];
	//    }
    
    
	
	//    UIView *titleView = [[UIView alloc]initWithFrame:TITLE_Frame];
	//    titleView.backgroundColor = [UIColor clearColor];
	//    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
