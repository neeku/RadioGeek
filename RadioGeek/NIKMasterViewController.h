//
//  NIKMasterViewController.h
//  RadioGeek
//
//  Created by Neeku on 10/26/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIKDetailViewController;

#import <CoreData/CoreData.h>

@interface NIKMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NIKDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
