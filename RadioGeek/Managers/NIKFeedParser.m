//
//  NIKFeedParser.m
//  RadioGeek
//
//  Created by Neeku on 10/27/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKFeedParser.h"
#import "NIKMasterViewController.h"

@class NIKMasterViewController;

NIKMasterViewController *masterVC;


@interface NIKFeedParser (Private)

- (NSString *)trimString:(NSString *)originalString;

@end

@implementation NIKFeedParser

@synthesize currentItem;
@synthesize currentItemValue;
@synthesize feedItems;
@synthesize delegate;
@synthesize retrieverQueue;
@synthesize parsingFeedsWithNumbers;
@synthesize queue;
@synthesize selectedCategory;
@synthesize feedURL;
@synthesize downloadURL;
@synthesize lastModified;
@synthesize RSSURL;
@synthesize updatedGUIDs;
@synthesize items;
@synthesize item;
@synthesize guidDictionary;

- (id)initWithRSSURL:(NSURL *)rssURL{
    self = [super init];
    if (self) {
        feedItems = [[NSMutableArray alloc]init];
        RSSURL = rssURL;
    }
    return self;
}


- (NSOperationQueue *)retrieverQueue
{
    if (nil == retrieverQueue)
    {
        retrieverQueue = [[NSOperationQueue alloc] init];
        retrieverQueue.maxConcurrentOperationCount = 1;
    }
    
    return retrieverQueue;
}

- (void) startProcess
{
	feedItems = [[NSMutableArray alloc] init];
	
    NSString *file = [[NSBundle  mainBundle] pathForResource:@"Feed"
													  ofType:@"plist"];
	NSDictionary *theItem = [[NSDictionary alloc]initWithContentsOfFile:file];
	NSArray *array = [theItem objectForKey:@"Root"];
	NSString *theURL = [[array objectAtIndex:selectedCategory.intValue] objectForKey:@"URL"];
	
    NSURL * url = [NSURL URLWithString:theURL];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLConnection * download = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [download start];
}

#pragma mark -
#pragma mark Private Methods


- (NSString *)trimString:(NSString *)originalString
{
    NSString * trimmedString;
    trimmedString  = [originalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //This method is called when the download begins.
    //You can get all the response headers
	
	/* create the NSMutableData instance that will hold the received data */
	
	long long contentLength = [response expectedContentLength];
	if (contentLength == NSURLResponseUnknownLength) {
		contentLength = 500000;
	}
	
	
    if (downloadedData!=nil)
	{
        downloadedData = nil;
    }
    downloadedData = [NSMutableData dataWithCapacity:(NSUInteger)contentLength];

	
	
	/* Try to retrieve last modified date from HTTP header. If found, format
	 date so it matches format of cached image file modification date. */
	
	if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
		NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
		NSString *modified = [headers objectForKey:@"Last-Modified"];
		if (modified) {
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			
			/* avoid problem if the user's locale is incompatible with HTTP-style dates */
			[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
			
			[dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
			self.lastModified = [dateFormatter dateFromString:modified];
		}
		else {
			/* default if last modified date doesn't exist (not an error) */
			self.lastModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
		}
	}



}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //This method is called whenever there is downloaded data available
    //It will be called multiple times and each time you will get part of downloaded data
    [downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //This method is called once the download is complete
    
//	//save the xml to a file for offline access
//    paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
//    folder = [paths objectAtIndex:0];
//	fileName = @"SavedURL.xml";
//    path = [folder stringByAppendingPathComponent:fileName];
//    fileURL = [NSURL fileURLWithPath:path];

	
	
/*
	const UInt8 OPEN_TAG_TO_FIND[] = "<guid>";
	const UInt8 CLOSE_TAG_TO_FIND[] = "</guid>";
	
	NSData *openTagData = [NSData dataWithBytes:OPEN_TAG_TO_FIND length:sizeof(OPEN_TAG_TO_FIND)-1];
	NSData *closeTagData = [NSData dataWithBytes:CLOSE_TAG_TO_FIND length:sizeof(CLOSE_TAG_TO_FIND)-1];

	NSRange openRange = [downloadedData rangeOfData:openTagData options:kNilOptions range:NSMakeRange(0u, downloadedData.length)];
	if (openRange.location == NSNotFound)
	{
		NSLog(@"Open Range Not Found!");
		return;
	}
	NSRange closeRange = [downloadedData rangeOfData:closeTagData options:kNilOptions range:NSMakeRange(openRange.location, downloadedData.length-openRange.location)];
	if (closeRange.location == NSNotFound)
	{
		NSLog(@"Close Range Not Found!");
		return;
	}
	
	NSData *GUIDData = [downloadedData subdataWithRange:NSMakeRange(openRange.location+openRange.length, closeRange.location-openRange.location-openRange.length)];
	NSString *GUIDString = [[NSString alloc] initWithData:GUIDData encoding:NSUTF8StringEncoding];
*/
	
/*	NSDate *lastSavedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"Date"];
	NSComparisonResult comparisonResult;
	comparisonResult = [lastDate compare:lastSavedDate];
	if (comparisonResult == NSOrderedDescending) {
		NSLog(@"true");
	}

	 [downloadedData writeToURL: fileURL options:0 error:&writeError];
	[downloadedData app]
*/
	//The next step is parse the downloaded xml feed
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:downloadedData];
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:YES];
	[xmlParser setShouldReportNamespacePrefixes:YES];
	[xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];

	
	
	
	/* */

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    folder = [paths objectAtIndex:0];
	fileName = @"SavedURL.xml";
    path = [folder stringByAppendingPathComponent:fileName];
    fileURL = [NSURL fileURLWithPath:path];

	if (fileURL)
	{
		NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
		NSLog(@"%@:",fileURL);
		
		[xmlParser setDelegate:self];
		[xmlParser setShouldProcessNamespaces:YES];
		[xmlParser setShouldReportNamespacePrefixes:YES];
		[xmlParser setShouldResolveExternalEntities:NO];
		[xmlParser parse];
		
		[self.delegate parserDidCompleteParsing];
	}
	else
	{
		[error localizedDescription];
		NSLog(@"%@", [error localizedDescription]);
		[self.delegate parserHasError:error];
	}

}

