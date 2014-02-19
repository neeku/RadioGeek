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
@synthesize infoLabel;
@synthesize textView;
@synthesize contactButton;
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
	[infoLabel setFont:[UIFont fontWithName:@"Arial" size:30]];
//	infoLabel.text = recepient;
	[infoLabel setTextAlignment:NSTextAlignmentRight];
	infoLabel.autoresizesSubviews = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
	
	//gets the app name and version information from the main bundle.
	NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *name= [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey];
    
	copyrightLabel.text = [NSString stringWithFormat:@"%@ V. %@ \n ©2013 Neeku Shamekhi",name,version];
    copyrightLabel.font = [UIFont boldSystemFontOfSize:12];
//    copyrightLabel.userInteractionEnabled = NO;
	
	[contactButton setTitle:CONTACT_BUTTON_TITLE forState:UIControlStateNormal];
	[rateButton setTitle:RATE_BUTTON_TITLE forState:UIControlStateNormal];
	
//	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
//	controller.mailComposeDelegate = self;
//	[controller setSubject:@"My Subject"];
//	[controller setMessageBody:@"Hello there." isHTML:NO];
//	if (controller)
//		[self presentModalViewController:controller animated:YES];
	
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
//	NSString *email = [EMAIL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
//	[UIApplication sharedApplication] pr

	MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:@"My Subject"];
	[controller setMessageBody:@"Hello there." isHTML:NO];

	NSArray *toRecipients = [NSArray arrayWithObjects:@"neeku@shamekhi.net",nil];
	
	[controller setToRecipients:toRecipients];
	
	if (controller)
		[self presentViewController:controller animated:YES completion:nil];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result
											   error:(NSError*)error
{
	if (result == MFMailComposeResultSent)
		NSLog(@"It's away!");
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
