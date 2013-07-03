//
//  ProfileWeightCell.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-01.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "ProfileHeightCell.h"

@implementation ProfileHeightCell

@synthesize metricHeightTextField;
@synthesize cmLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