#pragma mark -
#pragma mark NSXMLParserDelegate
- (void) startParsing
{
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfURL:RSSURL]];
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:YES];
	[xmlParser setShouldReportNamespacePrefixes:YES];
	[xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if(nil != qualifiedName)
	{
		elementName = qualifiedName;
	}
    parseElement = NO;
	if ([elementName isEqualToString:@"lastBuildDate"])
	{
		lbd = [[NSString alloc] init];
	}

	if ([elementName isEqualToString:@"item"])
	{
        currentItem = [[NIKFeedEntry alloc] init];
		

		
	} else if([elementName isEqualToString:@"title"] ||
			  [elementName isEqualToString:@"guid"] ||
			  [elementName isEqualToString:@"description"] ||
			  [elementName isEqualToString:@"content:encoded"] ||
			  [elementName isEqualToString:@"link"] ||
			  [elementName isEqualToString:@"category"] ||
			  [elementName isEqualToString:@"dc:creator"] ||
			  [elementName isEqualToString:@"pubDate"] ||
			  [elementName isEqualToString:@"enclosure"] ||
			  [elementName isEqualToString:@"lastBuildDate"])
	{
		NSString *urlValue=[attributeDict valueForKey:@"url"];
		NSString *urlType=[attributeDict valueForKey:@"type"];
		parseElement = YES;
		if ([urlType  isEqualToString:@"audio/mpeg"] && ([urlValue rangeOfString:@"http://jadi.net"].length != 0))
		{
			downloadURL = [urlValue stringByReplacingOccurrencesOfString:@"http://jadi.net" withString:@"http://192.168.2.1"];
			[currentItem setPodcastDownloadURL:downloadURL];
		}
	}
	
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if(nil != qName)
	{
		elementName = qName;
	}
    
	NSString * parsedElementContent = nil;
    
	if (parsedElementData != nil) {
        parsedElementContent = [[NSString alloc] initWithData:parsedElementData encoding:NSUTF8StringEncoding];
    } else if (parsedElementString != nil) {
        parsedElementContent = [[NSString alloc] initWithString:parsedElementString];
    }
	if ([elementName isEqualToString:@"lastBuildDate"]) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
        NSDate *lastSavedBuildDate = [formatter dateFromString:[self trimString:parsedElementContent]];
		[[NSUserDefaults standardUserDefaults] setObject:lastSavedBuildDate forKey:@"Date"];

	}
	if([elementName isEqualToString:@"title"])
	{
        [currentItem setPodcastTitle:[self trimString:parsedElementContent]];
	}
	else if([elementName isEqualToString:@"guid"])
	{
        [currentItem setPodcastGUID:[self trimString:parsedElementContent]];
	}
	else if([elementName isEqualToString:@"description"])
	{
        [currentItem setPodcastSummary:[self trimString:parsedElementContent]];
	}
	else if([elementName isEqualToString:@"content:encoded"])
	{
        [currentItem setPodcastContent:[self trimString:parsedElementContent]];
	}
	else if([elementName isEqualToString:@"link"])
	{
        [currentItem setPodcastLinkURL:[self trimString:parsedElementContent]];
	}
	else if([elementName isEqualToString:@"category"])
	{
        [currentItem addPodcastCategory:[self trimString:parsedElementContent]];
	}
	else if([elementName isEqualToString:@"dc:creator"])
	{
        [currentItem setPodcastAuthor:[self trimString:parsedElementContent]];
	}
	else if([elementName isEqualToString:@"pubDate"])
	{
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss Z"];
        [currentItem setPodcastDate:[formatter dateFromString:[self trimString:parsedElementContent]]];
	}
	else if([elementName isEqualToString:@"item"])
	{
		[feedItems addObject:currentItem];
		

        currentItem = nil;
	}
	
    if (parsedElementContent!=nil)
	{
        parsedElementContent = nil;
    }
    
    if (parsedElementString!=nil)
	{
        parsedElementString = nil;
    }
	
    if (parsedElementData!=nil)
	{
        parsedElementData = nil;
    }
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!parseElement)
	{
        return;
    }
    if (parsedElementString==nil)
	{
        parsedElementString = [[NSMutableString alloc] init];
    }
    [parsedElementString appendString:string];
}

