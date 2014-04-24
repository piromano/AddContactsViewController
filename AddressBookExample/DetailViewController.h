//
//  DetailViewController.h
//  AddressBookExample
//
//  Created by alexander on 4/24/14.
//  Copyright (c) 2014 Uriphium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
