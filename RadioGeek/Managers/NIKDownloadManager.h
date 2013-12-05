//
//  NIKDownloadManager.h
//  RadioGeek
//
//  Created by Neeku on 12/5/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIKDetailViewController.h"
@interface NIKDownloadManager : NSObject <NSURLConnectionDelegate>
{
	NSMutableData *responseData;
	NSUInteger responseDataSize;
	NSURL *targetURL;
}

@property (nonatomic) BOOL fileDoesNotExist;
@property (nonatomic, strong) NIKDetailViewController *detailViewController;

-(id)initWithURL:(NSURL *)url viewController: (NIKDetailViewController *) detailVC;
@end
