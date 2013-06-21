//
//  FDAppDelegate.m
//  FoodDiary
//
//  Created by James Hicklin on 2013-06-12.
//  Copyright (c) 2013 James Hicklin. All rights reserved.
//

#import "FDAppDelegate.h"
#import "FSClient.h"
#import "MyMeal.h"
#import "FoodDiaryViewController.h"

@implementation FDAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  
  NSManagedObjectContext *context = [self managedObjectContext];
  if (!context) {
    NSLog(@"Couldn't get context to access core data");
  }
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = [NSDate date];
  NSDateComponents *compsStart = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
  [compsStart setHour:0];
  [compsStart setMinute:0];
  [compsStart setSecond:0];
  NSDate *todayStart = [calendar dateFromComponents:compsStart];
  
  NSDateComponents *compsEnd = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
  [compsEnd setHour:23];
  [compsEnd setMinute:59];
  [compsEnd setSecond:59];
  NSDate *todayEnd = [calendar dateFromComponents:compsEnd];
  
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", todayStart, todayEnd];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"MyMeal" inManagedObjectContext:context]];
  [request setPredicate:predicate];
  
  NSError *error = nil;
  NSArray *results = [context executeFetchRequest:request error:&error];
  
  NSArray *mealsToday = results;
  
  if ([mealsToday count] == 0) {
    NSLog(@"No meals found today, we must create some");
    
    MyMeal *breakfast = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:context];
    [breakfast setName:@"Breakfast"];
    [breakfast setDate:date];
    
    if (![context save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
    MyMeal *lunch = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:context];
    [lunch setName:@"Lunch"];
    [lunch setDate:date];
    
    if (![context save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
    MyMeal *dinner = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:context];
    [dinner setName:@"Dinner"];
    [dinner setDate:date];
    
    if (![context save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
    MyMeal *snacks = (MyMeal*)[NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:context];
    [snacks setName:@"Snacks"];
    [snacks setDate:date];
    
    //NSError *error = nil;
    if (![context save:&error]) {
      NSLog(@"There was an error saving the data");
    }
    
  }
  else {
    for (int i = 0; i < [mealsToday count]; i++) {
      MyMeal *meal = [mealsToday objectAtIndex:i];
      NSLog([meal name]);
    }
  }
  
  
  
  // Check if this is the first time the app has been launched
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
  {
    // if so, do nothing - print this to terminal just so I know
    NSLog(@"We've seen you before");
  }
  else
  {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // This is the first launch ever
    NSLog(@"Welcome to the food diary app!");
    // Set tabController to open profile page if this is the first time ever launching the app
    NSLog(@"Root: %@", self.window.rootViewController);
    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
    tabController.selectedIndex = 3;
  }
  
  [FSClient sharedClient].oauthConsumerKey = @"b066c53bc69a42bba07b5d530f685611";
  [FSClient sharedClient].oauthConsumerSecret = @"c82eddab535842068c9ed771cb4c7e84";

  
   UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
   UINavigationController *navController = (UINavigationController*)[tabController.viewControllers objectAtIndex:0];
   FoodDiaryViewController *foodDiaryViewController = (FoodDiaryViewController*)navController.topViewController;
   foodDiaryViewController.managedObjectContext = context;
  
  
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FoodDiary" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FoodDiary.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
