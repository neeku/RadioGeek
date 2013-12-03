//
//  NIKFeedParser.h
//  RadioGeek
//
//  Created by Neeku on 10/27/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIKFeedEntry.h"
#import "NSString_StripHTML.h"

@class NIKFeedEntry;
@protocol NIKFeedParserDelegate;


@interface NIKFeedParser : NSObject <NSXMLParserDelegate, NSCoding>
{
	NIKFeedEntry *currentItem;
	NSMutableString *currentItemValue;
	NSMutableArray *feedItems;
	id<NIKFeedParserDelegate> delegate;
	NSOperationQueue *retrieverQueue;
	NSUInteger parsingFeedsWithNumbers;
	NSOperationQueue *queue;
	NIKFeedEntry *lbDate;
	NSDate *RSSLastBuildDate;
	NSString *lbd;
    NSString *feedURL;
	NSMutableData *downloadedData;
    BOOL parseElement;
	NSMutableString * parsedElementString;
    NSMutableData * parsedElementData;
	NSString *downloadURL;
	NSDate *lastModified;
	NSArray *paths;
	NSString *folder;
	NSString *fileName;
	NSString *path;
	NSURL *fileURL;
	
}

@property (strong, nonatomic) NIKFeedEntry *currentItem;
@property (strong, nonatomic) NSMutableString *currentItemValue;
@property (readonly) NSMutableArray *feedItems;
@property (strong, nonatomic) id<NIKFeedParserDelegate> delegate;
@property (strong, nonatomic) NSOperationQueue *retrieverQueue;
@property (nonatomic) NSUInteger parsingFeedsWithNumbers;
@property (strong, nonatomic) NSOperationQueue *queue;

@property (nonatomic) NSString *selectedCategory;

@property (nonatomic, retain) NSString *feedURL;

@property (strong, nonatomic) NSString *downloadURL;

@property (nonatomic, retain) NSDate *lastModified;
@property(nonatomic, retain) NSURL * RSSURL;
@property (nonatomic) NSMutableArray *updatedGUIDs;
@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSDictionary *item;
@property (nonatomic) NSMutableDictionary *guidDictionary;
- (void) startProcess;
- (void) startParsing;
- (id)initWithRSSURL:(NSURL *)rssURL;
+ (NIKFeedParser *)sharedParser;


@end

@protocol NIKFeedParserDelegate <NSObject>

-(void)parserDidCompleteParsing;
-(void)parserHasError:(NSError *)error;

@end
