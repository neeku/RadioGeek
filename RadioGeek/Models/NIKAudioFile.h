//
//  NIKAudioFile.h
//  RadioGeek
//
//  Created by Neeku on 11/22/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface NIKAudioFile : NSObject
{
	NSURL* fileURL;
	NSDictionary* fileInfoDict;
}

@property (nonatomic, strong) NSURL* fileURL;
@property (nonatomic, strong) NSDictionary* fileInfoDict;

- (NIKAudioFile*) initWithPath:(NSURL *)path;
//- (NSDictionary*) getSongID3Tags;
- (NSString*) getTitle;
- (NSString*) getArtist;
- (NSString*) getAlbum;
- (float) getDuration;
- (NSString*) getDurationInMinutes;
- (UIImage*) getCoverImage;


@end
