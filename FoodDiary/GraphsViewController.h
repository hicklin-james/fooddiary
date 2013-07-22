//
//  GraphsViewController.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-18.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface GraphsViewController : UIViewController <CPTPlotDataSource, CPTAxisDelegate, UITabBarDelegate> {
  
  NSMutableArray *graphData;
  
}

@property (strong, nonatomic) NSMutableArray *graphData;

@property (strong, nonatomic) IBOutlet UIView *graphView;
@property (strong, nonatomic) IBOutlet UITabBarItem *fourWeeksButton;
@property (strong, nonatomic) IBOutlet UITabBarItem *eightWeeksButton;
@property (strong, nonatomic) IBOutlet UITabBarItem *twelveWeeksButton;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;


@end
