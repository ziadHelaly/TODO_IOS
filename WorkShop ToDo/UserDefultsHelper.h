//
//  UserDefultsHelper.h
//  WorkShop ToDo
//
//  Created by JETSMobileLab9 on 23/04/2025.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDefultsHelper : NSObject
@property NSUserDefaults *myUserDefaults;
- (void)addTask:(Task *)task;
- (nullable Task *)getTaskWithId:(NSString *)taskID;
- (NSMutableArray<Task *> *)getTasks;
- (void)saveTasks;
@end

NS_ASSUME_NONNULL_END
