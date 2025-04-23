//
//  AddViewController.m
//  WorkShop ToDo
//
//  Created by JETSMobileLab9 on 23/04/2025.
//

#import "AddViewController.h"
#import "UserDefultsHelper.h"
#import "Task.h"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *taskTitle;
@property (weak, nonatomic) IBOutlet UITextField *taskDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pripority;
@property (weak, nonatomic) IBOutlet UIDatePicker *taskDate;

@property Task *currentTask;
//@property UserDefultsHelper *helper;
@property NSUserDefaults *ud;
@property NSMutableArray *savedTasks;
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _helper = [UserDefultsHelper new];
    _currentTask =[Task new];
    _currentTask.status=0;
    _currentTask.taskID= [[NSUUID UUID] UUIDString];

    _ud = [NSUserDefaults standardUserDefaults];
}
- (IBAction)addTask:(id)sender {
    NSString *title=[_taskTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *desc =[_taskDescription.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger priority=_pripority.selectedSegmentIndex;
    NSDate *date=_taskDate.date;
    if (![title isEqualToString:@""] && ![desc isEqualToString:@""]) {
        _currentTask.title=title;
        _currentTask.desc= desc;
        _currentTask.priority=priority;
        _currentTask.date=date;
        NSData *encoded=[_ud objectForKey:@"tasks"];
        if(encoded){
            _savedTasks=[NSKeyedUnarchiver unarchiveObjectWithData:encoded];
            NSLog(@"%ld",(long)_savedTasks.count);
        }else{
            _savedTasks=[NSMutableArray new];
        }
        [_savedTasks addObject:_currentTask];
        NSData *encoded2 = [NSKeyedArchiver archivedDataWithRootObject:_savedTasks];
        [_ud setObject:encoded2 forKey:@"tasks"];
        [_ud synchronize];

        NSLog(@"After add %ld",(long)_savedTasks.count);
        
        [self showAlert:@"Task Added Successfully" withMessage:@"Great job your task saved"andPop:YES];

    }else{
        [self showAlert:@"InCompelete inputs" withMessage:@"Make sure you added all details before click add"andPop:NO];
    }
    
//    [_helper addTask:_currentTask];
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
