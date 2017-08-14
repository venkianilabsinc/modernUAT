//
//  AlertViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 23/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginView.layer.borderWidth  = 1.0;
    self.loginView.layer.borderColor = [[UIColor colorWithRed:201.0/255.0 green:203.0/255.0 blue:204.0/255.0 alpha:1.0] CGColor];
    self.loginView.layer.cornerRadius = 4.0;

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
- (IBAction)BackToLoginBtnPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
