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

#define MAINLABEL_TAG 1

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
- (id)initWithFeedURL:(NSString *)feedURL{
 //   self = [super initWithNibName:@"MasterViewController" bundle:Nil];
//- (id) init
	if (self) {
		
    }
    return self;
}


- (void) loadFeedURL
{
	NSString *file = [[NSBundle  mainBundle] pathForResource:@"Feed"
													  ofType:@"plist"];
	NSDictionary *item = [[NSDictionary alloc]initWithContentsOfFile:file];
	NSArray *array = [item objectForKey:@"Root"];
	NSString *feedURL = [[array objectAtIndex:selectedCategory.intValue] objectForKey:@"URL"];
	//		NSURL *url = [NSURL URLWithString:
	//					  [[array objectAtIndex:[selectedCategory intValue]]objectForKey:@"URL"]];
	feedParser = [[NIKFeedParser alloc] initWithFeedURL:feedURL];
}

#pragma mark -
#pragma mark RSSParserDelegate

-(void)parserDidCompleteParsing
{
    [self.tableView reloadData];
    [self stopActivity:nil];
}

-(void)parserHasError:(NSError *)error
{
	NSInteger errorCode = [error code];
	[self stopActivity:nil];
//	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
	
	
	//persian error messages file full path
    NSString * persianErrorsListFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Persian.strings"];
    //Load file as dictionary
    NSDictionary * persianErrorsList = [[NSDictionary alloc] initWithContentsOfFile:persianErrorsListFile];
	
	NSString *errorKey = [NSString stringWithFormat:@"Err%ld", (long)errorCode];
	NSString *errorMessage = persianErrorsList[errorKey];
		
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:errorMessage delegate:self cancelButtonTitle:CANCEL_BUTTON_TITLE otherButtonTitles:Nil, nil];
	[alertView show];

}





- (void)loadPodcastsList
{
    NSString *file = [[NSBundle  mainBundle] pathForResource:@"Feed"
                                                      ofType:@"plist"];
    NSDictionary *item = [[NSDictionary alloc]initWithContentsOfFile:file];
    NSArray *array = [item objectForKey:@"Root"];
    NSString *categoryName = [NSString stringWithString:
							  [[array objectAtIndex:[selectedCategory intValue]]objectForKey:@"Name"]];
	globalFeedName = [categoryName copy];
//    titleView.label.text = categoryName;
    
//    feedParser = [[NIKFeedParser alloc] init];
//    [[self feedParser] setSelectedCategory:[self selectedCategory]];
//    [[self feedParser] setDelegate:self];
//    [[self feedParser] startProcess];

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

	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
	{
		// first launch code
		
	}
	infoButton = [[UIBarButtonItem alloc] initWithCustomView:[UIButton buttonWithType:UIButtonTypeInfoDark]];

	
	
	[self loadFeedURL];
	// Do any additional setup after loading the view, typically from a nib.
	//Create an instance of activity indicator view
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	activityIndicator.color = [UIColor purpleColor];
    //set the initial property
    [activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
	//Create an instance of Bar button item with custome view which is of activity indicator
	barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    //Set the bar button the navigation bar
    [self navigationItem].rightBarButtonItem = barButton;

	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:Nil];
	if (activityIndicator.hidden)
	{
		[self navigationItem].rightBarButtonItem = refreshButton;
	}
	
//	[self navigationItem].leftBarButtonItem = infoButton;
//	infoButton.action = [self loadView];
	[feedParser setDelegate:self];
    [feedParser startProcess];
    [self startActivity:nil];
	
	
//	self.detailViewController = (NIKDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
//	
//    feedParser = [[NIKFeedParser alloc] init];
//    [[self feedParser] setSelectedCategory:[self selectedCategory]];
//    [[self feedParser] setDelegate:self];
//    [[self feedParser] startProcess];
	
	
	self.title = NAV_BAR_TITLE;
	[self loadPodcastsList];

}

-(void)startActivity:(id)sender{
    //Send startAnimating message to the view
	[activityIndicator startAnimating];
//    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
}

-(void)stopActivity:(id)sender{
    //Send stopAnimating message to the view
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
//    [activityIndicator stopAnimating];
//	[activityIndicator hidesWhenStopped];
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

    static NSString *CellIdentifier = @"FeedItemCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:CellIdentifier];
	}
	else
	{

	}
	
	
	NIKFeedEntry *entry = [[[self feedParser] feedItems] objectAtIndex:indexPath.row];
	
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
		podcastName = [[entry podcastTitle] substringFromIndex:[[entry podcastTitle] rangeOfString:@"،"].location+2];
	//merges the podcast number and title
	
	NSString *podcastNumber = [NSString stringWithFormat:@"%ld",(long)number];
	NSString *title = [podcastNumber stringByAppendingFormat:@". %@",podcastName];

	UILabel *titleLabel;
	titleLabel = [[UILabel alloc] initWithFrame:TITLE_LABEL_FRAME];
	titleLabel.textAlignment = NSTextAlignmentRight;
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
	titleLabel.text = [NSHFarsiNumerals convertNumeralsToFarsi:title];;
	[cell.contentView addSubview:titleLabel];

	//converts the podcast date from gregorian calendar to persian calendar, with the correct formatting
	NSCalendar *jalali = [[NSCalendar alloc] initWithCalendarIdentifier:NSPersianCalendar];
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	[formatter setDateFormat:@"yyyy/MM/dd"];
	[formatter setCalendar:jalali];

	UILabel *dateLabel;
	dateLabel = [[UILabel alloc] initWithFrame:DATE_LABEL_FRAME];
	dateLabel.text = [NSHFarsiNumerals convertNumeralsToFarsi:[formatter stringFromDate:[entry podcastDate]]];;
	dateLabel.font = [UIFont fontWithName:@"Arial" size:14];
	[cell.contentView addSubview:dateLabel];

	return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"showDetail"])
	{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		NIKDetailViewController *detailViewController = (NIKDetailViewController *) segue.destinationViewController;
		
		[detailViewController setFeedEntry:[[[self feedParser] feedItems] objectAtIndex:indexPath.row]];
		
    } else {
        NSLog(@"Segue Identifier: %@", segue.identifier);
    }
	
}

#pragma mark - Fetched results controller



/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
   
}

+ (NIKMasterViewController *)sharedController
{
	static NIKMasterViewController* staticVar = nil;
	
	if (staticVar == nil)
		staticVar = [[NIKMasterViewController alloc] init];
	return staticVar;
	
}


@end
