//
//  NewShoppingListViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "NewShoppingListViewController.h"

@interface NewShoppingListViewController ()

@end

@implementation NewShoppingListViewController

-(void)handleCancelButton:(id)sender {
  
  // Delegate method is optional, so check that the delegate implements it
  if ([self.delegate respondsToSelector:@selector(newShoppingListViewControllerDidFinish:)]) {
    [self.delegate newShoppingListViewControllerDidFinish:self];
  }
}


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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
