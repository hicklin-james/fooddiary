//
//  NewFoodNameViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-22.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFoodNameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (IBAction)nextView:(id)sender;
- (IBAction)cancelNewFood:(id)sender;

@end
