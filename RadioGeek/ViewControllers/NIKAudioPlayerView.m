//
//  NIKAudioPlayerView.m
//  RadioGeek
//
//  Created by Neeku on 11/25/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKAudioPlayerView.h"

@implementation NIKAudioPlayerView
{
    BOOL _isAnimating;
}

@synthesize playButton;
@synthesize closeButton;
@synthesize titleLabel;
@synthesize playButtonStyle;
@synthesize activityView;
@synthesize isPlayerHidden = _playerHidden;
@synthesize ffwButton;
@synthesize rewButton;
@synthesize seekSlider;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"musicplayer_background.png"]];
		
        _playerHidden = YES;
		
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
        [self addSubview:activityView];
		
        playButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [playButton setBackgroundImage:[UIImage imageNamed:@"button_pause.png"] forState:UIControlStateNormal];
        playButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:playButton];
		
        closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        closeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:closeButton];
		
		ffwButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
		[ffwButton setBackgroundImage:[UIImage imageNamed:@"player_fastforward"] forState:UIControlStateNormal];
		ffwButton.titleLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:ffwButton];
		
		rewButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
		[rewButton setBackgroundImage:[UIImage imageNamed:@"player_fastrewind"] forState:UIControlStateNormal];
		rewButton.titleLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:rewButton];
		 
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 240.0f, 30.0f)];
        titleLabel.text = nil;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
		
		seekSlider = [[UISlider alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 30.0f)];
		[self addSubview:seekSlider];
		
    }
    return self;
}

- (void)layoutSubviews
{
	
#define PADDING 5.0f
	
    NSLog(@"%@", NSStringFromCGRect(self.bounds));
    CGRect frame = self.bounds;
    CGFloat y = frame.size.height / 2;
	
    titleLabel.center = CGPointMake(frame.size.width / 2, y);
	
    CGFloat x = titleLabel.frame.origin.x - (playButton.frame.size.width / 2) - PADDING;
    playButton.center = CGPointMake(x, y);
    activityView.center = CGPointMake(x, y);
	
	rewButton.center = CGPointMake(80, y);
	ffwButton.center = CGPointMake(240, y);
	
	
    x = titleLabel.frame.origin.x + titleLabel.frame.size.width + (closeButton.frame.size.width / 2) + PADDING;
    closeButton.center = CGPointMake(x, y);
	
	seekSlider.center = CGPointMake(160, 5);
	
}

#pragma mark - Instance methods

- (void)showPlayer
{
    if (_isAnimating || _playerHidden == NO)
        return;
	
    _isAnimating = YES;
	
    [UIView
     animateWithDuration:0.5f
     animations:^
     {
         CGRect frame = self.frame;
         frame.origin.y -= 40.0f;
         self.frame = frame;
     }
     completion:^ (BOOL finished)
     {
         _isAnimating = NO;
         _playerHidden = NO;
     }];
}

- (void)hidePlayer
{
    if (_isAnimating || _playerHidden)
        return;
	
    _isAnimating = YES;
	
    [UIView
     animateWithDuration:0.5f
     animations:^
     {
         CGRect frame = self.frame;
         frame.origin.y += 40.0f;
         self.frame = frame;
     }
     completion:^ (BOOL finished)
     {
         _isAnimating = NO;
         _playerHidden = YES;
     }];
}

- (void)setPlayButtonStyle:(PlayButtonStyle)style
{
    playButton.hidden = (style == PlayButtonStyleActivity);
    activityView.hidden = (style != PlayButtonStyleActivity);
	
    switch (style)
    {
        case PlayButtonStyleActivity:
        {
            [activityView startAnimating];
        }
            break;
        case PlayButtonStylePause:
        {
            [activityView stopAnimating];
			
            [playButton setBackgroundImage:[UIImage imageNamed:@"button_pause.png"] forState:UIControlStateNormal];
        }
            break;
        case PlayButtonStylePlay:
        default:
        {
            [activityView stopAnimating];
			
            [playButton setBackgroundImage:[UIImage imageNamed:@"button_play.png"] forState:UIControlStateNormal];
        }
            break;
    }
	
    [self setNeedsLayout];
}

@end
