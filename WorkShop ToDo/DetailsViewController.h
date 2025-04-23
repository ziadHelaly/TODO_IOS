//
//  DetailsViewController.h
//  WorkShop ToDo
//
//  Created by JETSMobileLab9 on 23/04/2025.
//

#import "ViewController.h"
#import "Task.h"
#import "MyDelegation.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : ViewController
@property Task *task;
@property id<MyDelegation> table;
@end

NS_ASSUME_NONNULL_END
