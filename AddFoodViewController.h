//
//  AddFoodViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FSFood.h"
#import "MyFood.h"

@interface AddFoodViewController : UIViewController <UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) FSFood *foodToBeSentToNextView;

-(IBAction)handleCancelButton:(id)sender;

@end

