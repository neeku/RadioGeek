//
//  NIKPlayer.h
//  RadioGeek
//
//  Created by Neeku on 11/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface NIKPlayer : NSObject <AVAudioPlayerDelegate>
{
	AVAudioPlayer *currentPlayer;
}
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;
+(NIKPlayer *) sharedPlayer;
-(void)playURL:(NSURL*)url;



@end
