//
//  ViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 23/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "ViewController.h"
#import "ForgotPasswrdViewController.h"
#import "HomeTabViewController.h"
#import "MainTabViewController.h"
#import "PortfolioHttpClient.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TextfieldViewController.h"


#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width


@interface ViewController ()<UITextFieldDelegate>

#define IS_IPHONE_5 (IS_IPHONE && DEVICE_HEIGHT == 568.0) ? YES : NO
#define IS_IPHONE_6 (IS_IPHONE && DEVICE_HEIGHT == 667.0) ? YES : NO
#define IS_IPHONE_6P (IS_IPHONE && DEVICE_HEIGHT == 736.0) ? YES : NO

#define isiPhone5Device (DEVICE_HEIGHT == 568) ? YES : NO
@property(weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UILabel *enableTouchIDLbl;

@property (weak, nonatomic) IBOutlet UIButton *YourSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak,nonatomic) IBOutlet UIButton *loginBtn;
@property CGFloat shiftForKeyboard;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotUrpasswrdBtn;
@property (weak, nonatomic) IBOutlet UILabel *loginWthPassrd;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *lineView1;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UILabel *lognImgLbl;
@property (weak, nonatomic) IBOutlet UILabel *passwrdnImgLbl;
@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton *touchIdBtn;
@property BOOL isRemember;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.lognImgLbl setFont:[UIFont fontWithName:@"liscio" size:15]];
    [self.lognImgLbl setText:[NSString stringWithUTF8String:"\uE821"]];
    
    [self.passwrdnImgLbl setFont:[UIFont fontWithName:@"liscio" size:15]];
    [self.passwrdnImgLbl setText:[NSString stringWithUTF8String:"\uEC13"]];

//    self.loginBtn.layer.borderWidth = 1.0;
//    self.loginBtn.layer.borderColor = [[UIColor colorWithRed:81.0/255.0 green:122.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor];
    self.loginBtn.layer.cornerRadius = 4;
    
    self.rememberBtn.layer.borderWidth = 1.0;
    self.rememberBtn.layer.borderColor = [[UIColor colorWithRed:81.0/255.0 green:122.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor];
    self.rememberBtn.layer.cornerRadius = 3;

    self.touchIdBtn.layer.borderWidth = 1.0;
    self.touchIdBtn.layer.borderColor = [[UIColor colorWithRed:81.0/255.0 green:122.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor];
    self.touchIdBtn.layer.cornerRadius = 3;

    
    self.lognImgLbl.layer.borderWidth = 1.0;
    self.lognImgLbl.layer.borderColor = [[UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0] CGColor];
    self.lognImgLbl.layer.cornerRadius = self.lognImgLbl.frame.size.height/2;
    self.lognImgLbl.layer.masksToBounds = YES;
    

    self.passwrdnImgLbl.layer.borderWidth = 1.0;
    self.passwrdnImgLbl.layer.borderColor = [[UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0] CGColor];
    self.passwrdnImgLbl.layer.cornerRadius = self.passwrdnImgLbl.frame.size.height/2;
    self.passwrdnImgLbl.layer.masksToBounds = YES;

    
    [self.eyeBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:15]];
    [self.eyeBtn setTitle:[NSString stringWithUTF8String:"\uEC53"] forState:UIControlStateNormal];


    self.loginView.layer.borderWidth  = 1.0;
    self.loginView.layer.borderColor = [[UIColor colorWithRed:201.0/255.0 green:203.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor];
    self.loginView.layer.cornerRadius = 4.0;
    
    [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateNormal];
    [self.YourSwitch setSelected:NO];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
 

    self.rememberBtn.selected = YES;
    self.isRemember = YES;
   /* UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //enter code here
    }];
    [alert addAction:defaultAction];
    //Present action where needed
    [self presentViewController:alert animated:YES completion:nil];
*/
    
}

-(IBAction)rememberMeBtnPressed:(UIButton *)sender
{
    if (sender.selected)
    {
        self.isRemember = YES;
        sender.selected = NO;
        sender.backgroundColor = [UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString* textField1Text = self.emailTxtFld.text;
        [defaults setObject:textField1Text forKey:@"textField1Text"];
        
        NSString *textField2Text = self.passwordTxtFld.text;
        [defaults setObject:textField2Text forKey:@"textField2Text"];
        [defaults synchronize];
        
    }
    else
    {
        self.isRemember = NO;

        sender.selected = YES;
        sender.backgroundColor = [UIColor whiteColor];

    }
}

-(IBAction)touchUdBtnPressed:(id)sender
{
    
}
-(IBAction)eyeBtnPressed:(id)sender
{

//    self.passwordTxtFld.secureTextEntry = false;
    if (self.eyeBtn.selected)
    {
        self.eyeBtn.selected = NO;

        self.passwordTxtFld.secureTextEntry = YES;
    }
    else
    {
     
        self.eyeBtn.selected = YES;
        self.passwordTxtFld.secureTextEntry = NO;
    }
}
-(void) viewWillAppear:(BOOL)animated
{
//    LAContext *context = [[LAContext alloc] init];
//    NSError *error = nil;
//    NSString *reason = @"Please authenticate using TouchID.";

    if(self.isRemember == YES)
    {
        self.emailTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"textField1Text"];
        self.passwordTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"textField2Text"];

    }

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TermsAccepted"])
    {
        self.emailTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Email"];
        
        self.touchIdBtn.backgroundColor = [UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0];
    }else{
        self.touchIdBtn.backgroundColor = [UIColor whiteColor];
        
    }

    self.navigationController.navigationBarHidden = YES;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
//    LAContext *context = [[LAContext alloc] init];
//    NSError *error = nil;
//    NSString *reason = @"Please authenticate using TouchID.";
    
//    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
//    {
//        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
//                localizedReason:reason
//                          reply:^(BOOL success, NSError *error) {
//
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  if (success)
//                                  {
//                                      [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_on.png"] forState:UIControlStateSelected];
//                                      [self.YourSwitch setSelected:YES];
//
////                                      self.YourSwitch.selected = !self.YourSwitch.selected;
//
//
//                                      NSLog(@"Auth was OK");
//                                      
//                                      if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TermsAccepted"])
//                                      {
//                                          
//                                          [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//                                          
//                                          __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
//                                          [self.activityIndicator startAnimating];
//                                          
//                                          NSDictionary *params1 = @{@"user" : @{@"email" : [[NSUserDefaults standardUserDefaults] valueForKey:@"Email"],
//                                                                                @"password" : [[NSUserDefaults standardUserDefaults] valueForKey:@"password"],
//                                                                                @"plateform":@"true",
//                                                                                @"deviceId" :[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],
//                                                                                @"company_name" : @"modernadvisors"}};
//                                          
//                                          
//                                          [sharedObject signIn:params1 success:^(NSDictionary *responseObject)
//                                           {
//                                               
//                                               [self.activityIndicator stopAnimating];
//                                               if ([responseObject[@"error"] isEqualToString:@"Login failed"])
//                                               {
//                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                                   [alert show];
//                                                   
//                                               }
//                                               else{
//                                                   
//                                                   if([responseObject[@"success"] boolValue] == 1)
//                                                   {
//                                                       NSLog(@"My responseObject \n%@", responseObject);
//                                                       NSString *responseStr = responseObject[@"auth_token"];
//                                                       [[NSUserDefaults standardUserDefaults] setObject:responseStr forKey:@"auth_token"];
//                                                       [[NSUserDefaults standardUserDefaults] synchronize];
//
//                                                       HomeTabViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabViewController"];
//                                                       [self.navigationController pushViewController:homeVC animated:YES];
//                                                   }
//                                                   else
//                                                   {
//                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                                       [alert show];
//                                                   }
//                                                   
//                                               }
//                                               
//                                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                                               
//                                               [self.activityIndicator stopAnimating];
//                                               
//                                           }];
//                                          
//                                      }else
//                                      {
//                                          TextfieldViewController *txtVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TextfieldViewController"];
//                                          [self.navigationController pushViewController:txtVC animated:YES];
//                                          [self.activityIndicator stopAnimating];
//                                      }
//                                  }
//                                  else {
//                                      //You should do better handling of error here but I'm being lazy
//                                      
////                                      [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateSelected];
////                                      self.YourSwitch.selected = !self.YourSwitch.selected;
//
//                                      NSLog(@"Error received: %@", error);
//                                      
//                                      
//                                  }
//                              });
//                          }];
//    }
//    else {
//        
//        [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateNormal];
//        [self.YourSwitch setSelected:NO];
//
////        self.YourSwitch.selected = !self.YourSwitch.selected;
//
//        
//        NSLog(@"Can not evaluate Touch ID");
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!!!" message:@"TouchID not enrolled???" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        
//    }
    
    
    
}


