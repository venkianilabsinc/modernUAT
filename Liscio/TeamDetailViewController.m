//
//  TeamDetailViewController.m
//  Liscio
//
//  Created by Anilabs - Venki on 4/20/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "PortfolioHttpClient.h"
#import "TeamDetailTableViewCell.h"
#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>


@interface TeamDetailViewController ()<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *teamDetailArray;
@property (weak, nonatomic) IBOutlet UITableView *teamDetailTableView;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@end

@implementation TeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.teamDetailArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.teamDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\uE626"] forState:UIControlStateNormal];

    

}

-(void) viewWillAppear:(BOOL)animated
{
    [self teamDetailAPI];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) teamDetailAPI
{
    
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
        NSDictionary *params1 = @{@"account_id" : self.teamDict[@"account_id"]};
    
    [sharedObject teamDetail:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         if([responseObject[@"success"] boolValue] == 1)
         {
             NSLog(@"%@", responseObject);
             self.teamDetailArray = responseObject[@"data"];
             
             [self.teamDetailTableView reloadData];
         }else{
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
    return self.teamDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    NSMutableDictionary *dict = [self.teamDetailArray objectAtIndex:indexPath.row];
    TeamDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
//    cell.titleLbl.text  = [NSString stringWithFormat:@"%@ %@", dict[@"first_name"], dict[@"last_name"]];
//    cell.subTitleLbl.text  = [NSString stringWithFormat:@"%@ %@", @"Entity Type :", dict[@"entity_type"]];
    
    [cell.phoneBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [cell.phoneBtn setTitle:[NSString stringWithUTF8String:"\ue933"] forState:UIControlStateNormal];

    [cell.mailBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    [cell.mailBtn setTitle:[NSString stringWithUTF8String:"\uE935"] forState:UIControlStateNormal];
    
    if ([dict[@"avatar"] isEqualToString:@""])
    {
        cell.imageView.image = [UIImage imageNamed:@"avatar.png"];
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"https:%@", dict[@"avatar"]];
        NSURL *imageURL = [NSURL URLWithString:urlStr];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];

        UIImage *image = [UIImage imageWithData:imageData];
        
        

        
        
        cell.imageView.image = image;
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2;

    }
//    cell.imageView.center = cell.imageView.superview.center;
    cell.imageView.clipsToBounds = YES;

    cell.nameLbl.text = [NSString stringWithFormat:@"%@ %@ - %@", dict[@"first_name"],dict[@"last_name"],dict[@"entity_type"]];
    
        cell.phoneBtn.layer.cornerRadius = cell.phoneBtn.frame.size.height/2;
        cell.phoneBtn.layer.masksToBounds = YES;
    
        cell.mailBtn.layer.cornerRadius = cell.mailBtn.frame.size.height/2;
        cell.mailBtn.layer.masksToBounds = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(IBAction)settingsBtnClicked:(id)sender
{
    SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}


-(IBAction)phoneBtnClicked:(id)sender
{
    TeamDetailTableViewCell *cell;// = (SPConferenceScheduleTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *indexPath; //= [self.conferenceScheduleTable indexPathForCell:cell];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        cell = (TeamDetailTableViewCell *)[[[sender superview] superview] superview];
        indexPath = [self.teamDetailTableView indexPathForCell:cell];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        cell = (TeamDetailTableViewCell *)[[sender superview] superview];
        indexPath = [self.teamDetailTableView indexPathForCell:cell];
    }
    
    NSLog(@"indexpath is%@", indexPath);
    
    NSString *phoneStr = [[self.teamDetailArray valueForKey:@"phone"] objectAtIndex:indexPath.row];
    
    if (phoneStr == nil || [phoneStr isEqual:[NSNull null]])
    {
        phoneStr = @"";
    }

    
//    NSString *phNo = @"+919876543210";
    NSString *phoneNumberString;
    phoneNumberString = [phoneStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    phoneNumberString = [NSString stringWithFormat@"tel:%@", phoneStr];

    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phoneNumberString]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }

}

-(IBAction)mailBtnClicked:(id)sender
{
    
    TeamDetailTableViewCell *cell;// = (SPConferenceScheduleTableViewCell *)[[[sender superview] superview] superview];
    NSIndexPath *indexPath; //= [self.conferenceScheduleTable indexPathForCell:cell];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        cell = (TeamDetailTableViewCell *)[[[sender superview] superview] superview];
        indexPath = [self.teamDetailTableView indexPathForCell:cell];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        cell = (TeamDetailTableViewCell *)[[sender superview] superview];
        indexPath = [self.teamDetailTableView indexPathForCell:cell];
    }
    
    NSLog(@"indexpath is%@", indexPath);
    
    NSString *mailStr = [[self.teamDetailArray valueForKey:@"email"] objectAtIndex:indexPath.row];
    
    if (mailStr == nil || [mailStr isEqual:[NSNull null]])
    {
        mailStr = @"";
    }
    

    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"Liscio";
    // To address
//    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO]; 
    [mc setToRecipients:@[mailStr]];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
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
