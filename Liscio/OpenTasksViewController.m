//
//  OpenTasksViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 26/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "OpenTasksViewController.h"
#import "OpenTasksTableViewCell.h"
#import "TaskDetailViewController.h"
#import "SettingsViewController.h"
#import "PortfolioHttpClient.h"

@interface OpenTasksViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UITableView *openTasksTable;
@property (weak, nonatomic) IBOutlet UILabel *tasksCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *archieveLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (strong, nonatomic) NSMutableArray *closeArray;
@property (strong, nonatomic) NSMutableArray *openArray;
@property (strong, nonatomic) NSMutableArray *reviewArray;
@property (strong, nonatomic) NSMutableDictionary *totalDict;
@property (strong, nonatomic) NSMutableArray *templatesArray;
@property (strong, nonatomic) NSMutableArray *myArray;

@property (weak, nonatomic) IBOutlet UILabel *noRecrdLbl;


@end

@implementation OpenTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.closeArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.openArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.reviewArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.templatesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.myArray = [[NSMutableArray alloc] initWithCapacity:0];

    self.totalDict = [[NSMutableDictionary alloc] initWithCapacity:0];

    self.navigationController.navigationBarHidden = YES;
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\uE626"] forState:UIControlStateNormal];

    self.openTasksTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
        self.tasksCountLbl.layer.cornerRadius = self.tasksCountLbl.frame.size.height/2;
        self.tasksCountLbl.layer.masksToBounds = YES;
    
        self.archieveLbl.layer.cornerRadius = self.archieveLbl.frame.size.height/2;
        self.archieveLbl.layer.masksToBounds = YES;


}
-(void) viewWillAppear:(BOOL)animated
{
    [self openTaskAPI];
}

