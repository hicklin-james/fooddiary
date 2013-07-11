//
//  WelcomeNameViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-10.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeNameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
- (IBAction)goToNextView:(id)sender;

@end
