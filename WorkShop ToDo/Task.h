//
//  Task.h
//  WorkShop ToDo
//
//  Created by JETSMobileLab9 on 23/04/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding>
@property NSString *taskID,*title, *desc;
@property NSInteger priority , status;
@property NSDate *date;
@end

NS_ASSUME_NONNULL_END
