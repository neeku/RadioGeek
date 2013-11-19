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
#import "MKPersianFont.h"

@class NIKDetailViewController;



@interface NIKMasterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NIKFeedParserDelegate, NSObject>
{
	NSMutableArray *allEntries;
	MKPersianFont *myFont;
	NIKFeedEntry *entry;
	NSString *dataPath;
	NSMutableArray *urlArray;
	NSError *errooor;


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

- (id)initWithFeedURL:(NSString *)feedURL;

+ (NIKMasterViewController *)sharedController;


@end

@protocol RSSParserDelegate <NSObject>

- (void)parserDidCompleteParsing;
- (void)parserHasError:(NSError *)error;

@end