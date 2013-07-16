//
//  FDCell.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-14.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientButton.h"

@interface SummaryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *calsRemainingLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightGoalLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalDateLabel;
@property (strong, nonatomic) IBOutlet GradientButton *recordWeightButton;

@end
