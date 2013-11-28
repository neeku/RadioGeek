//
//  NIKAudioPlayerView.h
//  RadioGeek
//
//  Created by Neeku on 11/25/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PlayButtonStylePlay = 0,
    PlayButtonStylePause,
    PlayButtonStyleActivity,
} PlayButtonStyle;


@interface NIKAudioPlayerView : UIView
{
	UISlider *seekSlider;
}

@property (nonatomic, strong) UIButton                *playButton;
@property (nonatomic, strong) UIButton                *closeButton;
@property (nonatomic, strong) UILabel                 *titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) PlayButtonStyle         playButtonStyle;
@property (nonatomic, assign, readonly) BOOL          isPlayerHidden;
@property (nonatomic, strong) UIButton				  *ffwButton;
@property (nonatomic, strong) UIButton				  *rewButton;
@property (nonatomic, strong) UISlider				  *seekSlider;

- (void)showPlayer;
- (void)hidePlayer;

@end