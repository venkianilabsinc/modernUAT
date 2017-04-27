//
//  ForgotPasswrdViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 23/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "ForgotPasswrdViewController.h"
#import "AlertViewController.h"
#import "LiscioAlertViewController.h"
#import "PortfolioHttpClient.h"
#import "HomeTabViewController.h"
@interface ForgotPasswrdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *arrowMarkLbl;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ForgotPasswrdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.arrowMarkLbl setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.arrowMarkLbl setText:[NSString stringWithUTF8String:"\ue628"]];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitBtnPressed:(id)sender
{
    if ([self.emailTxtFld.text isEqualToString:@""])  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Please enter your Email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    NSDictionary *params1 = @{@"email" : self.emailTxtFld.text};
    
    [sharedObject forgotPasword:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         if ([responseObject[@"status"] integerValue] == 200)
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 
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

- (IBAction)sendMagicBtnPressed:(id)sender
{
    LiscioAlertViewController *liscioalertVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LiscioAlertViewController"];
    [self.navigationController pushViewController:liscioalertVC animated:YES];


}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
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