- (IBAction)switchToggled:(UIButton *)sender
{
    if ([sender isSelected]) {
        [sender setSelected: NO];
    } else {
        [sender setSelected: YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}


- (IBAction)sendMagicLinkPressed:(id)sender
{
    
    if ([self.emailTxtFld.text isEqualToString:@""] || [self.passwordTxtFld.text isEqualToString:@""])  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Please fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    NSDictionary *params1 = @{@"user" : @{@"email" : self.emailTxtFld.text,
                                          @"password" : self.passwordTxtFld.text,
                                          @"plateform":@"true",
                                          @"deviceId" :[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],
                                          @"company_name" : @"modernadvisors"}};
    
    [sharedObject signIn:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         if([responseObject[@"success"] boolValue] == 1)
         {
             NSLog(@"My responseObject \n%@", responseObject);
             NSString *responseStr = responseObject[@"auth_token"];
             [[NSUserDefaults standardUserDefaults] setObject:responseStr forKey:@"auth_token"];
                 HomeTabViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabViewController"];
                 [self.navigationController pushViewController:homeVC animated:YES];
         }else{
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
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
         
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You are not authorized to login from this domain" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
             //enter code here
         }];
         [alert addAction:defaultAction];
         //Present action where needed
         [self presentViewController:alert animated:YES completion:nil];

         
         
         
     }];
}

- (IBAction)forgotPasswrdBtnPressed:(id)sender
{
    ForgotPasswrdViewController *forgotVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswrdViewController"];
    [self.navigationController pushViewController:forgotVC animated:YES];
}



-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [self.emailTxtFld resignFirstResponder];
    [self.passwordTxtFld resignFirstResponder];
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    if (bottomEdge >= 260) {//250
        CGRect viewFrame = self.view.frame;
        self.shiftForKeyboard = bottomEdge - 280;
        if(!isiPhone5Device)
        {
            self.shiftForKeyboard = bottomEdge - 235;
        }
        viewFrame.origin.y -= self.shiftForKeyboard;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
    else
    {
        self.shiftForKeyboard = 0.0f;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    if(viewFrame.origin.y!=0)
    {
        // Adjust the origin back for the viewFrame CGRect
        viewFrame.origin.y += self.shiftForKeyboard;
        // Set the shift value back to zero
        self.shiftForKeyboard = 0.0f;
        
        // As above, the following animation setup just makes it look nice when shifting
        // Again, we don't really need the animation code, but we'll leave it in here
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        // Apply the new shifted vewFrame to the view
        [self.view setFrame:viewFrame];
        // More animation code
        [UIView commitAnimations];
    }
}


@end
