//
//  AccountInformationViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 27/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "AccountInformationViewController.h"
#import "SettingsViewController.h"
#import "PortfolioHttpClient.h"

#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface AccountInformationViewController ()

#define IS_IPHONE_5 (IS_IPHONE && DEVICE_HEIGHT == 568.0) ? YES : NO
#define IS_IPHONE_6 (IS_IPHONE && DEVICE_HEIGHT == 667.0) ? YES : NO
#define IS_IPHONE_6P (IS_IPHONE && DEVICE_HEIGHT == 736.0) ? YES : NO

@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrolView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *accountInformationLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *entityTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *websiteLbl;
@property (weak, nonatomic) IBOutlet UILabel *leadOwnerLbl;
@property (weak, nonatomic) IBOutlet UILabel *adrees1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *addr2Lbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *stateLbl;
@property (weak, nonatomic) IBOutlet UILabel *zipLbl;
@property (weak, nonatomic) IBOutlet UILabel *noOfEmplysLbl;
@property (weak, nonatomic) IBOutlet UILabel *industryLbl;

@property (strong, nonatomic) NSMutableDictionary *accountsDict;

@property (strong, nonatomic) NSMutableArray *dependantArray;

@end

@implementation AccountInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\uE626"] forState:UIControlStateNormal];
    
    self.accountsDict  = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.dependantArray  = [[NSMutableArray alloc] initWithCapacity:0];

    if (IS_IPHONE_5)
    {
        [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 420)];

    }


}

-(void) viewWillAppear:(BOOL)animated
{
    [self getAccountDetails];
}

-(void) getAccountDetails
{
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
        NSDictionary *params1 = @{@"id" : self.accountDict[@"value"]};
    [sharedObject contactDetail:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"My responseObject \n%@", responseObject);
         if ([responseObject[@"status"] integerValue] == 200)
         {
             self.accountsDict = responseObject[@"data"][@"account"];
             self.dependantArray = responseObject[@"data"][@"dependant"];
             
             NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
             for (NSString * key in [self.accountsDict allKeys])
             {
                 if (![[self.accountsDict objectForKey:key] isKindOfClass:[NSNull class]])
                     [prunedDictionary setObject:[self.accountsDict objectForKey:key] forKey:key];
             }

             NSLog(@"pruned dictis\n%@", prunedDictionary);
             
             self.accountInformationLbl.text = prunedDictionary[@"name"];
             self.emailLbl.text = prunedDictionary[@"email"];
             self.entityTypeLbl.text = prunedDictionary[@"entity_type"];
             self.phoneLbl.text = prunedDictionary[@"phone_number"];
             self.websiteLbl.text = prunedDictionary[@"website"];
             self.leadOwnerLbl.text = @"";
             self.adrees1Lbl.text = prunedDictionary[@"address_line_1"];
             self.addr2Lbl.text = prunedDictionary[@"address_line_2"];
             self.cityLbl.text = prunedDictionary[@"address_city"];
             self.stateLbl.text = prunedDictionary[@"address_state"];
             self.zipLbl.text = prunedDictionary[@"address_zip"];
             self.noOfEmplysLbl.text = @"";
             self.industryLbl.text = prunedDictionary[@"co_industry"];
         }
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
