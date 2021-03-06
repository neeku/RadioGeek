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


@interface NIKFeedParser : NSObject <NSXMLParserDelegate>
{
	NIKFeedEntry *currentItem;
	NSMutableString *currentItemValue;
	NSMutableArray *feedItems;
	id<NIKFeedParserDelegate> delegate;
	NSOperationQueue *retrieverQueue;
	NSUInteger parsingFeedsWithNumbers;
	NSOperationQueue *queue;
	
	
    NSString *feedURL;
	
	NSMutableData *downloadedData;
	
    BOOL parseElement;
	NSMutableString * parsedElementString;
    NSMutableData * parsedElementData;
	
	NSString *downloadURL;
	
	NSDate *lastModified;

	
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


- (void) startProcess;

+ (NIKFeedParser *)sharedParser;


@end

@protocol NIKFeedParserDelegate <NSObject>

-(void)parserDidCompleteParsing;
-(void)parserHasError:(NSError *)error;

@end
