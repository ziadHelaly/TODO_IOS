//
//  UserDefultsHelper.m
//  WorkShop ToDo
//
//  Created by JETSMobileLab9 on 23/04/2025.
//

#import "UserDefultsHelper.h"

@implementation UserDefultsHelper{
    NSMutableArray<Task *> *_tasks;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.myUserDefaults = [NSUserDefaults standardUserDefaults];
        _tasks = [[self loadTasks] mutableCopy] ?: [[NSMutableArray alloc] init];
        NSLog(@"ghj%ld", (long) _tasks.count);
    }
    return self;
}

- (void)addTask:(Task *)task {
    [_tasks addObject:task];
    [self saveTasks];
}

- (Task *)getTaskWithId:(NSString *)taskID {
    for (Task *task in _tasks) {
        if ([task.taskID isEqualToString:taskID]) {
            return task;
        }
    }
    return nil;
}

- (NSMutableArray<Task *> *)getTasks {
    return _tasks;
}

- (void)saveTasks {
    NSMutableArray *encodedTasks = [NSMutableArray array];
    for (Task *task in _tasks) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:task requiringSecureCoding:NO error:nil];
        if (data) {
            [encodedTasks addObject:data];
        }
    }
    [self.myUserDefaults setObject:encodedTasks forKey:@"tasks"];
    [self.myUserDefaults synchronize];
    NSLog(@"Saved %lu tasks to UserDefaults", (unsigned long)encodedTasks.count);

}

- (NSArray<Task *> *)loadTasks {
    NSArray *savedData = [self.myUserDefaults objectForKey:@"tasks"];
    NSMutableArray *decodedTasks = [NSMutableArray array];

    for (NSData *data in savedData) {
        Task *task = [NSKeyedUnarchiver unarchivedObjectOfClass:[Task class] fromData:data error:nil];
        if (task) {
            [decodedTasks addObject:task];
        }
    }

    return decodedTasks;
}

@end


