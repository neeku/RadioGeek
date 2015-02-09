//
//  NIKInfoViewController.m
//  RadioGeek
//
//  Created by Neeku on 11/14/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import "NIKInfoViewController.h"
#import "RadioGeek.h"
#import <CoreText/CoreText.h>
@interface NIKInfoViewController ()

@end


@implementation NIKInfoViewController

@synthesize copyrightLabel;
@synthesize copyrightTextView;
@synthesize infoLabel;
@synthesize returnButton;
@synthesize contactButton;
@synthesize shareButton;
@synthesize rateButton;

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
		
	
//	[textView setText:@"email"];
	[infoLabel setFont:[UIFont fontWithName:@"XM Yekan" size:14]];
	infoLabel.text = INFO_TEXT;
	[infoLabel setTextAlignment:NSTextAlignmentCenter];
	infoLabel.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
	
	//gets the app name and version information from the main bundle.
	NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *name= [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
    
	copyrightTextView.text = [NSString stringWithFormat:@"%@\u00a0V.\u00a0%@ %@",name,version, COPYRIGHT_TEXT];
    copyrightTextView.font = [UIFont boldSystemFontOfSize:12];
	copyrightTextView.userInteractionEnabled = NO;

	
	
	[contactButton setTitle:CONTACT_BUTTON_TITLE forState:UIControlStateNormal];
	[shareButton setTitle:SHARE_BUTTON_TITLE forState:UIControlStateNormal];
	[rateButton setTitle:RATE_BUTTON_TITLE forState:UIControlStateNormal];
	[returnButton setTitle:RETURN_BUTTON_TITLE forState:UIControlStateNormal];
	
	[contactButton.titleLabel setFont:[UIFont fontWithName:@"XM Yekan" size:14]];
	[shareButton.titleLabel setFont:[UIFont fontWithName:@"XM Yekan" size:14]];
	[rateButton.titleLabel setFont:[UIFont fontWithName:@"XM Yekan" size:14]];
	[returnButton.titleLabel setFont:[UIFont fontWithName:@"XM Yekan" size:14]];
	
//	//fix the status bar tint color.
	NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
	
	if ([[vComp objectAtIndex:0] intValue] >= 7) {
		// iOS-7 code[current] or greater
		UIView *fixbar = [[UIView alloc] init];
        fixbar.frame = CGRectMake(0, 0, 320, 20);
        fixbar.backgroundColor = [UIColor colorWithRed:0.238 green:0.753 blue:0.078 alpha:1]; // the default color of iOS7 bacground or any color suits your design
        [self.view addSubview:fixbar];
		
		
	} else if ([[vComp objectAtIndex:0] intValue] == 6) {
		// iOS-6 code
	} else if ([[vComp objectAtIndex:0] intValue] > 2) {
		// iOS-3,4,5 code
	} else {
		// iOS-1,2... code: incompatibility warnings, legacy-handlers, etc..
	}
	
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

- (IBAction)launchMailApp:(id)sender
{

	//gets device information to include in the email.
	NSString *deviceModel = [[UIDevice currentDevice] model];
	NSString *systemName = [[UIDevice currentDevice] systemName];
	NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
	NSString *deviceInfo = [NSString stringWithFormat:@"\n\n\n\n\n%@\n%@ %@",deviceModel, systemName, iOSVersion];
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"درباره اپلیکیشن آیفون رادیوگیک"];
	[controller setMessageBody:deviceInfo isHTML:NO];

	NSArray *toRecipients = [NSArray arrayWithObjects:@"neeku@taur.is",nil];
	
	[controller setToRecipients:toRecipients];
	
	if (controller)
		[self presentViewController:controller animated:YES completion:nil];

}

- (IBAction)shareThisApp:(id)sender
{
	//TODO: add the app url
	NSString *emailBody = @"اپلیکیشن آیفون رادیوگیک از آدرس زیر برای آیفون و آیپد قابل دریافت هست. برای دسترسی به تمام شماره‌های رادیوگیک، این برنامه رایگان را نصب کنید:\n\nhttp://appstore.com/radiogeek";
	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"به رادیو گیک گوش کنید!"];
	[controller setMessageBody:emailBody isHTML:NO];
	
		
	if (controller)
		[self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)rateThisApp:(id)sender
{
	//TODO: Add rating functionality. + regular reminder for rating.
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result
											   error:(NSError*)error
{
	if (result == MFMailComposeResultSent)
		NSLog(@"It's away!");
	[self dismissViewControllerAnimated:YES completion:nil];
}

+(NIKInfoViewController*) sharedController
{
	static NIKInfoViewController *staticVar = nil;
	
	if (staticVar == nil)
		staticVar = [[NIKInfoViewController alloc] init];
	return staticVar;
	
}


@end
