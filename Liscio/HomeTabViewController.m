//
//  HomeTabViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 26/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "HomeTabViewController.h"
#import "PortfolioHttpClient.h"
#import "Home1ViewController.h"

@interface HomeTabViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSMutableDictionary *dataDic;

@end

@implementation HomeTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
//    [self.adminImgLbl setFont:[UIFont fontWithName:@"liscio" size:25]];
//    [self.adminImgLbl setText:[NSString stringWithUTF8String:"\uEC02"]];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    

    self.dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //inactive item images
    
    self.tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"modern_footer.png"]];


    [self.tabBar.items[0] setImage:[[UIImage imageNamed:@"home_icon.png"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[1] setImage:[[UIImage imageNamed:@"task_icon.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [self.tabBar.items[2] setImage:[[UIImage imageNamed:@"add_task_icon.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [self.tabBar.items[3] setImage:[[UIImage imageNamed:@"account_icon.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    [self.tabBar.items[4] setImage:[[UIImage imageNamed:@"team_icon.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    //active item images
    [self.tabBar.items[0] setSelectedImage:[[UIImage imageNamed:@"home_icon_active.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[1] setSelectedImage:[[UIImage imageNamed:@"task_icon_active.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[2] setSelectedImage:[[UIImage imageNamed:@"add_task_icon_active.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[3] setSelectedImage:[[UIImage imageNamed:@"account_icon_active.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self.tabBar.items[4] setSelectedImage:[[UIImage imageNamed:@"team_icon_active.png"]
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    

    [self.settingsBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.settingsBtn setTitle:[NSString stringWithUTF8String:"\uE942"] forState:UIControlStateNormal];

        self.moreBtn.layer.cornerRadius = 10;
        self.moreBtn.layer.masksToBounds = YES;

}

-(void) viewWillAppear:(BOOL)animated
{
//    [self homeAPI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) homeAPI
{
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
//    NSDictionary *params1 = @{@"authorization" : [[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"]};
    
    [sharedObject home:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         if([responseObject[@"success"] boolValue] == 1)
         {
             NSLog(@"My responseObject \n%@", responseObject);
             
             self.dataDic = responseObject[@"data"];
             NSLog(@"dataDict is.... \n%@", self.dataDic);

         }
     }
    failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
     }];
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
//    NSLog(@"venki controllers%@", self.viewControllers);


    if(item.tag==1)
    {
        NSLog(@"home pressed");
        [(UITabBarController*)self.navigationController.topViewController setSelectedIndex:0];
        //your code
    }
    else  if(item.tag==2)
    {
        NSLog(@"open tasks pressed");
        [(UITabBarController*)self.navigationController.topViewController setSelectedIndex:1];
        //your code
    }
    else  if(item.tag==3)
    {
        NSLog(@"NEW TASKS PRESSED");
        //your code
    }
    else  if(item.tag==4)
    {
        NSLog(@"MY RELATED pressed");
        [(UITabBarController*)self.navigationController.topViewController setSelectedIndex:3];
        //your code
    }else{
        
        NSLog(@"NEWS PRESSED");
        [(UITabBarController*)self.navigationController.topViewController setSelectedIndex:4];
    }
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
