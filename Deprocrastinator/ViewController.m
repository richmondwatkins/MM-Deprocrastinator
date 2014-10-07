//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Richmond on 10/6/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *taskTextField;
@property NSMutableArray *listArray;
@property BOOL isEditable;
@property NSIndexPath *editingIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEditable = NO;
    self.listArray = [NSMutableArray new];
    // Do any additional setup after loading the view, typically from a nib.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];

    if([self.tableView.indexPathsForSelectedRows containsObject:indexPath]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    cell.textLabel.text = [NSString stringWithFormat:@ "%@",  [self.listArray objectAtIndex:indexPath.row] ];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (IBAction)onAddButtonPressed:(id)sender {

    NSArray *paths = [NSArray arrayWithObject: [NSIndexPath indexPathForRow:self.listArray.count inSection:0]];
    NSString *newItem = self.taskTextField.text;
        [self.listArray addObject:newItem];
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
    self.taskTextField.text = @"";

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];

    if (self.isEditable) {
        [self.listArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        [tableView reloadData];
    }else{
        if (selectCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            selectCell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            selectCell.accessoryType = UITableViewCellAccessoryCheckmark;

        }
    }
}
- (IBAction)swipeOnCell:(UISwipeGestureRecognizer *)swipe {
    UITableViewCell *swipedCell  = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForRowAtPoint:[swipe locationInView:self.tableView]]];

    if (swipedCell.backgroundColor == [UIColor whiteColor]) {
        swipedCell.backgroundColor = [UIColor greenColor];
        swipedCell.textLabel.backgroundColor = [UIColor greenColor];
    }else if(swipedCell.backgroundColor == [UIColor greenColor]){
        swipedCell.backgroundColor = [UIColor yellowColor];
        swipedCell.textLabel.backgroundColor = [UIColor yellowColor];
    }else if(swipedCell.backgroundColor == [UIColor yellowColor]){
        swipedCell.backgroundColor = [UIColor redColor];
        swipedCell.textLabel.backgroundColor = [UIColor redColor];
    }else{
        swipedCell.backgroundColor = [UIColor whiteColor];
        swipedCell.textLabel.backgroundColor = [UIColor whiteColor];

    }

}

- (IBAction)editTable:(UIBarButtonItem * )sender {

    if (self.isEditable) {
        [self.tableView setEditing:NO animated:YES];
        sender.title = @"Edit";
    }else{
        [self.tableView setEditing:YES animated:YES];
        sender.title = @"Done";
    }

    self.isEditable = !self.isEditable;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        self.editingIndex = indexPath;
        UIAlertView *alertView = [[UIAlertView alloc]init];
        alertView.delegate = self;
        alertView.title = @"Are you sure?";
        [alertView addButtonWithTitle:@"Delete"];
        [alertView addButtonWithTitle:@"Cancel"];
        [alertView show];

    }

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.listArray removeObjectAtIndex:self.editingIndex.row];
        [self.tableView deleteRowsAtIndexPaths:@[self.editingIndex] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSInteger sourceRow = sourceIndexPath.row;
    NSInteger destRow = destinationIndexPath.row;
    id object = [self.listArray objectAtIndex:sourceRow];
    [self.listArray removeObjectAtIndex:sourceRow];
    [self.listArray insertObject:object atIndex:destRow];
}

@end
