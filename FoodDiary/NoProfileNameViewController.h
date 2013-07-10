//
//  NoProfileNameViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-09.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoProfileNameViewControllerDelegate;

@interface NoProfileNameViewController : UIViewController {
  
  NSManagedObjectContext *managedObjectContext;
  NSMutableArray *mealsToday;
  NSDate *dateToShow;
  
}
@property (weak, nonatomic) id<NoProfileNameViewControllerDelegate> delegate;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *mealsToday;
@property (nonatomic, strong) NSDate *dateToShow;
- (IBAction)testButtonPushed:(id)sender;

@end

@protocol NoProfileNameViewControllerDelegate <NSObject>

-(void)profileCompleted:(NoProfileNameViewController*)viewController;

@end
