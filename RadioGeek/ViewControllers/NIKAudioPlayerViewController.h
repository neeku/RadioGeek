//
//  NIKAudioPlayerViewController.h
//  RadioGeek
//
//  Created by Neeku on 11/25/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kAudioPlayerWillShowNotification;
extern NSString *const kAudioPlayerWillHideNotification;


@interface NIKAudioPlayerViewController : UIViewController

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) BOOL isPlayerVisible;

- (void)playAudioAtURL:(NSURL *)URL withTitle:(NSString *)title;
- (void)pause;
- (void)fastForward;
- (void)rewind;
- (void)updateSeekSlider;
@end