/*- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    if (!parseElement)
	{
        return;
    }
    if (parsedElementData==nil)
	{
        parsedElementData = [[NSMutableData alloc] init];
    }
    [parsedElementData appendData:CDATABlock];
	
	//Grabs the whole content in CDATABlock.
    NSMutableString *content = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
//    NSLog(@"desc:%@",descriptionTagContent);
    //Checks the tags to see if there are any images for the article, if so, sets a range with start and end index and grabs the string in between which is the image URL for the corresponding news item.
	
//    if ([descriptionTagContent rangeOfString:@"SNFeedImage"].location == NSNotFound)
//    {
//        
//        NSLog(@"no images");
//    }
//    else
//    {
//        NSRange    startIndex = [descriptionTagContent rangeOfString: @"http://"];
//        imageURL = [descriptionTagContent substringFromIndex:startIndex.location];
//		
//        NSRange    endIndex   = [imageURL rangeOfString: @"\""];
//        // NSInteger  length     = (endIndex.location - );
//        imageURL = [imageURL substringToIndex:endIndex.location];
//        //  imageURL = [descriptionTagContent substringWithRange:NSMakeRange (NSMaxRange(startIndex) , length)];
//		
//		
//		
//        //NSDictionary *attribDict;
//        //self.currentItem.mediaUrl = [attribDict valueForKey:@"url"];
//        //strat downloading image
//        self.currentItem.mediaUrl = [NSString stringWithString:imageURL];
//        // NSLog(@"IMAGE URL: %@", imageURL);
//        NSArray *argArray = [NSArray arrayWithObjects:self.currentItem,
//							 nil];
//        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
//											initWithTarget:self
//											selector:@selector(downloadingImage:)
//											object:(id)argArray];
//        [queue addOperation:operation];
//    }
//    
    //_nshamekhi_ Strips all HTML tags in the CDATABlock, and substrings 220 characters from the beginning to display as the intro text, or summary of the news in tableview cells in TitleViewController class.
    NSString *description = [content stripHtml];
//	NSLog(@"Description: %@",  description);
//    if (description.length >= 300)
//    {
//        self.currentItem.shortDescription = [FarsiNumbers convertNumbersToFarsi:[description substringToIndex:300]];
//    }
//    else
//    {
//        self.currentItem.shortDescription = [FarsiNumbers convertNumbersToFarsi:description];
//    }
//    self.currentItem.fullDescription = [FarsiNumbers convertNumbersToFarsi:description];
//    //NSLog(@"descriptiontagcontent:%@", descriptionTagContent);
//    //NSString *fullDescription = [descriptionTagContent st

	
	
	
}
*/
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"parseErrorOccured: %@",[parseError localizedDescription]);

}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (downloadedData!=nil)
	{
        downloadedData = nil;
    }
	


