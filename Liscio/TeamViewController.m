//
//  TeamViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 26/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamTableViewCell.h"
#import "SettingsViewController.h"
#import "PortfolioHttpClient.h"
#import "TeamDetailViewController.h"


@interface TeamViewController ()

@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *teamArray;
@property (weak, nonatomic) IBOutlet UITableView *teamTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecrdsLbl;
@end

@implementation TeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.teamArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\ue94f"] forState:UIControlStateNormal];
    
    
    self.teamTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self teamAPI];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString* textField1Text = @"Team";
    [defaults setObject:textField1Text forKey:@"isFromViewCtrl"];

}

-(void) teamAPI
{
    
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    //    NSDictionary *params1 = @{@"email" : self.emailTxtFld.text};
    
    [sharedObject team:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         if([responseObject[@"success"] boolValue] == 1)
         {
             self.noRecrdsLbl.hidden = YES;
             self.teamTableView.hidden = NO;
             
             self.teamArray = responseObject[@"data"];
             
             if (self.teamArray.count)
             {
                 self.noRecrdsLbl.hidden = YES;
                 self.teamTableView.hidden = NO;

             }else{
                 self.noRecrdsLbl.hidden = NO;
                 self.teamTableView.hidden = YES;

             }
             
             [self.teamTableView reloadData];
         }else{
             
             self.noRecrdsLbl.hidden = NO;
             self.teamTableView.hidden = YES;

             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];

         }
     }
    failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
     }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.teamArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    NSMutableDictionary *dict = [self.teamArray objectAtIndex:indexPath.row];
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.titleLbl.text  = dict[@"label"];//[NSString stringWithFormat:@"%@ %@", dict[@"first_name"], dict[@"last_name"]];
//    cell.subTitleLbl.text  = [NSString stringWithFormat:@"%@ %@", @"Entity Type :", dict[@"entity_type"]];

//    [cell.phoneImgLbl setFont:[UIFont fontWithName:@"liscio" size:25]];
//    [cell.phoneImgLbl setText:[NSString stringWithUTF8String:"\ue933"]];
//    
//    cell.phoneImgLbl.layer.cornerRadius = cell.phoneImgLbl.frame.size.height/2;
//    cell.phoneImgLbl.layer.masksToBounds = YES;
//    
//    cell.mailBtn.layer.cornerRadius = cell.mailBtn.frame.size.height/2;
//    cell.mailBtn.layer.masksToBounds = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    TeamTableViewCell *cell = (TeamTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:210/255.0 alpha:1.0];
    
    TeamDetailViewController *teamDVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamDetailViewController"];
    teamDVC.teamDict = [self.teamArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:teamDVC animated:YES];

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
