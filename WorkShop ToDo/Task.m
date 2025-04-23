//
//  Task.m
//  WorkShop ToDo
//
//  Created by JETSMobileLab9 on 23/04/2025.
//

#import "Task.h"

@implementation Task
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.taskID forKey:@"taskID"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.desc forKey:@"desc"];
    [coder encodeInteger:self.priority forKey:@"priority"];
    [coder encodeInteger:self.status forKey:@"status"];
    [coder encodeObject:self.date forKey:@"date"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _taskID = [coder decodeObjectForKey:@"taskID"];
        _title = [coder decodeObjectForKey:@"title"];
        _desc = [coder decodeObjectForKey:@"desc"];
        _priority = [coder decodeIntegerForKey:@"priority"];
        _status = [coder decodeIntegerForKey:@"status"];
        _date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}
@end