-(void) openTaskAPI
{
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
//    NSDictionary *params1 = @{@"cpa_id" : @"1",
//                              @"subject" : @"",
//                              @"for_account" : @"1",
//                              @"assigned_to_user" : @"45",
//                              @"due_by" : @"",
//                              @"assigne_type" : @"",
//                              @"agreement_id" : @"",
//                              @"task_type_key" : @"",
//                              @"task_type_value" : @""};
    [sharedObject openTasks:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         
         if([responseObject[@"message"] isEqualToString:@"success."])
         {
             NSLog(@"My responseObject \n%@", responseObject);
             self.totalDict = (NSMutableDictionary *)responseObject;
             self.templatesArray = self.totalDict[@"templates"];
             self.closeArray = [self.templatesArray valueForKey:@"Archive"][0];
             self.openArray = [self.templatesArray valueForKey:@"Open"][0];
             self.reviewArray = [self.templatesArray valueForKey:@"Review"][0];

//             self.myArray = (NSMutableArray *)[self.closeArray arrayByAddingObjectsFromArray:self.openArray];
             
             self.tasksCountLbl.text = [@(self.openArray.count) stringValue];
             self.archieveLbl.text = [@(self.closeArray.count) stringValue];

             [self.openTasksTable reloadData];
             if ([self.archieveLbl.text isEqualToString:@"0"])
             {
                 self.openTasksTable.hidden = YES;
                 self.noRecrdLbl.hidden = NO;
             }else{
                 self.openTasksTable.hidden = NO;
                 self.noRecrdLbl.hidden = YES;
                 
                 
             }
             
             if ([self.tasksCountLbl.text isEqualToString:@"0"])
             {
                 self.openTasksTable.hidden = YES;
                 self.noRecrdLbl.hidden = NO;
             }else{
                 self.openTasksTable.hidden = NO;
                 self.noRecrdLbl.hidden = YES;
             }
             [self.openTasksTable reloadData];


         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.openArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OepnTaskscellID";
    
    OpenTasksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.titleLbl.text = [[self.openArray valueForKey:@"subject"] objectAtIndex:indexPath.row];
    cell.dateLbl.text = [[self.openArray valueForKey:@"due_date"] objectAtIndex:indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TaskDetailViewController *taskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetailViewController"];
    taskVC.taskDict = [self.openArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:taskVC animated:YES];
    
}

-(IBAction)settingsBtnClicked:(id)sender
{
    SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

-(IBAction)opensBtnClicked:(id)sender
{
    self.archieveLbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.tasksCountLbl.backgroundColor = [UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0];
    
    self.archieveLbl.textColor = [UIColor darkGrayColor];
    self.tasksCountLbl.textColor = [UIColor whiteColor];

    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    //    NSDictionary *params1 = @{@"cpa_id" : @"1",
    //                              @"subject" : @"",
    //                              @"for_account" : @"1",
    //                              @"assigned_to_user" : @"45",
    //                              @"due_by" : @"",
    //                              @"assigne_type" : @"",
    //                              @"agreement_id" : @"",
    //                              @"task_type_key" : @"",
    //                              @"task_type_value" : @""};
    [sharedObject openTasks:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         
         if([responseObject[@"message"] isEqualToString:@"success."])
         {
             NSLog(@"My responseObject \n%@", responseObject);
             self.totalDict = (NSMutableDictionary *)responseObject;
             self.templatesArray = self.totalDict[@"templates"];
             self.closeArray = [self.templatesArray valueForKey:@"Archive"][0];
             self.openArray = [self.templatesArray valueForKey:@"Open"][0];
             self.reviewArray = [self.templatesArray valueForKey:@"Review"][0];
             
             //             self.myArray = (NSMutableArray *)[self.closeArray arrayByAddingObjectsFromArray:self.openArray];
             
             self.tasksCountLbl.text = [@(self.openArray.count) stringValue];
             self.archieveLbl.text = [@(self.closeArray.count) stringValue];
             
            /* if ([self.archieveLbl.text isEqualToString:@"0"])
             {
                 self.openTasksTable.hidden = YES;
                 self.noRecrdLbl.hidden = NO;
             }else{
                 self.openTasksTable.hidden = NO;
                 self.noRecrdLbl.hidden = YES;
                 
                 
             }*/
             
             if ([self.tasksCountLbl.text isEqualToString:@"0"])
             {
                 self.openTasksTable.hidden = YES;
                 self.noRecrdLbl.hidden = NO;
             }else{
                 self.openTasksTable.hidden = NO;
                 self.noRecrdLbl.hidden = YES;
                 
                 
             }
             [self.openTasksTable reloadData];

             
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];

}
-(IBAction)archieveBtnClicked:(id)sender
{
    self.archieveLbl.backgroundColor = [UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0];
    self.tasksCountLbl.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.archieveLbl.textColor = [UIColor whiteColor];
    self.tasksCountLbl.textColor = [UIColor darkGrayColor];

    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    //    NSDictionary *params1 = @{@"cpa_id" : @"1",
    //                              @"subject" : @"",
    //                              @"for_account" : @"1",
    //                              @"assigned_to_user" : @"45",
    //                              @"due_by" : @"",
    //                              @"assigne_type" : @"",
    //                              @"agreement_id" : @"",
    //                              @"task_type_key" : @"",
    //                              @"task_type_value" : @""};
    [sharedObject openTasks:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         
         if([responseObject[@"message"] isEqualToString:@"success."])
         {
             NSLog(@"My responseObject \n%@", responseObject);
             self.totalDict = (NSMutableDictionary *)responseObject;
             self.templatesArray = self.totalDict[@"templates"];
//             self.closeArray = [self.templatesArray valueForKey:@"Close"][0];
             self.openArray = [self.templatesArray valueForKey:@"Archive"][0];
             self.reviewArray = [self.templatesArray valueForKey:@"Open"][0];
             
             //             self.myArray = (NSMutableArray *)[self.closeArray arrayByAddingObjectsFromArray:self.openArray];
             
             self.tasksCountLbl.text = [@(self.reviewArray.count) stringValue];
             self.archieveLbl.text = [@(self.openArray.count) stringValue];
             
             if ([self.archieveLbl.text isEqualToString:@"0"])
             {
                 self.openTasksTable.hidden = YES;
                 self.noRecrdLbl.hidden = NO;
             }else{
                 self.openTasksTable.hidden = NO;
                 self.noRecrdLbl.hidden = YES;
             }
             
             /*if ([self.tasksCountLbl.text isEqualToString:@"0"])
             {
                 self.openTasksTable.hidden = YES;
                 self.noRecrdLbl.hidden = NO;
             }else{
                 self.openTasksTable.hidden = NO;
                 self.noRecrdLbl.hidden = YES;
                 
                 
             }*/
             [self.openTasksTable reloadData];


         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
