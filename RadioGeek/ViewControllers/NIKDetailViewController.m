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

static AVAudioPlayer *soundPlayer;

@implementation NIKDetailViewController

@synthesize feedEntry;
@synthesize selectedItem;
@synthesize webView;
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
/*
 NSMutableURLRequest * request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL_TO_DOWNLOAD]] autorelease];
 [request setHTTPMethod:@"GET"];
 
 NSURLConnection * conn = [NSURLConnection connectionWithRequest:request delegate:self];
 if(conn)
 responseData = [[NSMutableData data] retain];
 else
 NSLog(@":(");
*/


#pragma mark - Managing the File Download


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//This method is called when the download begins.
    //You can get all the response headers
	//make sure we have a 2xx reponse code
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	
    if ([httpResponse statusCode]/100 == 2)
	{
		//file exists on the server
		[responseData setLength:0];
		responseDataSize = (NSUInteger)[response expectedContentLength];
		

    } else {
		//file does not exist on the server - Error 404
		[connection cancel];
		//show error alert view
		alertView = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:ERROR_MESSAGE delegate:self cancelButtonTitle:CANCEL_BUTTON_TITLE otherButtonTitles:Nil, nil];
		[alertView show];
		
		//reset download view
		downloadButton.enabled = YES;
		progressView.progress = 0.0;

		
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    float progress = (float)[responseData length] / (float)responseDataSize;
    progressView.progress = progress;
	[responseData appendData:data];
	
	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    alertView = [[UIAlertView alloc] initWithTitle:@"Done"
                                                         message:@"Download complete."
                                                        delegate:nil
                                               cancelButtonTitle:@"Cool" otherButtonTitles:nil];
    [alertView show];
	
	//creates the file in Documents folder and writes it there
	currentURL=[feedEntry podcastDownloadURL];
	currentFileName = [currentURL lastPathComponent];
	NSString *fileName = currentFileName;
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *folder = [pathArr objectAtIndex:0];
	
    NSString *path = [folder stringByAppendingPathComponent:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSError *writeError = nil;
	
    [responseData writeToURL: fileURL options:0 error:&writeError];
	downloadView.hidden = YES; //hide the download view once downloading is finished
    if( writeError) {
        NSLog(@" Error in writing file %@' : \n %@ ", path , writeError );
        return;
    }
    NSLog(@"%@",fileURL);
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[error localizedDescription];
	NSLog(@"%@", [error localizedDescription]);
	NSInteger errorCode = [error code];

	//persian error messages file full path
	NSString * persianErrorsListFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Persian.strings"];
	//Load file as dictionary
	NSDictionary * persianErrorsList = [[NSDictionary alloc] initWithContentsOfFile:persianErrorsListFile];
	
	NSString *errorKey = [NSString stringWithFormat:@"Err%ld", (long)errorCode];
	NSString *errorMessage = persianErrorsList[errorKey];
	alertView = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:errorMessage delegate:self cancelButtonTitle:CANCEL_BUTTON_TITLE otherButtonTitles:nil, nil];
	[alertView show];
	downloadButton.enabled = YES;
	progressView.progress = 0.0;
	
}


- (IBAction)downloadTheFile:(id)sender
{
//	downloadButton.highlighted = YES;
	downloadButton.enabled = NO;
	progressView.progress = 0.0;
	
    currentURL=[feedEntry podcastDownloadURL];
	currentFileName = [currentURL lastPathComponent];
	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:currentURL]];
	[request setHTTPMethod:@"GET"];
	
	NSURLConnection * conn = [NSURLConnection connectionWithRequest:request delegate:self];
	if(conn)
		responseData = [NSMutableData data];
	
	else
		NSLog(@":(");

}

#pragma mark - Managing the Audio Playback

- (IBAction)togglePlayingState:(id)button
{
    //Handle the button pressing
//	NSLog(@"player url:%@",soundPlayer.url.lastPathComponent);
//	NSLog(@"my url:%@",filePath.lastPathComponent);
//	if (tapCounter == 0)
//	{
//		if (!soundPlayer.url && !filePath.lastPathComponent && soundPlayer.url.lastPathComponent != audioURL.lastPathComponent)
//		{
//			[self streamAudio];
//		}
//	}
//	tapCounter++;
	
	[self togglePlayPause];
}



- (IBAction)showAudioPlayerView:(id)sender
{
	if (audioView.hidden)
	{
		audioView.hidden = NO;
		[self streamAudio];
		playerButton.hidden = YES;
	}
}