//	item = [[NSDictionary alloc] init];
//	items = [[NSMutableArray alloc] init];
//	
//	
//	for (int i=feedItems.count; i-->0;)
//	{
//		item = @{@"Title": [[feedItems objectAtIndex:i] podcastTitle],
//				 @"Date": [[feedItems objectAtIndex:i] podcastDate],
//				 @"GUID": [[feedItems objectAtIndex:i] podcastGUID],
//				 @"Summary": [[feedItems objectAtIndex:i] podcastSummary],
//				 @"Content": [[feedItems objectAtIndex:i] podcastContent],
//				 @"DownloadURL":[[feedItems objectAtIndex:i] podcastDownloadURL]};
//		[items addObject:item];
//
//	}
	
	
	NSString *destinPath = [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"RGeek.plist"];
//	[items writeToFile:destinPath atomically:YES];
//	NSURL *destinURL = [NSURL fileURLWithPath:destinPath];

	
	
	NSArray *tempArray = [[NSArray alloc] initWithContentsOfFile:destinPath];
    
	//local plist file
	guidDictionary = [[NSMutableDictionary alloc] init];
	for (int ii = tempArray.count; ii-->0;)
	{
	 NIKFeedEntry *feedEntry =	[[NIKFeedEntry alloc] initWithPodcastTitle:[tempArray[ii] objectForKey:@"Title"] podcastDate:[tempArray[ii] objectForKey:@"Date"] podcastGUID:[tempArray[ii] objectForKey:@"GUID"] podcastSummary:[tempArray[ii] objectForKey:@"Summary"] podcastContent:[tempArray[ii] objectForKey:@"Content"] podcastDownloadURL:@"DownloadURL"];
		[guidDictionary setObject: feedEntry forKey:[tempArray[ii] objectForKey: @"GUID"]];
	}
	
	
	
	
	for (int ii = feedItems.count; ii-->0;)
	{
		
		[guidDictionary setObject: feedItems[ii] forKey:[[feedItems objectAtIndex:ii] podcastGUID]];
	}

	
	
	//	for (int i=tempArray.count; i-->0;) {
//		[loadedArray set
//	}
//	NSSet *loadedSet = [NSSet alloc] initWithArray:loadedArray.

	NSArray *myArray;
	myArray = [guidDictionary allValues];

	
	myArray = [myArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
		return [((NIKFeedEntry *)obj2).podcastDate compare:((NIKFeedEntry *)obj1).podcastDate];
	}];
	
	feedItems = [NSMutableArray arrayWithArray:myArray];

	item = [[NSDictionary alloc] init];
	items = [[NSMutableArray alloc] init];
	
	
	for (int i=feedItems.count; i-->0;)
	{
		item = @{@"Title": [[feedItems objectAtIndex:i] podcastTitle],
				 @"Date": [[feedItems objectAtIndex:i] podcastDate],
				 @"GUID": [[feedItems objectAtIndex:i] podcastGUID],
				 @"Summary": [[feedItems objectAtIndex:i] podcastSummary],
				 @"Content": [[feedItems objectAtIndex:i] podcastContent]};
//				 @"DownloadURL":[[feedItems objectAtIndex:i] podcastDownloadURL]};
		[items addObject:item];
		
	}
	
	
	NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"RadiooGeek.plist"];
	[items writeToFile:destinationPath atomically:YES];
	
	
	[self.delegate parserDidCompleteParsing];

}


+ (NIKFeedParser *)sharedParser
{
	static NIKFeedParser* staticVar = nil;
	
	if (staticVar == nil)
		staticVar = [[NIKFeedParser alloc] init];
	return staticVar;
	
}


@end
