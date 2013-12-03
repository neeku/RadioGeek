//
//  NIKMasterViewController.h
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "NIKFeedEntry.h"
#import "NIKFeedParser.h"

@class NIKDetailViewController;



@interface NIKMasterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NIKFeedParserDelegate, NSObject>
{
	NSMutableArray *allEntries;
	NIKFeedEntry *entry;
	NSString *dataPath;
	NSMutableArray *urlArray;
	NSError *errooor;
	NSMutableArray *GUIDs;

}
@property (strong, nonatomic) NIKDetailViewController *detailViewController;

@property (retain) NSMutableArray *allEntries;

@property (nonatomic) NIKFeedParser *feedParser;
@property (nonatomic) NSString *selectedCategory;
@property (nonatomic) NSString *parseFinished;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIBarButtonItem *barButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, copy) NSString *dataPath;
@property (nonatomic, retain) NSMutableArray *urlArray;
@property (nonatomic, strong) NSURL *RSSURL;

@property (nonatomic) BOOL isAlreadyLoaded;

- (void) loadFeedURL;
+ (NIKMasterViewController *)sharedController;


@end

@protocol RSSParserDelegate <NSObject>

- (void)parserDidCompleteParsing;
- (void)parserHasError:(NSError *)error;

@end