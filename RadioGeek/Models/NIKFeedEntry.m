//
//  NIKFeedEntry.m
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKFeedEntry.h"


@implementation NIKFeedEntry

@synthesize lastBuildDate;
@synthesize radioTitle;
@synthesize podcastTitle;
@synthesize podcastDate;
@synthesize podcastURL;

@synthesize podcastAuthor;
@synthesize podcastContent;
@synthesize podcastGUID;
@synthesize podcastDownloadURL;
@synthesize podcastLinkURL;
@synthesize podcastSummary;
@synthesize categories;
@synthesize downloadManager;
@synthesize audioManager;

- (id)initWithPodcastTitle:(NSString *)aPodcastTitle podcastDate:(NSDate *)aPodcastDate podcastGUID:(NSString *)aPodcastGUID podcastSummary:(NSString *)aPodcastSummary podcastContent:(NSString *)aPodcastContent podcastDownloadURL:(NSString *)aPodcastDownloadURL
{
	[self setPodcastTitle: aPodcastTitle];
	[self setPodcastDate: aPodcastDate];
	[self setPodcastGUID: aPodcastGUID];
	[self setPodcastSummary: aPodcastSummary];
	[self setPodcastContent: aPodcastContent];
	[self setPodcastDownloadURL: aPodcastDownloadURL];

	return self;
}

//- (NSString *)description{
//    NSMutableString * description = [NSMutableString stringWithFormat:@"Title:%@",self.podcastTitle];
//    [description appendFormat:@"\nguid:%@",self.podcastGUID];
//    [description appendFormat:@"\nLink:%@",self.podcastLinkURL];
//    [description appendFormat:@"\nDate:%@",[self.podcastDate description]];
//    [description appendFormat:@"\nAuthor:%@",self.podcastAuthor];
//    [description appendFormat:@"\nCategory:%@",self.categories];
//    [description appendFormat:@"\nObject:%@",[super description]];
//	[description appendFormat:@"\nContent:%@",self.podcastContent];
//	[description appendFormat:@"\nEnclosure:%@",self.podcastDownloadURL];
//    return description;
//}

- (void) addPodcastCategory:(NSString *)value
{
	if (categories==nil) {
		categories = [[NSMutableArray alloc] init];
	}
	[categories addObject:value];
	
}

+ (NIKFeedEntry *)sharedEntry
{
	static NIKFeedEntry* staticVar = nil;
	
	if (staticVar == nil)
		staticVar = [[NIKFeedEntry alloc] init];
	return staticVar;
	
}

@end

