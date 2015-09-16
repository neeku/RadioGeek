//
//  NIKMasterViewController.h
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "NIKFeedEntry.h"
#import "NIKFeedParser.h"

@class NIKDetailViewController;



@interface NIKMasterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NIKFeedParserDelegate>
{
	NSMutableArray *allEntries;
}
@property (strong, nonatomic) NIKDetailViewController *detailViewController;

@property (retain) NSMutableArray *allEntries;

@property (nonatomic) NIKFeedParser *feedParser;
@property (nonatomic) NSString *selectedCategory;
@property (nonatomic) NSString *parseFinished;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIBarButtonItem *barButton;
@property (nonatomic) IBOutlet UIBarButtonItem *infoButton;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void) loadPodcastsList;
- (id)initWithFeedURL:(NSString *)feedURL;

+ (NIKMasterViewController *)sharedController;


@end

@protocol RSSParserDelegate <NSObject>

- (void)parserDidCompleteParsing;
- (void)parserHasError:(NSError *)error;

@end