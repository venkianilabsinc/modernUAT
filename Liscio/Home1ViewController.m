//
//  Home1ViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 27/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "Home1ViewController.h"
#import "HomeTasksTableViewCell.h"
#import "SettingsViewController.h"
#import "TaskDetailViewController.h"
#import "NewsTableViewCell.h"
#import "NewsViewController.h"
#import "OpenTasksViewController.h"
#import "PortfolioHttpClient.h"

@interface Home1ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UITableView *homeTable;
@property (weak, nonatomic) IBOutlet UITableView *newsTable;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrolView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *openArray;
@property (strong, nonatomic) NSMutableDictionary *totalDict;
@property (strong, nonatomic) NSMutableArray *templatesArray;
@property (weak, nonatomic) IBOutlet UILabel *noRecrdsLbl;
@end

@implementation Home1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    //    [self.adminImgLbl setFont:[UIFont fontWithName:@"liscio" size:25]];
    //    [self.adminImgLbl setText:[NSString stringWithUTF8String:"\uEC02"]];
    
    [self.settingsBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.settingsBtn setTitle:[NSString stringWithUTF8String:"\uE626"] forState:UIControlStateNormal];
    
    self.moreBtn.layer.borderWidth = 1.0;
    self.moreBtn.layer.borderColor = [[UIColor colorWithRed:81.0/255.0 green:122.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor];
    self.moreBtn.layer.cornerRadius = 10;
    self.moreBtn.layer.masksToBounds = YES;
    
    self.countLbl.layer.cornerRadius = self.countLbl.frame.size.height/2;
    self.countLbl.layer.masksToBounds = YES;

    self.homeTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.newsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];

    self.openArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.templatesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.totalDict = [[NSMutableDictionary alloc] initWithCapacity:0];
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
         NSLog(@"My responseObject \n%@", responseObject);

         if ([responseObject[@"status"] integerValue] == 200)
         {
             
             self.totalDict = (NSMutableDictionary *)responseObject;
             self.templatesArray = self.totalDict[@"templates"];
            self.openArray = [self.templatesArray valueForKey:@"Open"][0];
             
             self.countLbl.text = [@(self.openArray.count) stringValue];
             [self.homeTable reloadData];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
         if (self.openArray.count)
         {
             self.noRecrdsLbl.hidden = YES;
             self.homeTable.hidden = NO;
             
         }else{
             self.noRecrdsLbl.hidden = NO;
             self.homeTable.hidden = YES;
             
         }

         
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];
    
}

-(IBAction)moreBtnClicked:(id)sender
{
    
    [self.navigationController.tabBarController setSelectedIndex:1];
//    OpenTasksViewController *openVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OpenTasksViewController"];
//    [self.navigationController pushViewController:openVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 9) {
        return self.openArray.count;

    }else{
        return 2;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 9)
    {
        static NSString *cellIdentifier = @"cellID1";
        
        HomeTasksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.titleLbl.text = [[self.openArray valueForKey:@"subject"] objectAtIndex:indexPath.row];
        
        return cell;

    }else{
        static NSString *cellIdentifier = @"NewscellID";
        
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView.tag == 9)
    {
        TaskDetailViewController *taskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetailViewController"];
        taskVC.taskDict = [self.openArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:taskVC animated:YES];
 
    }else{
        NewsViewController *taskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsViewController"];
        [self.navigationController pushViewController:taskVC animated:YES];

    }


}

-(IBAction)settingsBtnClicked:(id)sender
{
    SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
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
