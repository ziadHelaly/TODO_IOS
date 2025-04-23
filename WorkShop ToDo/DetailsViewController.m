//
//  DetailsViewController.m
//  WorkShop ToDo
//
//  Created by JETSMobileLab9 on 23/04/2025.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextField *taskDesc;
@property NSMutableArray *savedTasks;
@property NSUserDefaults *ud;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _taskTitle.text=_task.title;
    _taskDesc.text=_task.desc;
    _priority.selectedSegmentIndex=_task.priority;
    _status.selectedSegmentIndex=_task.status;
    _date.date=_task.date;
    _date.minimumDate=[NSDate date];

    
}
- (IBAction)edit:(id)sender {
    _ud = [NSUserDefaults standardUserDefaults];
    NSString *title=[_taskTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *desc =[_taskDesc.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger priority=_priority.selectedSegmentIndex;
    NSInteger status=_status.selectedSegmentIndex;
    NSDate *date=_date.date;
    
    _task.title=title;
    _task.desc= desc;
    _task.priority=priority;
    _task.date=date;
    _task.status=status;
    NSData *encoded=[_ud objectForKey:@"tasks"];
    
    if(encoded){
        _savedTasks=[NSKeyedUnarchiver unarchiveObjectWithData:encoded];
        NSLog(@"%ld",(long)_savedTasks.count);
    }else{
        _savedTasks=[NSMutableArray new];
    }
    
    NSUInteger index = [_savedTasks indexOfObjectPassingTest:^BOOL(Task *obj, NSUInteger idx,BOOL *stop) {
        return [obj.taskID isEqualToString:_task.taskID];
    }];

    if (index != NSNotFound) {
        [_savedTasks replaceObjectAtIndex:index withObject:_task];
    } else {
        [_savedTasks addObject:_task]; // fallback if not found (optional)
    }

    NSData *encoded2 = [NSKeyedArchiver archivedDataWithRootObject:_savedTasks];
    [_ud setObject:encoded2 forKey:@"tasks"];
    [_ud synchronize];
    [self showAlert:@"Task Updated Successfully" withMessage:@"Great job your task saved"andPop:YES];


}
- (void)showAlert:(NSString *)text withMessage:(NSString *)message andPop :(Boolean) pop{
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:text message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (pop) {
            [self.table update];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
