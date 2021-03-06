//
//  PlaygroundsTableViewController.m
//  Enmrk
//
//  Created by Vitaliy Harchenko on 01.03.15.
//  Copyright (c) 2015 Vitaliy Harchenko. All rights reserved.
//

#import "PlaygroundsTableViewController.h"
#import "ENTransformator.h"
#import "StatusViewController.h"
#import "Reachability.h"

@interface PlaygroundsTableViewController ()

@end

@implementation PlaygroundsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Торговые площадки";
    
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_playgrounds count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[_playgrounds objectAtIndex:[indexPath row]] objectForKey:@"name"];
    cell.detailTextLabel.text = [ENTransformator parseStatusForTransformator:_transformator forPlayground:[_playgrounds objectAtIndex:[indexPath row]] forPlaygroundStatuses:_playgroundsStatuses];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ([_isNew integerValue] == 0) {
        if (networkStatus == NotReachable)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Редактирование объявлений закрыто. Отсутствует подключение к интернету" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else
        {
            [self performSegueWithIdentifier:@"statusSegue" sender:self];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Работа с публикацией объявлений невозможна. Отсутствует подключение к интернету. Сначала синхронизируйте добавленные трансформаторы." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"statusSegue"]) {
        [segue.destinationViewController setTransformator:_transformator];
        [segue.destinationViewController setIsNew:_isNew];
        [segue.destinationViewController setPlaygroundsStatuses:_playgroundsStatuses];
        NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
        [segue.destinationViewController setSelectedPlayground:[_playgrounds objectAtIndex:[indexPath row]]];
    }
}


@end
