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



@interface NIKMasterViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NIKFeedParserDelegate, NSObject, UIScrollViewDelegate>
{
	NSMutableArray *allEntries;
	NIKFeedEntry *entry;
	NSString *dataPath;
	NSMutableArray *urlArray;
	NSError *errooor;
	NSMutableArray *GUIDs;
	UIImageView *equalizer;

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

@property (nonatomic, copy) NSString *dataPath;
@property (nonatomic, retain) NSMutableArray *urlArray;
@property (nonatomic, strong) NSURL *RSSURL;

@property (nonatomic) BOOL isAlreadyLoaded;

- (void) loadFeedURL;
+ (NIKMasterViewController *)sharedController;
+ (void) initialize;


@end

@protocol RSSParserDelegate <NSObject>

- (void)parserDidCompleteParsing;
- (void)parserHasError:(NSError *)error;
- (void)markEntryAsPlaying: (NIKFeedEntry*)feedEntry;

@end