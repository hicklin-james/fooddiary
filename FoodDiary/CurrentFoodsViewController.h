//
//  CurrentFoodsViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-25.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentFoodsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
  
  NSMutableArray *foods;
  NSMutableArray *servings;
  NSString *mealTitle;
  
}

@property (strong, nonatomic) NSString *mealTitle;
@property (strong, nonatomic) NSMutableArray *foods;
@property (strong, nonatomic) NSMutableArray *servings;
- (IBAction)closeCurrentFoods:(id)sender;
- (IBAction)saveCurrentFoods:(id)sender;

@end
