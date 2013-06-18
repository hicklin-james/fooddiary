//
//  ShoppingListsViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "ShoppingListsViewController.h"

@interface ShoppingListsViewController ()

@end

@implementation ShoppingListsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

// Called before segue into another view
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // set the FoodDiaryViewController as the delegate for the new view
  [segue.destinationViewController setDelegate:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//------------------ DELEGATE METHODS ------------------//

// If the newShoppingListViewController finished (either a new list was added or the user
// cancelled it), dismiss the view controller. // ONLY WORKS WITH MODAL VIEWS
-(void)newShoppingListViewControllerDidFinish:(NewShoppingListViewController *)viewController{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
