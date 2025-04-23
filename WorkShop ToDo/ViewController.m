//
//  ViewController.m
//  WorkShop ToDo
//
//  Created by ziad helaly on 22/04/2025.
//

#import "ViewController.h"
#import "DetailsViewController.h"
#import "UserDefultsHelper.h"
#import "Task.h"
#import "AddViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray<Task*> *high,*medium,*low;

@property NSMutableArray<Task*> *savedTasks;
@property NSUserDefaults *ud;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self categorizeTasks];
}
- (IBAction)add:(id)sender {
    AddViewController *a =[self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    a.table=self;
    [self.navigationController pushViewController:a animated:YES];
}
- (void)categorizeTasks {
    _ud = [NSUserDefaults standardUserDefaults];
    NSData *encoded = [_ud objectForKey:@"tasks"];
    if (encoded) {
        NSError *error = nil;
        _savedTasks = [NSKeyedUnarchiver unarchiveObjectWithData:encoded];
        if (error) {
            NSLog(@"Error decoding tasks: %@", error.localizedDescription);
        }
    } else {
        _savedTasks = [NSMutableArray new];
    }
    _high = [_savedTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priority == 0 AND status == 0"]];
    _medium = [_savedTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priority == 1 AND status == 0"]];
    _low = [_savedTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"priority == 2 AND status == 0"]];
    
    NSLog(@"%ld High tasks", (long)_high.count);
    NSLog(@"%ld Medium tasks", (long)_medium.count);
    NSLog(@"%ld Low tasks", (long)_low.count);
    
    [self.tableView reloadData];
}

- (void)update {
    [self categorizeTasks];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return _high.count;
        case 1: return _medium.count;
        case 2: return _low.count;
        default: return 0;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        switch (section) {
            case 0:
                return @"High";
                break;
            case 1:
                return @"Medium";
                break;
            default:
                return @"Low";
                break;
        }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Task *task;
    switch (indexPath.section) {
        case 0: {
            task = _high[indexPath.row];
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



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *taskToDelete;
        
        switch (indexPath.section) {
            case 0: taskToDelete = _high[indexPath.row]; break;
            case 1: taskToDelete = _medium[indexPath.row]; break;
            case 2: taskToDelete = _low[indexPath.row]; break;
        }
        
        [_savedTasks removeObject:taskToDelete];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_savedTasks requiringSecureCoding:NO error:nil];
        [_ud setObject:data forKey:@"tasks"];
        [_ud synchronize];
        
        [self categorizeTasks];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    switch (indexPath.section) {
        case 0: detailsVC.task = _high[indexPath.row]; break;
        case 1: detailsVC.task = _medium[indexPath.row]; break;
        case 2: detailsVC.task = _low[indexPath.row]; break;
    }
    detailsVC.table=self;
    
    [self.navigationController pushViewController:detailsVC animated:YES];
}


@end
