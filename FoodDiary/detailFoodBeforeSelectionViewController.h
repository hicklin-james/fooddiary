//
//  DetailFoodBeforeSelectionViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-15.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSFood.h"
#import "FSServing.h"
#import "ActionSheetPicker.h"
#import "MyFood.h"
#import "MyServing.h"

@protocol DetailFoodBeforeSelectionViewControllerDelegate;

@interface DetailFoodBeforeSelectionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ActionSheetCustomPickerDelegate>

@property (nonatomic, weak) id<DetailFoodBeforeSelectionViewControllerDelegate> delegate;
@property (nonatomic, strong) FSFood* detailedFood;
@property (nonatomic, strong) NSString *foodDescription;
@property (nonatomic, strong) FSServing* selectedServing;
@property (nonatomic, assign) NSInteger servingIndex;
@property (nonatomic, strong) NSString* mealName;
@property (weak, nonatomic) IBOutlet UIPickerView *unitPicker;
@property (weak, nonatomic) IBOutlet UITableView *nutInfoTable;
@property (strong, nonatomic) UITextField *customTextField;
@property (nonatomic, assign) CGFloat servingSize;
@property (strong, nonatomic) IBOutlet UIView *nutritionInfoHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *nutritionInfoHeaderTitle;



- (IBAction)addFoodToMeal:(id)sender;

@end
