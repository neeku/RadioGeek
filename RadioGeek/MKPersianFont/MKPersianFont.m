//  MKPersianFont.m
//
//  Created by Momeks Komeili on 4/7/12.
//  Copyright (c) 2012 MOMEKS. All rights reserved.
//  www.momeks.com


#import "MKPersianFont.h"

@implementation MKPersianFont


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

//- (id)init
//{
//    self = [super init];
//    if (self)
//	{
//    }
//    return self;
//}




- (void)setPersianFont:(NSString *)font  withText:(NSString *)text  fontSize:(int)size textAlignment:(NSString *)alignment textWrapped:(BOOL)isWrapped fontColor:(UIColor*)color /*shadowColor:(UIColor *)shadowColor shadowSize:(CGSize *)shadowSize shadowOpacity:(float)opacity shadowOffset:(CGSize *)offset shadowRadius:(CGFloat *)radius*/
{
    

    
    NSString *fontName = [NSString stringWithString:font];
    CTFontRef persianFont = [self PersianFontWithName:fontName
                                          ofType:@"ttf" 
                                      attributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:16.f] 
                                                                             forKey:(NSString *)kCTFontSizeAttribute]];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    persianFontLayer = [[CATextLayer alloc] init];
    persianFontLayer.font = persianFont;
    persianFontLayer.string = text;
    persianFontLayer.wrapped = isWrapped;
    [persianFontLayer setForegroundColor:[color CGColor]];
    persianFontLayer.fontSize = size;
    persianFontLayer.alignmentMode = alignment;
    persianFontLayer.frame = screenBounds;
	[persianFontLayer setShadowColor:[color CGColor]];
    //create scale 
    persianFontLayer.contentsScale = [[UIScreen mainScreen] scale];
    persianFontLayer.rasterizationScale = [[UIScreen mainScreen] scale];
//    [persianFontLayer setShadowOpacity:opacity];
//	[persianFontLayer setShadowOffset:*offset];
//	[persianFontLayer setShadowRadius:*radius];
    [self.layer addSublayer:persianFontLayer];
    
}

- (void)setPersianFont:(NSString *)font  withText:(NSString *)text  fontSize:(int)size textAlignment:(NSString *)alignment textWrapped:(BOOL)isWrapped fontColor:(UIColor*)color shadowColor:(UIColor *)shadowColor shadowOpacity:(float)opacity
{
    
	
    
    NSString *fontName = [NSString stringWithString:font];
    CTFontRef persianFont = [self PersianFontWithName:fontName
											   ofType:@"ttf"
										   attributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:16.f]
																				  forKey:(NSString *)kCTFontSizeAttribute]];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    persianFontLayer = [[CATextLayer alloc] init];
    persianFontLayer.font = persianFont;
    persianFontLayer.string = text;
    persianFontLayer.wrapped = isWrapped;
    [persianFontLayer setForegroundColor:[color CGColor]];
    persianFontLayer.fontSize = size;
    persianFontLayer.alignmentMode = alignment;
    persianFontLayer.frame = screenBounds;
	[persianFontLayer setShadowColor:[color CGColor]];
    //create scale
    persianFontLayer.contentsScale = [[UIScreen mainScreen] scale];
    persianFontLayer.rasterizationScale = [[UIScreen mainScreen] scale];
	[persianFontLayer setShadowOpacity:opacity];
	[self.layer addSublayer:persianFontLayer];
    
}


//- (void)setPersianFont:(NSString *)font  withText:(NSString *)text  fontSize:(int)size textWrapped:(BOOL)isWrapped fontColor:(UIColor*)color  {
//    
//	
//    
//    NSString *fontName = [NSString stringWithString:font];
//    CTFontRef persianFont = [self PersianFontWithName:fontName
//											   ofType:@"ttf"
//										   attributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:16.f]
//																				  forKey:(NSString *)kCTFontSizeAttribute]];
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//    persianFontLayer = [[CATextLayer alloc] init];
//    persianFontLayer.font = persianFont;
//    persianFontLayer.string = text ;
//    persianFontLayer.wrapped = isWrapped;
//    [persianFontLayer setForegroundColor:[color CGColor]];
//    persianFontLayer.fontSize = size;
//    persianFontLayer.frame = screenBounds;
//	
//    //create scale
//    persianFontLayer.contentsScale = [[UIScreen mainScreen] scale];
//    persianFontLayer.rasterizationScale = [[UIScreen mainScreen] scale];
//    
//    [self.layer addSublayer:persianFontLayer];
//    
//}



- (CTFontRef)PersianFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes {
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:type];
    NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
    CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((__bridge_retained CFDataRef)data);
    CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
    CGDataProviderRelease(fontProvider);
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge_retained CFDictionaryRef)attributes);
    CTFontRef font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
    CFRelease(fontDescriptor);
    CGFontRelease(cgFont);
    return font;
}


@end
