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

@interface DetailFoodBeforeSelectionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ActionSheetCustomPickerDelegate> {
  
  NSManagedObjectContext *managedObjectContext;
  NSArray *mealsToday;
  
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *mealsToday;

@property (nonatomic, weak) id<DetailFoodBeforeSelectionViewControllerDelegate> delegate;
@property (nonatomic, strong) FSFood* detailedFood;
@property (nonatomic, strong) FSServing* selectedServing;
@property (nonatomic, assign) NSInteger servingIndex;
@property (nonatomic, strong) NSString* mealName;
@property (weak, nonatomic) IBOutlet UIPickerView *unitPicker;
@property (weak, nonatomic) IBOutlet UITableView *nutInfoTable;
@property (strong, nonatomic) UITextField *customTextField;
@property (nonatomic, assign) CGFloat servingSize;


- (IBAction)addFoodToMeal:(id)sender;
- (void)setPickerHidden:(BOOL)hidden;

@end
