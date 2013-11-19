//
//  FarsiNumerals.m
//  
//
//  Created by neeku shamekhi on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSHFarsiNumerals.h"

@implementation NSHFarsiNumerals

+(NSString*) convertNumeralsToFarsi:(NSString*)englishNumeralString
{
    NSString* farsiNumeral;
    farsiNumeral = [englishNumeralString stringByReplacingOccurrencesOfString:@"1" withString:@"۱"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"2" withString:@"۲"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"3" withString:@"۳"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"4" withString:@"۴"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"5" withString:@"۵"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"6" withString:@"۶"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"7" withString:@"۷"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"8" withString:@"۸"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"9" withString:@"۹"];
    farsiNumeral = [farsiNumeral stringByReplacingOccurrencesOfString:@"0" withString:@"۰"];
    return farsiNumeral;
}

@end
