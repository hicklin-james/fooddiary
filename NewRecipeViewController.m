//
//  NewRecipeViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "NewRecipeViewController.h"

@interface NewRecipeViewController ()

@end

@implementation NewRecipeViewController

-(void)handleCancelButton:(id)sender {
  
  // Delegate method is optional, so check that the delegate implements it
  if ([self.delegate respondsToSelector:@selector(newRecipeViewControllerDidFinish:)]) {
    [self.delegate newRecipeViewControllerDidFinish:self];
  }
  
}

- (IBAction)enterIntoTable:(id)sender {
  
  if ([self.delegate respondsToSelector:@selector(newTableWithName:name:)]) {
    [self.delegate newTableWithName:self name:[_theTextField text]];
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  [[self view] endEditing:TRUE];
  
}




// ----------------DELEGATE METHODS----------------------//

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  [theTextField resignFirstResponder];
  return YES;
}


@end
