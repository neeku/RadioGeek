//
//  NIKAppDelegate.h
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *globalFeedName;

@interface NIKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


- (NSString *)applicationDocumentsDirectory;
- (NSString *)applicationSupportDirectory;
@end
