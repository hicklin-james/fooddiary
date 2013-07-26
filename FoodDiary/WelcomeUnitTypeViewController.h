//
//  WelcomeUnitTypeViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-10.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeUnitTypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)goToNextView:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
