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


@interface ViewController ()

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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self.arrowMarkLbl setFont:[UIFont fontWithName:@"icomoon" size:25]];
//    [self.arrowMarkLbl setText:[NSString stringWithUTF8String:"\ue628"]];
    
    self.loginBtn.layer.borderWidth = 2.0;
    self.loginBtn.layer.borderColor = [[UIColor colorWithRed:139.0/255.0 green:221.0/255.0 blue:245.0/255.0 alpha:1.0] CGColor];
    self.loginBtn.layer.cornerRadius = 4;
    
    [self.eyeBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:15]];
    [self.eyeBtn setTitle:[NSString stringWithUTF8String:"\uEC53"] forState:UIControlStateNormal];

    
    [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateNormal];
    [self.YourSwitch setSelected:NO];
    
    self.navigationController.navigationBarHidden = YES;
    
    
//    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:self.titleLbl.text];
//    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,10)];
//    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:36.0/255.0 green:222.0/255.0 blue:255.0/255.0 alpha:1.0] range:NSMakeRange(11,6)];
//    self.titleLbl.attributedText = string;
    
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
//    [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_on.png"] forState:UIControlStateSelected];
//    [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateNormal];

    if (IS_IPHONE_5)
    {
        self.enableTouchIDLbl.frame = CGRectMake(5, self.enableTouchIDLbl.frame.origin.y, self.enableTouchIDLbl.frame.size.width+35, self.enableTouchIDLbl.frame.size.height);
        self.YourSwitch.frame = CGRectMake(CGRectGetMaxX(self.enableTouchIDLbl.frame)-2, self.YourSwitch.frame.origin.y, self.YourSwitch.frame.size.width, self.YourSwitch.frame.size.height);
    }
    

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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TermsAccepted"])
    {
        self.emailTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Email"];
    }

    self.navigationController.navigationBarHidden = YES;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *reason = @"Please authenticate using TouchID.";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reason
                          reply:^(BOOL success, NSError *error) {

                              dispatch_async(dispatch_get_main_queue(), ^{
                                  if (success)
                                  {
                                      [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_on.png"] forState:UIControlStateSelected];
                                      [self.YourSwitch setSelected:YES];

//                                      self.YourSwitch.selected = !self.YourSwitch.selected;


                                      NSLog(@"Auth was OK");
                                      
                                      if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TermsAccepted"])
                                      {
                                          
                                          [[AFNetworkReachabilityManager sharedManager] startMonitoring];
                                          
                                          __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
                                          [self.activityIndicator startAnimating];
                                          
                                          NSDictionary *params1 = @{@"user" : @{@"email" : [[NSUserDefaults standardUserDefaults] valueForKey:@"Email"],
                                                                                @"password" : [[NSUserDefaults standardUserDefaults] valueForKey:@"password"],
                                                                                @"plateform":@"true"}};
                                          
                                          
                                          [sharedObject signIn:params1 success:^(NSDictionary *responseObject)
                                           {
                                               
                                               [self.activityIndicator stopAnimating];
                                               if ([responseObject[@"error"] isEqualToString:@"Login failed"])
                                               {
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                   [alert show];
                                                   
                                               }
                                               else{
                                                   
                                                   if([responseObject[@"success"] boolValue] == 1)
                                                   {
                                                       NSLog(@"My responseObject \n%@", responseObject);
                                                       NSString *responseStr = responseObject[@"auth_token"];
                                                       [[NSUserDefaults standardUserDefaults] setObject:responseStr forKey:@"auth_token"];
                                                       [[NSUserDefaults standardUserDefaults] synchronize];

                                                       HomeTabViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabViewController"];
                                                       [self.navigationController pushViewController:homeVC animated:YES];
                                                   }
                                                   else
                                                   {
                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                       [alert show];
                                                   }
                                                   
                                               }
                                               
                                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                               
                                               [self.activityIndicator stopAnimating];
                                               
                                           }];
                                          
                                      }else
                                      {
                                          TextfieldViewController *txtVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TextfieldViewController"];
                                          [self.navigationController pushViewController:txtVC animated:YES];
                                          [self.activityIndicator stopAnimating];
                                      }
                                  }
                                  else {
                                      //You should do better handling of error here but I'm being lazy
                                      
//                                      [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateSelected];
//                                      self.YourSwitch.selected = !self.YourSwitch.selected;

                                      NSLog(@"Error received: %@", error);
                                      
                                      
                                  }
                              });
                          }];
    }
    else {
        
        [self.YourSwitch setImage:[UIImage imageNamed:@"toggle_off.png"] forState:UIControlStateNormal];
        [self.YourSwitch setSelected:NO];

//        self.YourSwitch.selected = !self.YourSwitch.selected;

        
        NSLog(@"Can not evaluate Touch ID");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Alert!!!" message:@"TouchID not enrolled???" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        
    }
    
    
    
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
                                          @"plateform":@"true"}};
    
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
         }
     }
    failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
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
