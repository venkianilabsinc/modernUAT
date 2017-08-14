//
//  MyRelatedAccountsViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 26/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "MyRelatedAccountsViewController.h"
#import "MyRelatedTableViewCell.h"
#import "AccountInformationViewController.h"
#import "SettingsViewController.h"
#import "PortfolioHttpClient.h"

@interface MyRelatedAccountsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UITableView *myRelativesTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noRecrdsLbl;
@property (strong, nonatomic) NSMutableArray *accountsArray;

@end

@implementation MyRelatedAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    
    self.accountsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\ue94f"] forState:UIControlStateNormal];
    
    self.myRelativesTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


}


-(void)viewWillAppear:(BOOL)animated
{
    [self getRelatedAccountsAPI];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString* textField1Text = @"MyRelated";
    [defaults setObject:textField1Text forKey:@"isFromViewCtrl"];


}

-(void) getRelatedAccountsAPI
{
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
//    NSDictionary *params1 = @{@"id" : self.taskDict[@"id"]};
    [sharedObject contactsListWithotId:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"My responseObject \n%@", responseObject);
         
         if ([responseObject[@"status"] integerValue] == 200)
         {
             self.accountsArray = responseObject[@"data"];
             
             if (self.accountsArray.count)
             {
                 self.noRecrdsLbl.hidden = YES;
                 self.myRelativesTable.hidden = NO;

             }else{
                 self.noRecrdsLbl.hidden = NO;
                 self.myRelativesTable.hidden = YES;

             }
         }else{
             
             self.noRecrdsLbl.hidden = NO;
             self.myRelativesTable.hidden = YES;

         }
         
         [self.myRelativesTable reloadData];
         
         
         
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
    return self.accountsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyRelatedcellID";
    
    MyRelatedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.titleLbl.text = [[self.accountsArray valueForKey:@"label"] objectAtIndex:indexPath.row];
//    cell.subTitleLbl.text = [NSString stringWithFormat:@"Entity Type: %@", [[self.accountsArray valueForKey:@"entity_type"] objectAtIndex:indexPath.row]];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AccountInformationViewController *accVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInformationViewController"];
    accVC.accountDict = [self.accountsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:accVC animated:YES];
    
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
