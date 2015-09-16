//
//  NIKInfoViewController.h
//  RadioGeek
//
//  Created by Neeku on 11/14/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIKInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (IBAction)dismiss:(id)sender;

@end
