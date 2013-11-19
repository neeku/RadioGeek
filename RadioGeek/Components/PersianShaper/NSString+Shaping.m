//
//  NSString+Shaping.m
//  RadioGeek
//
//  Created by Neeku on 11/14/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NSString+Shaping.h"
#import "NIKPersianShaping.h"

@implementation NSString (Shaping)

- shapePersianString
{
	unichar * buffer = malloc(sizeof(unichar) * [self length] + 2);
	
	[self getCharacters:buffer];
	FriBidiChar* shapedUCS = shape_arabic(buffer, [self length]);
	int l = 0;
	int i = 0;
	for (i=0; i<self.length && shapedUCS [i] != 0; i++)
	{
	}
	l = i;
	NSString * outString = [NSString stringWithCharacters:shapedUCS length:l];
	free(buffer);
	free(shapedUCS);
	
	return outString;
}


@end
