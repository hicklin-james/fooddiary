//
//  GraphsViewController.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-07-18.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "GraphsViewController.h"
#import "DateManipulator.h"
#import "MealController.h"
#import "StoredWeight.h"

@interface GraphsViewController ()

@end

@implementation GraphsViewController

@synthesize graphData;
@synthesize fourWeeksButton;
@synthesize eightWeeksButton;
@synthesize twelveWeeksButton;

DateManipulator *dateManipulator;
CPTGraph* graph;
// We need a hostview.
CPTGraphHostingView* hostView;
CPTXYPlotSpace *plotSpace;
CPTScatterPlot* plot;


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
  dateManipulator = [[DateManipulator alloc] initWithDateFormatter];
  
  [fourWeeksButton setTitlePositionAdjustment:UIOffsetMake(0, -10)];
  [eightWeeksButton setTitlePositionAdjustment:UIOffsetMake(0, -10)];
  [twelveWeeksButton setTitlePositionAdjustment:UIOffsetMake(0, -10)];
  
  CGRect viewFrame=self.tabBar.frame;
  //change these parameters according to you.
  //viewFrame.origin.y -=50;
  //viewFrame.origin.x -=20;
  viewFrame.size.height=35;
  //viewFrame.size.width=300;
  self.tabBar.frame=viewFrame;
  
  self.tabBar.selectedItem = fourWeeksButton;
  
  // allocate a frame for the host view

  [self setupGraph];

}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [self.navigationController popViewControllerAnimated:NO];
}

// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
  if (self.tabBar.selectedItem == fourWeeksButton)
    return 29;
  if (self.tabBar.selectedItem == eightWeeksButton)
    return 57;
  else
    return 85;
}


