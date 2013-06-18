//
//  NewRecipeViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewRecipeViewControllerDelegate;

@interface NewRecipeViewController : UIViewController <UITextFieldDelegate>

// Delegate Properties
@property (nonatomic, weak) id<NewRecipeViewControllerDelegate> delegate;

// Method called when cancel button is pushed
-(IBAction)handleCancelButton:(id)sender;
- (IBAction)enterIntoTable:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *theTextField;

@end

// Definition of delegate's interface
@protocol NewRecipeViewControllerDelegate <NSObject>

-(void)newRecipeViewControllerDidFinish:(NewRecipeViewController*)viewController;
-(void)newTableWithName:(NewRecipeViewController *)viewController name:(NSString*)tableTitle;

@end
