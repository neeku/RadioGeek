//
//  NIKDownloadManager.m
//  RadioGeek
//
//  Created by Neeku on 12/5/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKDownloadManager.h"
#import "RadioGeek.h"
#import "NIKAudioManager.h"

@implementation NIKDownloadManager
@synthesize fileDoesNotExist;
@synthesize detailViewController;

-(id)initWithURL:(NSURL *)url viewController: (NIKDetailViewController *) detailVC
{

	detailViewController = detailVC;
	targetURL = url;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:300.0];
//	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"GET"];
	NSURLConnection * conn = [NSURLConnection connectionWithRequest:request delegate:self];
	if(conn)
		responseData = [NSMutableData data];
	
	else
		NSLog(@":(");

	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//This method is called when the download begins.
    //You can get all the response headers
	//make sure we have a 2xx reponse code
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	
    if ([httpResponse statusCode]/100 == 2)
	{
		//file exists on the server
		[responseData setLength:0];
		responseDataSize = (NSUInteger)[response expectedContentLength];
		
		
    } else {
		//file does not exist on the server - Error 404
		[connection cancel];
		fileDoesNotExist = YES;
		//show error alert view
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:ERROR_MESSAGE delegate:detailViewController cancelButtonTitle:CANCEL_BUTTON_TITLE otherButtonTitles:Nil, nil];
		[alertView show];
		
		//reset download view
		detailViewController.downloadButton.enabled = YES;
		detailViewController.progressView.progress = 0.0;

    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
    detailViewController.progressView.progress
		= (float)[responseData length] / (float)responseDataSize;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *fileName = [[NSString stringWithFormat:@"%@",targetURL] lastPathComponent];
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *folder = [pathArr objectAtIndex:0];
	
    NSString *path = [folder stringByAppendingPathComponent:fileName];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSError *writeError = nil;
	
    [responseData writeToURL: fileURL options:0 error:&writeError];
	detailViewController.downloadView.hidden = YES; //hide the download view once downloading is finished
	detailViewController.feedEntry.audioManager = [[NIKAudioManager alloc] initWithURL:fileURL viewController:detailViewController title:[detailViewController.feedEntry podcastTitle]];

	[detailViewController.audioView addSubview:detailViewController.seekSlider];
	[detailViewController.audioView addSubview:detailViewController.fastForward];
	[detailViewController.audioView addSubview:detailViewController.fastRewind];
	detailViewController.audioView.userInteractionEnabled = YES;
	
	//Make sure the system follows our playback status - to support the playback when the app enters the background mode.
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];

	
    if( writeError) {
        NSLog(@" Error in writing file %@' : \n %@ ", path , writeError );
        return;
    }
    NSLog(@"%@",fileURL);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[error localizedDescription];
	NSLog(@"%@", [error localizedDescription]);
	NSInteger errorCode = [error code];
	
	//persian error messages file full path
	NSString * persianErrorsListFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Persian.strings"];
	//Load file as dictionary
	NSDictionary * persianErrorsList = [[NSDictionary alloc] initWithContentsOfFile:persianErrorsListFile];
	
	NSString *errorKey = [NSString stringWithFormat:@"Err%ld", (long)errorCode];
	NSString *errorMessage = persianErrorsList[errorKey];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT_TITLE message:errorMessage delegate:detailViewController cancelButtonTitle:CANCEL_BUTTON_TITLE otherButtonTitles:nil, nil];
	[alertView show];
	detailViewController.downloadButton.enabled = YES;
	detailViewController.progressView.progress = 0.0;
}

@end
