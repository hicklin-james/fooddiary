//
//  NewShoppingListViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

// Declares that a NewMealViewControllerDelegate type exists
@protocol NewShoppingListViewControllerDelegate;

@interface NewShoppingListViewController : UIViewController

// Delegate Properties
@property (nonatomic, weak) id<NewShoppingListViewControllerDelegate> delegate;

// Method called when cancel button is pushed
-(IBAction)handleCancelButton:(id)sender;

@end

// Definition of delegate's interface
@protocol NewShoppingListViewControllerDelegate <NSObject>

-(void)newShoppingListViewControllerDidFinish:(NewShoppingListViewController*)viewController;

@end
