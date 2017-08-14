//
//  TextfieldViewController.m
//  Corporate Portal
//
//  Created by Anilabs Inc on 11/06/16.
//  Copyright © 2016 Sparity. All rights reserved.
//

#import "TextfieldViewController.h"
#import "PortfolioHttpClient.h"
#import "HomeTabViewController.h"

#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width

#define isiPhone5Device (DEVICE_HEIGHT == 568) ? YES : NO

@interface TextfieldViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passWordTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//@property (weak, nonatomic) IBOutlet UILabel *imgLbl;
//@property (weak, nonatomic) IBOutlet UILabel *passwordImgLbl;
@property CGFloat shiftForKeyboard;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *lognImgLbl;
@property (weak, nonatomic) IBOutlet UILabel *passwrdnImgLbl;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;

@end

@implementation TextfieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.eyeBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:15]];
    [self.eyeBtn setTitle:[NSString stringWithUTF8String:"\uEC53"] forState:UIControlStateNormal];

    [self.lognImgLbl setFont:[UIFont fontWithName:@"liscio" size:15]];
    [self.lognImgLbl setText:[NSString stringWithUTF8String:"\uE821"]];
    
    [self.passwrdnImgLbl setFont:[UIFont fontWithName:@"liscio" size:15]];
    [self.passwrdnImgLbl setText:[NSString stringWithUTF8String:"\uEC13"]];

    self.lognImgLbl.layer.borderWidth = 1.0;
    self.lognImgLbl.layer.borderColor = [[UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0] CGColor];
    self.lognImgLbl.layer.cornerRadius = self.lognImgLbl.frame.size.height/2;
    self.lognImgLbl.layer.masksToBounds = YES;
    
    
    self.passwrdnImgLbl.layer.borderWidth = 1.0;
    self.passwrdnImgLbl.layer.borderColor = [[UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0] CGColor];
    self.passwrdnImgLbl.layer.cornerRadius = self.passwrdnImgLbl.frame.size.height/2;
    self.passwrdnImgLbl.layer.masksToBounds = YES;

    self.loginView.layer.borderWidth  = 1.0;
    self.loginView.layer.borderColor = [[UIColor colorWithRed:201.0/255.0 green:203.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor];
    self.loginView.layer.cornerRadius = 4.0;

    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    
    [self.backBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:20]];
    [self.backBtn setTitle:[NSString stringWithUTF8String:"\uE752"] forState:UIControlStateNormal];
    
    
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.backBtn.layer.cornerRadius = self.backBtn.frame.size.height/2;
    self.backBtn.layer.masksToBounds = YES;
    
    [self.loginBtn.layer setBorderWidth:1.0];
    [self.loginBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.loginBtn layer] setCornerRadius:2.0f];
    
//    if ([self.userNameTxtFld respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//        UIColor *color = [UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0];
//        self.userNameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
//    } else {
//        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
//        // TODO: Add fall-back code to set placeholder color.
//    }
//    
//    if ([self.passWordTxtFld respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//        UIColor *color = [UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0];
//        self.passWordTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
//    } else {
//        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
//        // TODO: Add fall-back code to set placeholder color.
//    }
    

//    [self.imgLbl setFont:[UIFont fontWithName:@"liscio" size:15]];
//    [self.imgLbl setText:[NSString stringWithUTF8String:"\ue608"]];
//    
//    [self.passwordImgLbl setFont:[UIFont fontWithName:@"liscio" size:15]];
//    [self.passwordImgLbl setText:[NSString stringWithUTF8String:"\ue7a0"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)eyeBtnPressed:(id)sender
{
    
    //    self.passwordTxtFld.secureTextEntry = false;
    if (self.eyeBtn.selected)
    {
        self.eyeBtn.selected = NO;
        
        self.passWordTxtFld.secureTextEntry = YES;
    }
    else
    {
        
        self.eyeBtn.selected = YES;
        self.passWordTxtFld.secureTextEntry = NO;
    }
}

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginBtnAction:(UIButton *)sender
{
    if ([self.userNameTxtFld.text isEqualToString:@""] || [self.passWordTxtFld.text isEqualToString:@""])  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Please fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    sender.enabled = NO;
    
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    NSDictionary *params1 = @{@"user" : @{@"email" : self.userNameTxtFld.text,
                                          @"password" : self.passWordTxtFld.text,
                                          @"plateform":@"true",
                                          @"deviceId" :[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],
                                          @"company_name" : @"modernadvisors"}};
    [sharedObject signIn:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];

         sender.enabled = YES;
         
         if([responseObject[@"success"] boolValue] == 1)
         {
             NSLog(@"My responseObject \n%@", responseObject);
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TermsAccepted"];

             NSString *responseStr = responseObject[@"auth_token"];
             [[NSUserDefaults standardUserDefaults] setObject:responseStr forKey:@"auth_token"];
             
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TermsAccepted"];
             [[NSUserDefaults standardUserDefaults] setObject:self.userNameTxtFld.text forKey:@"Email"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [[NSUserDefaults standardUserDefaults] setObject:self.passWordTxtFld.text forKey:@"password"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             HomeTabViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabViewController"];
             [self.navigationController pushViewController:homeVC animated:YES];
         }
         else
         {

             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];

         sender.enabled = YES;
         
         //         [GiFHUD dismiss];
     }];
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
    
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [self.userNameTxtFld resignFirstResponder];
    [self.passWordTxtFld resignFirstResponder];
    
    
    return YES;
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
