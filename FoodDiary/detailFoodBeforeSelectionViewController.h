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
#import "FDFood.h"

@protocol DetailFoodBeforeSelectionViewControllerDelegate;

@interface DetailFoodBeforeSelectionViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id<DetailFoodBeforeSelectionViewControllerDelegate> delegate;
@property (nonatomic, strong) FSFood* detailedFood;
@property (nonatomic, strong) FSServing* selectedServing;
@property (nonatomic, strong) FDFood* customFood;
@property (nonatomic, strong) NSString* mealName;
@property (weak, nonatomic) IBOutlet UIPickerView *unitPicker;
@property (weak, nonatomic) IBOutlet UITableView *nutInfoTable;
@property (strong, nonatomic) UITextField *customTextField;

- (IBAction)addFoodToMeal:(id)sender;
- (void)setPickerHidden:(BOOL)hidden;

@end

@protocol DetailFoodBeforeSelectionViewControllerDelegate <NSObject>

- (void)foodWasAddedToDay:(DetailFoodBeforeSelectionViewController*)controller mealID:(NSString*)mealID food:(FDFood*)food;

@end
