//
//  CurrentGoalCell.h
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-16.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentGoalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *currentWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *goalDateLabel;

@end