- (void)playAudio
{

	
    //Play the audio and set the button to represent the audio is playing
	if ([soundPlayer isPlaying])
    {
        [soundPlayer pause];
		[playPauseButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [self deleteTimer];
    }
    else
    {
        [self createTimer];
        [soundPlayer play];
		[playPauseButton setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    }
	

}

- (void)pauseAudio
{
    //Pause the audio and set the button to represent the audio is paused
    [soundPlayer pause];
	[playPauseButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
	[self deleteTimer];
}

//- (void)stopAudio
//{
//	if(audioPlayer && [audioPlayer isPlaying]){
//		[audioPlayer stop];
//		audioPlayer=nil;
//	}
//}

- (void)streamAudio
{
	

	soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
	[soundPlayer setVolume:1.0];
	
	
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
		
}


- (void)getTime:(NSTimer *)timer
{
    [seekSlider setValue:soundPlayer.currentTime];
   
    remainingTime.text = [NSString stringWithFormat:@"%d:%02d", (int)(soundPlayer.duration - soundPlayer.currentTime) / 60, (int)(soundPlayer.duration - soundPlayer.currentTime) % 60, nil];
	currentTime.text = [NSString stringWithFormat:@"%d:%02d", (int) soundPlayer.currentTime/60, (int)soundPlayer.currentTime % 60, nil];
}

- (void)createTimer
{
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(getTime:) userInfo:nil repeats:YES];
}

- (void)deleteTimer
{
    [playbackTimer invalidate];
	playbackTimer = nil;
}

- (void)updateSlider
{
	// Update the slider about the music time
	seekSlider.value = soundPlayer.currentTime;
}

- (IBAction)sliderChanged:(UISlider *)sender
{
	// Fast skip the music when user scrolls the slider
	[soundPlayer stop];
	[soundPlayer setCurrentTime:seekSlider.value];
	[soundPlayer prepareToPlay];
	[soundPlayer play];
}

// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	// Music completed
	if (flag)
	{
		[playbackTimer invalidate];
	}
}


- (IBAction)forwardAudio:(id)sender
{
	int current = [soundPlayer currentTime];
	[soundPlayer setCurrentTime:current+10];
}

- (IBAction)rewindAudio:(id)sender
{
	int current = [soundPlayer currentTime];
	[soundPlayer setCurrentTime:current-10];
}

- (void) togglePlayPause
{
    //Toggle if the music is playing or paused
    if (!soundPlayer.playing)
	{
		
        [self playAudio];
    }
	else if (soundPlayer.playing)
	{
        [self pauseAudio];
    }
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
	
		
	tapCounter = 0;
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
	
	//todo: change it to yes
	[downloadView setHidden:NO];
	[audioView setHidden:YES];
	
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
	
	[audioView addSubview:playPauseButton];
	[audioView addSubview:seekSlider];
	[audioView addSubview:fastForward];
	[audioView addSubview:fastRewind];
	audioView.userInteractionEnabled = YES;
	

	//Make sure the system follows our playback status - to support the playback when the app enters the background mode.
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	
	
	
	//checks to see if the file is already downloaded and exists in the documents folder of the app.
	NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* audioFile = [documentsPath stringByAppendingPathComponent:[[feedEntry podcastDownloadURL] lastPathComponent]];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:audioFile];
	
	if (fileExists)
	{
		[self hideDownloadView];
	}
	
	currentFileName = [[feedEntry podcastDownloadURL] lastPathComponent];
	
	documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	filePath = [documentPath stringByAppendingPathComponent:currentFileName];
	audioURL = [NSURL fileURLWithPath: filePath];
//	if (soundPlayer.isPlaying)
//	{
//		if (![soundPlayer.url isEqual:audioURL])
//		{
////			[soundPlayer stop];
//			soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
//			[soundPlayer prepareToPlay];
//			
//		}
//	
//	if (!soundPlayer)
//	{
//		
//		[self streamAudio];
//	}
//	else if (![soundPlayer.url isEqual:audioURL])
//	{
//		[self streamAudio];
//	}
	
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
	
	// Set a timer which keep getting the current music time and update the UISlider in 1 sec interval
	playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	// Set the maximum value of the UISlider
	seekSlider.maximumValue = soundPlayer.duration;
	
	
	
	
	// Set the valueChanged target
	[seekSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];

	
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
