//
//  RecordWeightViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-17.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordWeightViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (IBAction)cancelRecordWeight:(id)sender;
- (IBAction)saveRecordWeight:(id)sender;

@end
