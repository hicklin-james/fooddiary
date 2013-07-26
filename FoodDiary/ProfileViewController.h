//
//  ProfileViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-28.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetCustomPicker.h"

@interface ProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
