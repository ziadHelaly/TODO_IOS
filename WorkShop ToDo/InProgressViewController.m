//
//  InProgressViewController.m
//  WorkShop ToDo
//
//  Created by JETSMobileLab9 on 23/04/2025.
//

#import "InProgressViewController.h"
#import "DetailsViewController.h"
#import "UserDefultsHelper.h"
#import "Task.h"

@interface InProgressViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property NSArray<Task*> *high,*medium,*low;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL sorted;
@property NSMutableArray<Task*> *savedTasks;
@property NSUserDefaults *ud;
@end

@implementation InProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sorted=NO;
}
- (void)viewDidAppear:(BOOL)animated{
    [self categorizeTasks];

}
- (void)categorizeTasks {
    _ud = [NSUserDefaults standardUserDefaults];
    NSData *encoded = [_ud objectForKey:@"tasks"];
    if (encoded) {
        NSError *error = nil;
        NSArray *unarchivedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
        _savedTasks = [[unarchivedTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status == 1"]] mutableCopy];
        
        if (error) {
            NSLog(@"Error decoding tasks: %@", error.localizedDescription);
        }
    } else {
        _savedTasks = [NSMutableArray new];
    }
    _high = [_savedTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priority == 0 AND status == 1"]];
    _medium = [_savedTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priority == 1 AND status == 1"]];
    _low = [_savedTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priority == 2 AND status == 1"]];
    
    NSLog(@"%ld High tasks", (long)_high.count);
    NSLog(@"%ld Medium tasks", (long)_medium.count);
    NSLog(@"%ld Low tasks", (long)_low.count);
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_sorted)?3:1;
}

- (IBAction)sort:(id)sender {
    _sorted= !_sorted;
    [_sortButton setTitle:(_sorted)? @"UnSort":@"Sort" forState:UIControlStateNormal];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!_sorted) return _savedTasks.count;
    switch (section) {
        case 0: return _high.count;
        case 1: return _medium.count;
        case 2: return _low.count;
        default: return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (!_sorted) {
        return @"In Progress Tasks";
    }
    switch (section) {
            case 0:
                return @"High";
            case 1:
                return @"Medium";
            default:
                return @"Low";
        }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Task *task;
    
    switch (indexPath.section) {
        case 0: {
            if (!_sorted) {
                task= _savedTasks[indexPath.row];
            }else{
                task = _high[indexPath.row];
            }
            cell.imageView.image = [UIImage imageNamed:@"high"];
            break;
        }
        case 1: {
            task = _medium[indexPath.row];
            cell.imageView.image =[UIImage imageNamed:@"medium"];
            break;
        }
        case 2: {
            task = _low[indexPath.row];
            cell.imageView.image =[UIImage imageNamed:@"low"];
            break;
        }
    }
        
    cell.textLabel.text = task.title;
    
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *taskToDelete;
        
        switch (indexPath.section) {
            case 0: {
                if (!_sorted) {
                    taskToDelete = _savedTasks[indexPath.row];
                }else{
                    taskToDelete = _high[indexPath.row];
                }
                
                break;
            }
            case 1: taskToDelete = _medium[indexPath.row]; break;
            case 2: taskToDelete = _low[indexPath.row]; break;
        }
        NSUInteger index = [_savedTasks indexOfObject:taskToDelete];
        if (index != NSNotFound) {
            [_savedTasks removeObjectAtIndex:index];
        }

//        [_savedTasks removeObject:taskToDelete];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_savedTasks requiringSecureCoding:NO error:nil];
        [_ud setObject:data forKey:@"tasks"];
        [_ud synchronize];
        
        [self categorizeTasks];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    switch (indexPath.section) {
        case 0: {
            if (!_sorted) {
                detailsVC.task = _savedTasks[indexPath.row];
            }else{
                detailsVC.task = _high[indexPath.row];
            }
            
            break;
        }
        case 1: detailsVC.task = _medium[indexPath.row]; break;
        case 2: detailsVC.task = _low[indexPath.row]; break;
    }
    detailsVC.table=self;
    
    [self.navigationController pushViewController:detailsVC animated:YES];
}


@end


