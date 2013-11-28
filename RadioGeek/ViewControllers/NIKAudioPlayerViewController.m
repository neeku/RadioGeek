//
//  NIKAudioPlayerViewController.m
//  RadioGeek
//
//  Created by Neeku on 11/25/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKAudioPlayerViewController.h"
#import "NIKAudioPlayer.h"
#import "NIKAudioPlayerView.h"

NSString *const kAudioPlayerWillShowNotification = @"kAudioPlayerWillShowNotification";
NSString *const kAudioPlayerWillHideNotification = @"kAudioPlayerWillHideNotification";


@interface NIKAudioPlayerViewController () <NIKAudioPlayerDelegate>

@property (nonatomic, strong) NIKAudioPlayerView *playerView;

- (void)playButtonTouched:(id)sender;
- (void)closeButtonTouched:(id)sender;
- (void)hidePlayer;
- (void)ffwButtonTouched:(id)sender;
- (void)rewButtonTouched:(id)sender;
- (void)seekSliderTouched:(id)sender;
- (void)beginScrubbing:(id)sender;
- (void)scrub:(id)sender;
- (void)endScrubbing:(id)sender;

@end


@implementation NIKAudioPlayerViewController

@synthesize playerView, isPlaying, isPlayerVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        playerView = [[NIKAudioPlayerView alloc] initWithFrame:CGRectZero];
		
        [NIKAudioPlayer sharedAudioPlayer].delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = playerView;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [playerView.playButton addTarget:self action:@selector(playButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [playerView.closeButton addTarget:self action:@selector(closeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
	[playerView.ffwButton addTarget:self action:@selector(ffwButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
	[playerView.rewButton addTarget:self action:@selector(rewButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
	[playerView.seekSlider addTarget:self action:@selector(seekSliderTouched:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private methods

- (NIKAudioPlayerView *)playerView
{
    return (NIKAudioPlayerView *)self.view;
}

- (void)hidePlayer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioPlayerWillHideNotification object:nil];
    [self.playerView hidePlayer];
}

- (void)playButtonTouched:(id)sender
{
    NSLog(@"play / pause");
	
    if ([NIKAudioPlayer sharedAudioPlayer].isPlaying)
    {
        [[NIKAudioPlayer sharedAudioPlayer] pause];
    }
    else
    {
        [[NIKAudioPlayer sharedAudioPlayer] play];
    }
	
    [self.playerView showPlayer];
}

- (void)closeButtonTouched:(id)sender
{
    NSLog(@"close");
	
    if ([NIKAudioPlayer sharedAudioPlayer].isPlaying)
        [[NIKAudioPlayer sharedAudioPlayer] pause];
	
    [self hidePlayer];
}

- (void)ffwButtonTouched:(id)sender
{
	[[NIKAudioPlayer sharedAudioPlayer] fastForward];
}
- (void)rewButtonTouched:(id)sender
{
	[[NIKAudioPlayer sharedAudioPlayer] rewind];
	NSLog(@"rew button pressed");
}

- (void)seekSliderTouched:(id)sender
{
	[[NIKAudioPlayer sharedAudioPlayer] scrub:sender];
}



#pragma mark - Instance methods

- (void)playAudioAtURL:(NSURL *)URL withTitle:(NSString *)title
{
    playerView.titleLabel.text = title;
    [[NIKAudioPlayer sharedAudioPlayer] playAudioAtURL:URL];
	
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioPlayerWillShowNotification object:nil];
    [playerView showPlayer];
}

- (void)pause
{
    [[NIKAudioPlayer sharedAudioPlayer] pause];
	
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioPlayerWillHideNotification object:nil];
    [playerView hidePlayer];
}

- (void)fastForward
{
	[[NIKAudioPlayer sharedAudioPlayer] fastForward];
}

- (void)rewind
{
	[[NIKAudioPlayer sharedAudioPlayer] rewind];
}

- (void)updateSeekSlider
{
	
}






#pragma mark - Audio player delegate

- (void)audioPlayerDidStartPlaying
{
    NSLog(@"did start playing");
	
    playerView.playButtonStyle = PlayButtonStylePause;
}

- (void)audioPlayerDidStartBuffering
{
    NSLog(@"did start buffering");
	
    playerView.playButtonStyle = PlayButtonStyleActivity;
}

- (void)audioPlayerDidPause
{
    NSLog(@"did pause");
	
    playerView.playButtonStyle = PlayButtonStylePlay;
}

- (void)audioPlayerDidFinishPlaying
{
    [self hidePlayer];
}

#pragma mark - Properties

- (BOOL)isPlaying
{
    return [NIKAudioPlayer sharedAudioPlayer].isPlaying;
}

- (BOOL)isPlayerVisible
{
    return !playerView.isPlayerHidden;
}

@end
