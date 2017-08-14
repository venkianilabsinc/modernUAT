//
//  LiscioAlertViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 23/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "LiscioAlertViewController.h"
#import "HomeTabViewController.h"

@interface LiscioAlertViewController ()
@property (weak, nonatomic) IBOutlet UILabel *arrowMarkLbl;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

@implementation LiscioAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginView.layer.borderWidth  = 1.0;
    self.loginView.layer.borderColor = [[UIColor colorWithRed:201.0/255.0 green:203.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor];
    self.loginView.layer.cornerRadius = 4.0;

    // Do any additional setup after loading the view.
    [self.arrowMarkLbl setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.arrowMarkLbl setText:[NSString stringWithUTF8String:"\ue628"]];
    

//    NSString *myStr = [NSString stringWithFormat:@" Hello!            %@", ];
    
    NSString *myStr = @"Hello!                ";
    NSString *myStr1 = @"We just sent an email to ";
    NSString *myStr2 = self.emailStr;
    NSString *myStr3 = @". If this email is associated with an account, it will include a link to login to your account.";
    
    NSString *mainStr = [NSString stringWithFormat:@"%@\n%@%@%@", myStr,myStr1,myStr2, myStr3];

    self.titleLbl.text = mainStr;
    [self.backBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:20]];
    [self.backBtn setTitle:[NSString stringWithUTF8String:"\uE752"] forState:UIControlStateNormal];
    
    
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.backBtn.layer.cornerRadius = self.backBtn.frame.size.height/2;
    self.backBtn.layer.masksToBounds = YES;
    

}

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInLiscioBtnPressed:(id)sender
{
    HomeTabViewController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeTabViewController"];
    [self.navigationController pushViewController:homeVC animated:YES];
    
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