CGFloat lastValue;
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
  //NSInteger tester = (NSInteger)[graphData objectAtIndex:index];
  if (fieldEnum == CPTScatterPlotFieldX) {
    return [NSNumber numberWithUnsignedInteger:index];
  }
  else {
  //dateManipulator = [[DateManipulator alloc] init];
  NSDate *today = [NSDate date];
    NSString *dateToCompare;
    if (self.tabBar.selectedItem == fourWeeksButton) {
      dateToCompare = [dateManipulator getStringOfDateWithoutTimeOrDay:[dateManipulator findDateWithOffset:-(28-index) date:today]];
    }
    else if (self.tabBar.selectedItem == eightWeeksButton) {
      dateToCompare = [dateManipulator getStringOfDateWithoutTimeOrDay:[dateManipulator findDateWithOffset:-(56-index) date:today]];
    }
    else {
      dateToCompare = [dateManipulator getStringOfDateWithoutTimeOrDay:[dateManipulator findDateWithOffset:-(84-index) date:today]];
    }
    
    NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  //return [graphData objectAtIndex:index];
  if (index == 0) {
    if (![profile boolForKey:@"unitType"])
      lastValue = [[[graphData objectAtIndex:0] lbs ]floatValue];
    else
      lastValue = [[[graphData objectAtIndex:0] kg ]floatValue];
  }
    for (int s = 0; s < [graphData count]; s++) {
      StoredWeight *weight = [graphData objectAtIndex:s];
      NSDate *date = [weight date];
      NSString *otherString = [dateManipulator getStringOfDateWithoutTimeOrDay:date];
      
      if ([dateToCompare isEqual:otherString]) {
        if (![profile boolForKey:@"unitType"]) {
          lastValue = [[weight lbs] floatValue];
          return [weight lbs];
        }
        else {
          lastValue = [[weight kg] floatValue];
          return [weight kg];
        }
        
      }
      
    }
  return [NSNumber numberWithFloat:lastValue];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGraph {
  
  // allocate a frame for the host view
  hostView = [[CPTGraphHostingView alloc] initWithFrame:[self.graphView bounds]];
  [self.graphView addSubview: hostView];
  
  // Create a CPTGraph object and add to hostView
  graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
  [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
  
  // attach graph to hostview
  hostView.hostedGraph = graph;
  [self setupPlotSpace];
  
}

-(void)setupPlotSpace {
  
  // Get the (default) plotspace from the graph so we can set its x/y ranges
  plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
  // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
  plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
  
  // Pad the plot area frame
  graph.plotAreaFrame.paddingTop    = 20.0;
  graph.plotAreaFrame.paddingBottom = 60.0;
  graph.plotAreaFrame.paddingLeft   = 70.0;
  //graph.plotAreaFrame.paddingRight  = 50.0;
  
  plot.dataSource = self;
  

  [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
  CPTXYAxisSet *xyAxisSet = (CPTXYAxisSet *)graph.axisSet;
  CPTXYAxis *xAxis = xyAxisSet.xAxis;
  
  CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
  lineStyle.lineWidth = 2.0f;
  lineStyle.lineColor = [CPTColor greenColor];
  plot.dataLineStyle = lineStyle;
  
  CPTXYAxis *yAxis = xyAxisSet.yAxis;
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  if (![profile boolForKey:@"unitType"])
    yAxis.title = @"Weight (lbs)";
  else {
    yAxis.title = @"Weight (kg)";
  }
  yAxis.titleOffset = 45;
  yAxis.majorIntervalLength = [[[NSDecimalNumber alloc] initWithInt:1.0] decimalValue];
  yAxis.minorTickLength = 0.5;
  xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
  
  [self setVariablesForTabIndex];
  
}

-(void)setVariablesForTabIndex {
  
  CPTXYAxisSet *xyAxisSet = (CPTXYAxisSet *)graph.axisSet;
  CPTXYAxis *xAxis = xyAxisSet.xAxis;
  
  NSDate *today = [NSDate date];
  NSArray *dates;
  NSInteger numberOfDays;
  if (self.tabBar.selectedItem == fourWeeksButton) {
    numberOfDays = 28;
  }
  else if (self.tabBar.selectedItem == eightWeeksButton) {
    numberOfDays = 56;
  }
  else {
    numberOfDays = 84;
  }
  
  dates = [self createDatesArray:numberOfDays];
  
  NSMutableArray *ticks = [NSMutableArray arrayWithCapacity:1];
  for (int i = 0; i < [dates count]; i++) {
    [ticks addObject:[NSNumber numberWithInt:i*(numberOfDays/4)]];
  }
  
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [dateManipulator findDateWithOffset:-numberOfDays date:today], today];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  MealController *controller = [MealController sharedInstance];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"StoredWeight" inManagedObjectContext:[controller managedObjectContext]]];
  [request setPredicate:predicate];
  [request setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  NSMutableArray *results = [NSMutableArray arrayWithArray:[[controller managedObjectContext] executeFetchRequest:request error:&error]];
  graphData = results;
  
  NSUserDefaults *profile = [NSUserDefaults standardUserDefaults];
  CGFloat lowerBound;
  CGFloat upperBound;
  if (![profile boolForKey:@"unitType"]) {
    lowerBound = [[[results objectAtIndex:0] lbs] floatValue];
    upperBound = [[[results objectAtIndex:0] lbs] floatValue];
  }
  else {
    lowerBound = [[[results objectAtIndex:0] kg] floatValue];
    upperBound = [[[results objectAtIndex:0] kg] floatValue];
  }
  for (int i = 0; i < [results count]; i++) {
     if (![profile boolForKey:@"unitType"]) { 
    if ([[[results objectAtIndex:i] lbs] floatValue] < lowerBound) {
      lowerBound = [[[results objectAtIndex:i] lbs] floatValue];
    }
    if ([[[results objectAtIndex:i] lbs] floatValue] > upperBound) {
      upperBound = [[[results objectAtIndex:i] lbs] floatValue];
    }
     }
     else {
       if ([[[results objectAtIndex:i] kg] floatValue] < lowerBound) {
         lowerBound = [[[results objectAtIndex:i] kg] floatValue];
       }
       if ([[[results objectAtIndex:i] kg] floatValue] > upperBound) {
         upperBound = [[[results objectAtIndex:i] kg] floatValue];
       }
     }
  }
  
  // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
  [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( lowerBound-1.5 ) length:CPTDecimalFromFloat( (upperBound + 1.5) - (lowerBound-1.5))]];
  
  [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( numberOfDays + (numberOfDays/4) )]];
  
  NSUInteger labelLocation = 0;
  NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[dates count]];
  
  for (NSNumber *tickLocation in ticks) {
    CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[dates objectAtIndex:labelLocation++] textStyle:xAxis.labelTextStyle];
    //newLabel.tickLocation = [[[NSDecimalNumber alloc] initWithDouble:([tickLocation floatValue] * 7.0)+1] decimalValue];
    newLabel.tickLocation = [tickLocation decimalValue];
    newLabel.offset = 3.0f;
    newLabel.rotation = M_PI/3.5f;
    [customLabels addObject:newLabel];
  }

  xAxis.axisLabels =  [NSSet setWithArray:customLabels];
  xAxis.majorTickLocations = [NSSet setWithArray:ticks];
  xAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0];
  
  
}

-(NSArray*)createDatesArray:(NSInteger)numberOfDays {
  NSDate *today = [NSDate date];
  NSArray *dates = [NSArray arrayWithObjects:[dateManipulator getStringOfDateWithoutTimeOrDay:[dateManipulator findDateWithOffset:-numberOfDays date:today]],[dateManipulator getStringOfDateWithoutTimeOrDay:[dateManipulator findDateWithOffset:-(numberOfDays - (numberOfDays/4)) date:today]],[dateManipulator getStringOfDateWithoutTimeOrDay:[dateManipulator findDateWithOffset:-(numberOfDays - (numberOfDays/2)) date:today]],[dateManipulator getStringOfDateWithoutTimeOrDay:[dateManipulator findDateWithOffset:-(numberOfDays - (3*(numberOfDays/4))) date:today]], [dateManipulator getStringOfDateWithoutTimeOrDay:today], nil];
  return dates;
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
 
  [self setVariablesForTabIndex];
  [plot reloadData];
  
}



@end
