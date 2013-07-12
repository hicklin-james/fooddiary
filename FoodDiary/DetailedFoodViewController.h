//
//  DetailedFoodViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFood.h"
#import "MyServing.h"
#import "ActionSheetCustomPicker.h"

@interface DetailedFoodViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ActionSheetCustomPickerDelegate>{
    
    NSManagedObjectContext *managedObjectContext;
    MyFood *detailedFood;
    MyServing *currentServing;
    NSMutableArray *allServings;
    
}


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray* allServings;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) MyFood *detailedFood;
@property (nonatomic, strong) MyServing *currentServing;
@end
