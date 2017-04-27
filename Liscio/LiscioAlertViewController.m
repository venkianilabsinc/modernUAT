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

@end

@implementation LiscioAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.arrowMarkLbl setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.arrowMarkLbl setText:[NSString stringWithUTF8String:"\ue628"]];

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
