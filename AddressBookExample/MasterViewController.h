//
//  MasterViewController.h
//  AddressBookExample
//
//  Created by alexander on 4/24/14.
//  Copyright (c) 2014 Uriphium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
