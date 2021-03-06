//
//  NIKFeedEntry.h
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIKFeedEntry : NSObject
{
	NSString *radioTitle;
	NSDate *lastBuildDate;
	NSString *podcastTitle;
	NSString *podcastFile;
	NSDate   *podcastDate;
	NSString *podcastGUID;
	NSString *podcastSummary;
	NSString *podcastContent;
	NSString *podcastAuthor;
	NSString *podcastDownloadURL;
	NSString *podcastLinkURL;
	NSMutableArray *categories;
}

@property (nonatomic) NSDate   *lastBuildDate;
@property (nonatomic) NSString *radioTitle;
@property (nonatomic) NSString *podcastTitle;
@property (nonatomic) NSString *podcastURL;
@property (nonatomic) NSDate *podcastDate;

@property (nonatomic) NSString *podcastGUID;
@property (nonatomic) NSString *podcastSummary;
@property (nonatomic) NSString *podcastContent;
@property (nonatomic) NSString *podcastAuthor;
@property (nonatomic) NSString *podcastDownloadURL;
@property (nonatomic) NSString *podcastLinkURL;
@property (nonatomic) NSMutableArray *categories;

@property (nonatomic) id downloadManager;
@property (nonatomic) id audioManager;

- (id)initWithPodcastTitle:(NSString*)podcastTitle podcastDate:(NSDate*)podcastDate podcastGUID:(NSString*)podcastGUID podcastSummary:(NSString*)podcastSummary podcastContent:(NSString*)podcastContent podcastDownloadURL:(NSString*)podcastDownloadURL;

- (void)addPodcastCategory:(NSString *)value;

+ (NIKFeedEntry *)sharedEntry;

@end
