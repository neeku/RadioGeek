//
//  NIKMasterViewController.m
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKMasterViewController.h"
#import "NIKAppDelegate.h"
#import "NIKDetailViewController.h"
#import "RadioGeek.h"
#import "NSHFarsiNumerals.h"
#import "RadioGeek.h"
//#import "NSString+Shaping.h"
//#define MAINLABEL_TAG 1
#import "URLCacheAlert.h"

/* cache update interval in seconds */
const double URLCacheInterval = 86400.0;

@interface NIKMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation NIKMasterViewController

@synthesize allEntries;
@synthesize feedParser;
@synthesize selectedCategory;
@synthesize parseFinished;
@synthesize activityIndicator;
@synthesize barButton;
@synthesize infoButton;
@synthesize refreshButton;
@synthesize dataPath;
@synthesize urlArray;
@synthesize isAlreadyLoaded;

- (id)initWithFeedURL:(NSString *)feedURL{
	if (self) {
		
    }
    return self;
}


- (void) loadFeedURL
{
	feedParser = [[NIKFeedParser alloc] init];
	
	[feedParser setDelegate:self];
    [feedParser startProcess];
    [self startActivity:nil];
		
}

#pragma mark -
#pragma mark RSSParserDelegate

-(void)parserDidCompleteParsing
{
    [self.tableView reloadData];
    [self stopActivity:nil];
	GUIDs = [[NSMutableArray alloc] init];
	for (int i=0; i<feedParser.feedItems.count; i++) {
		[GUIDs addObject:[[feedParser.feedItems objectAtIndex:i] podcastGUID]];
	}
	//todo: save the array

}

-(void)parserHasError:(NSError *)error
{
	NSInteger errorCode = [error code];
	[self stopActivity:nil];
//	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
	NSLog(@"error:%@",[error localizedRecoverySuggestion]);
	
	//persian error messages file full path
    NSString * persianErrorsListFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Persian.strings"];
    //Load file as dictionary
    NSDictionary * persianErrorsList = [[NSDictionary alloc] initWithContentsOfFile:persianErrorsListFile];
	
	NSString *errorKey = [NSString stringWithFormat:@"Err%ld", (long)errorCode];
	NSString *errorMessage = persianErrorsList[errorKey];
		
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:errorMessage delegate:self cancelButtonTitle:CANCEL_BUTTON_TITLE otherButtonTitles:Nil, nil];
	[alertView show];

}


#pragma mark - View Lifecycle

- (void)awakeFromNib
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
	    self.clearsSelectionOnViewWillAppear = NO;
	    self.preferredContentSize = CGSizeMake(320.0, 600.0);
	}
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	//Make sure the system follows our playback status - to support the playback when the app enters the background mode.
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	
	// Do any additional setup after loading the view, typically from a nib.
	//Create an instance of activity indicator view
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	activityIndicator.color = [UIColor whiteColor];
    //set the initial property
    [activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
	
	//Create an instance of Bar button item with custome view which is of activity indicator
	barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	//Set the bar button the navigation bar
    [self navigationItem].rightBarButtonItem = barButton;

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
	{
		// first launch code
	}

	[self loadFeedURL];

	//navigation bar title with custom font
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
	self.navigationItem.titleView = titleLabel;
	titleLabel.text = NAV_BAR_TITLE;
	titleLabel.font = [UIFont fontWithName:@"X Vahid" size:15.0];
	titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)loadRefreshButton
{
	barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadFeedURL)];
	self.navigationItem.rightBarButtonItem = barButton;
}

-(void)startActivity:(id)sender
{
    //Send startAnimating message to the view
	[activityIndicator startAnimating];
	barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	self.navigationItem.rightBarButtonItem = barButton;

}

-(void)stopActivity:(id)sender
{
    //Send stopAnimating message to the view
	[activityIndicator stopAnimating];
	[self loadRefreshButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rowCount = [[[self feedParser] feedItems] count];
	return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedItemCell"];
	entry = [[[self feedParser] feedItems] objectAtIndex:indexPath.row];

	//Podcast number and name separator character
	NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"–-:"];
	NSString *podcastName;
	
	//gets the podcast mp3 file name
	NSString *fileName = [[[entry podcastDownloadURL] lastPathComponent] stringByDeletingPathExtension];
	//fetches the difits out of the file name
	NSString *fileNumber = [[fileName componentsSeparatedByCharactersInSet:
							 [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
							componentsJoinedByString:@""];
	//converts the fetched decimal string to integer to avoid having '0' at the beginning of a number.
	NSInteger number = [fileNumber integerValue];
	
	//substrings the podcast name from the whole title
	if ([[entry podcastTitle] rangeOfCharacterFromSet:charSet].location != NSNotFound)
	{
		podcastName = [[entry podcastTitle] substringFromIndex:[[entry podcastTitle] rangeOfCharacterFromSet:charSet].location+2];
	}
	else
	{
		podcastName = [[entry podcastTitle] substringFromIndex:[[entry podcastTitle] rangeOfString:@"،"].location+2];
	}
	//merges the podcast number and title
	NSString *podcastNumber = [NSString stringWithFormat:@"%ld",(long)number];
	NSString *title = [podcastNumber stringByAppendingFormat:@". %@",podcastName];
	title = [NSHFarsiNumerals convertNumeralsToFarsi:title];
	

	//converts the podcast date from gregorian calendar to persian calendar, with the correct formatting
	NSCalendar *jalali = [[NSCalendar alloc] initWithCalendarIdentifier:NSPersianCalendar];
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	[formatter setDateFormat:@"yyyy/MM/dd"];
	[formatter setCalendar:jalali];
	
    UILabel *label;
	//tags are set for each label in storyboard
    label = (UILabel *)[cell viewWithTag:10];
    label.text =  title;
	label.font = [UIFont fontWithName:@"B Nazanin" size:20.0];
    label = (UILabel *)[cell viewWithTag:20];
    label.text = [NSHFarsiNumerals convertNumeralsToFarsi:[formatter stringFromDate:[entry podcastDate]]];
	label.font = [UIFont fontWithName:@"B Nazanin" size:10.0];
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"showDetail"])
	{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		NIKDetailViewController *detailViewController = (NIKDetailViewController *) segue.destinationViewController;
		
		[detailViewController setFeedEntry:[[[self feedParser] feedItems] objectAtIndex:indexPath.row]];
    }
	else
	{
        NSLog(@"Segue Identifier: %@", segue.identifier);
    }
	
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark - Audio control


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}



//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            [[NIKDetailViewController sharedController] playAudio];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            [[NIKDetailViewController sharedController] pauseAudio];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [[NIKDetailViewController sharedController] togglePlayPause];
        }
    }
}


+ (NIKMasterViewController *)sharedController
{
	static NIKMasterViewController* staticVar = nil;
	
	if (staticVar == nil)
		staticVar = [[NIKMasterViewController alloc] init];
	return staticVar;
	
}


@end
