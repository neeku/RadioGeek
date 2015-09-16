//
//  NSString+Shaping.m
//  FarsiPoemBook
//
//  Created by Ali Nadalizadeh on 4/16/90.
//  Copyright 2011 Turned on Ventures. All rights reserved.
//

#import "NSString+Shaping.h"
#import "PersianShaping.h"

@implementation NSString (Shaping)

- shapedString
{
	unichar * buffer = malloc(sizeof(unichar) * [self length] + 2);
	
	[self getCharacters:buffer];
	FriBidiChar* shapedUCS = shape_arabic(buffer, [self length]);
	
	NSString * outString = [NSString stringWithCharacters:shapedUCS length:[self length]];
	free(buffer);
	free(shapedUCS);
	
	return outString;
}

@end
