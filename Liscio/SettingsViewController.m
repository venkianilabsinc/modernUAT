//
//  SettingsViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 26/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "SettingsViewController.h"
#import "TeamViewController.h"
#import "PortfolioHttpClient.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *teamBtn;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTxtFld;
@property (strong, nonatomic) NSMutableDictionary *accountsDict;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.accountsDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self.navigationController setNavigationBarHidden:YES];
    self.updateBtn.layer.masksToBounds = true;
    self.updateBtn.layer.cornerRadius = 15.0;
    
    [self.logoutBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.logoutBtn setTitle:[NSString stringWithUTF8String:"\uE900"] forState:UIControlStateNormal];
    
    [self.teamBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.teamBtn setTitle:[NSString stringWithUTF8String:"\uE903"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];


    [self getAccountInfomation];
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

-(void) getAccountInfomation
{
    
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
//    NSDictionary *params1 = @{@"email" : self.emailTxtFld.text};
    
    [sharedObject getProfile:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         self.accountsDict = responseObject[@"data"];

         NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
         for (NSString * key in [self.accountsDict allKeys])
         {
             if (![[self.accountsDict objectForKey:key] isKindOfClass:[NSNull class]])
                 [prunedDictionary setObject:[self.accountsDict objectForKey:key] forKey:key];
         }

         if ([responseObject[@"status"] integerValue] == 200)
         {
             self.firstNameTxtFld.text = [prunedDictionary objectForKey:@"first_name"];
             self.lastNameTxtFld.text = [prunedDictionary objectForKey:@"last_name"];
             self.emailTxtFld.text = [prunedDictionary objectForKey:@"email"];
             self.phoneNumberTxtFld.text = [prunedDictionary objectForKey:@"phone"];


         }
     }
    failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
     }];

}

-(IBAction)logoutBtnPressed:(id)sender
{
    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];

//    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(IBAction)updatePressed:(id)sender
{
    
    if ([self.firstNameTxtFld.text isEqualToString:@""]|| [self.lastNameTxtFld.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please fill all the first and lastname" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //enter code here
            
        }];
        [alert addAction:defaultAction];
        //Present action where needed
        [self presentViewController:alert animated:YES completion:nil];
        
        return;

    }
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
        NSDictionary *params1 = @{@"first_name" : self.firstNameTxtFld.text,
                                  @"last_name" : self.lastNameTxtFld.text,
                                  @"phone" : self.phoneNumberTxtFld.text};
    
    [sharedObject updateProfile:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         if ([responseObject[@"status"] integerValue] == 200)
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 [self getAccountInfomation];
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];

             
         }else{
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
//                 [self getAccountInfomation];
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


-(IBAction)teamBtnPressed:(id)sender
{
    TeamViewController *teamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamViewController"];
    [self.navigationController pushViewController:teamVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
