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


@end

@implementation TextfieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    
    [self.loginBtn.layer setBorderWidth:1.0];
    [self.loginBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [[self.loginBtn layer] setCornerRadius:2.0f];
    
    if ([self.userNameTxtFld respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0];
        self.userNameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    if ([self.passWordTxtFld respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0];
        self.passWordTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    

//    [self.imgLbl setFont:[UIFont fontWithName:@"icomoon" size:15]];
//    [self.imgLbl setText:[NSString stringWithUTF8String:"\ue608"]];
//    
//    [self.passwordImgLbl setFont:[UIFont fontWithName:@"icomoon" size:15]];
//    [self.passwordImgLbl setText:[NSString stringWithUTF8String:"\ue7a0"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                          @"plateform":@"true"}};
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
