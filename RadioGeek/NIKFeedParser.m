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

//  	[feedItems removeAllObjects];
    NSString *file = [[NSBundle  mainBundle] pathForResource:@"Feed"
													  ofType:@"plist"];
	NSDictionary *item = [[NSDictionary alloc]initWithContentsOfFile:file];
	NSArray *array = [item objectForKey:@"Root"];
	NSString *theURL = [[array objectAtIndex:selectedCategory.intValue] objectForKey:@"URL"];
	
    NSURL * url = [NSURL URLWithString:theURL];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLConnection * download = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [download start];
	
	//save the xml file
	
	
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection\
{
    //This method is called once the download is complete
    //The next step is parse the downloaded xml feed
    
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:downloadedData];
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:YES];
	[xmlParser setShouldReportNamespacePrefixes:YES];
	[xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[error localizedDescription];
	NSLog(@"%@", [error localizedDescription]);
	[self.delegate parserHasError:error];

}

#pragma mark -
#pragma mark NSXMLParserDelegate


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if(nil != qualifiedName)
	{
		elementName = qualifiedName;
	}
    parseElement = NO;
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
			  [elementName isEqualToString:@"enclosure"])
	{
		NSString *urlValue=[attributeDict valueForKey:@"url"];
		NSString *urlType=[attributeDict valueForKey:@"type"];
		parseElement = YES;
		if ([urlType  isEqualToString:@"audio/ogg"] && ([urlValue rangeOfString:@"jadi.net"].length != 0))
		{
			downloadURL = [urlValue stringByReplacingOccurrencesOfString:@"jadi.net" withString:@"192.168.2.1"];
			downloadURL = [downloadURL stringByReplacingOccurrencesOfString:@"ogg" withString:@"mp3"];
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

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
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

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"parseErrorOccured: %@",[parseError description]);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (downloadedData!=nil)
	{
        downloadedData = nil;
    }
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
