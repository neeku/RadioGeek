//
//  NIKInfoViewController.m
//  RadioGeek
//
//  Created by Neeku on 11/14/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKInfoViewController.h"
#import "RadioGeek.h"
//#import "NSString+Shaping.h"
#import <CoreText/CoreText.h>
@interface NIKInfoViewController ()

@end


@implementation NIKInfoViewController

@synthesize copyrightLabel;
@synthesize infoLabel;
@synthesize textView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	NSString *str = @"نتبلیذمعهلبلاذپمهف نتاعغفباذرن رادیو گیک";//INFO_TEXT;
	[textView setText:str];
	[infoLabel setFont:[UIFont fontWithName:@"Arial" size:30]];
	infoLabel.text = str;
	[infoLabel setTextAlignment:NSTextAlignmentRight];
	infoLabel.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
	
	//gets the app name and version information from the main bundle.
	NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *name= [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
    
	copyrightLabel.text = [NSString stringWithFormat:@"%@ V. %@ \n ©2013 Neeku Shamekhi",name,version];
    copyrightLabel.font = [UIFont boldSystemFontOfSize:12];
//    copyrightLabel.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
