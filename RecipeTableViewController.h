//
//  RecipeTableViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewRecipeViewController.h"

@interface RecipeTableViewController : UITableViewController <NewRecipeViewControllerDelegate>{
  
IBOutlet UITableView *table;
NSMutableArray *regions;
  
}

@end
