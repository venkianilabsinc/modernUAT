//
//  WebViewController.m
//  Liscio
//
//  Created by Anilabs - Venki on 4/11/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "WebViewController.h"
#import "SettingsViewController.h"
#import "PortfolioHttpClient.h"

@interface WebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *htmlWebView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *dotsBtn;
@property (weak, nonatomic) IBOutlet UIView *rejectView;
@property(weak, nonatomic )IBOutlet UITextField *rejectTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *checkMarkBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelImgBtn;

@property (strong, nonatomic) NSString *editedHtmlStr;

@property BOOL buttonCurrentStatus;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];

//    if (self.isfromPdf == YES)
//    {
//        self.submitBtn.hidden = YES;
//        self.rejectBtn.hidden = YES;
//        self.cancelBtn.hidden = YES;
//        
//    }else{
//        self.submitBtn.hidden = NO;
//        self.rejectBtn.hidden = NO;
//        self.cancelBtn.hidden = NO;
//        
//    }
//
    //E6FD
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\uE626"] forState:UIControlStateNormal];
    
    [self.cancelImgBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:30]];
    [self.cancelImgBtn setTitle:[NSString stringWithUTF8String:"\uE6FD"] forState:UIControlStateNormal];

    [self.dotsBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    [self.dotsBtn setTitle:[NSString stringWithUTF8String:"\uE75B"] forState:UIControlStateNormal];
    self.dotsBtn.layer.borderWidth = 1;
    self.dotsBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.dotsBtn.layer.cornerRadius = self.dotsBtn.frame.size.height/2;
    self.dotsBtn.layer.masksToBounds = YES;

    [self.htmlWebView setBackgroundColor:[UIColor clearColor]];
    //pass the string to the webview

    NSString *htmlString = [NSString stringWithFormat:@"<font family ='always' size='3'>%@",self.string];
    [self.htmlWebView loadHTMLString:htmlString baseURL:nil];
    [self.htmlWebView.scrollView  setShowsHorizontalScrollIndicator:NO];
    [self.activityIndicator stopAnimating];


}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finish");
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontFamily =\"alwaysforever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontSize =\"25\""];
    
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontFamily =\"alwaysforever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontSize =\"25\""];

}



//-(void) viewWillAppear:(BOOL)animated
//{
////    NSString *script1 = [NSString stringWithFormat:@"document.getElementById('font-size').innerHTML = '%@';", @"25"];
////    NSString *script = [NSString stringWithFormat:@"document.getElementById('font-weight').innerHTML = '%@';", @"light"];
////    
////    [self.htmlWebView stringByEvaluatingJavaScriptFromString:script1];
////    [self.htmlWebView stringByEvaluatingJavaScriptFromString:script];
//    
//        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.color =\"Dark Gray\""];
//        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontFamily =\"alwaysforever\""];
////        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontWeight =\"light\""];
//        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontSize =\"25\""];
//    
//        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.color =\"Dark Gray\""];
//        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontFamily =\"alwaysforever\""];
////        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontWeight =\"light\""];
//        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontSize =\"25\""];
//
//
//}
-(IBAction)settingsBtnPressed:(id)sender
{
    SettingsViewController *teamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:teamVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)submitBtnPressed:(id)sender
{
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.color =\"Dark Gray\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontFamily =\"always\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontWeight =\"always * forever\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontSize =\"25\""];
    
    
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.color =\"Dark Gray\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontFamily =\"always\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontWeight =\"always * forever\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontSize =\"25\""];
    
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.color =\"Dark Gray\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontFamily =\"always\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontWeight =\"always * forever\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontSize =\"25\""];
    
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.color =\"Dark Gray\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontFamily =\"always\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontWeight =\"always * forever\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontSize =\"25\""];
    
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.color =\"Dark Gray\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.fontFamily =\"always\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.fontWeight =\"always * forever\""];
    [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.fontSize =\"25\""];

    self.editedHtmlStr = [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];

        [self.activityIndicator startAnimating];
    
        PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
        NSDictionary *params1 = @{@"task_id" : self.taskString,
                                  @"content" : self.editedHtmlStr};
        [sharedObject generatePdfFile:params1 success:^(NSDictionary *responseObject)
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

             }else{
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 }];
                 [alert addAction:defaultAction];
                 //Present action where needed
                 [self presentViewController:alert animated:YES completion:nil];
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [self.activityIndicator stopAnimating];
         }];

}

-(IBAction)rejectBtnPressed:(id)sender
{
    self.rejectView.hidden = NO;
    self.htmlWebView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:125/255.0 green:136/255.0 blue:144/255.0 alpha:1.0];

}

-(IBAction)rejectSubmitBtn:(id)sender
{
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    NSDictionary *params1 = @{@"task_id" : self.taskString,
                              @"comment" : self.rejectTxtFld.text,
                              @"reject_task" : @"true"};
    [sharedObject addComment:params1 success:^(NSDictionary *responseObject)
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
             
         }else{
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 [self.navigationController popViewControllerAnimated:YES];
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];

         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];

}
-(IBAction)cancelBtn1Pressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(IBAction)checkMarkBtnPressed:(UIButton *)sender
{
    if (self.buttonCurrentStatus == NO)
    {
        self.buttonCurrentStatus = YES;
        self.submitBtn.backgroundColor = [UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:1.0];
        
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontFamily =\"alwaysforever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontSize =\"25\""];
        
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontFamily =\"alwaysforever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontSize =\"25\""];
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontFamily =\"alwaysforever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontSize =\"25\""];
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontFamily =\"alwaysforever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontSize =\"25\""];
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.fontFamily =\"alwaysforever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.fontSize =\"25\""];
        
        
        NSString *string9 = _myDict[@"assigne"];
        NSString *newString = [string9 stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *script;
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            script = [NSString stringWithFormat:@"document.getElementById('sign').innerHTML='%@';",newString];
            
        }else{
            script = [NSString stringWithFormat:@"document.getElementById('sign').innerHTML='%@';",string9];
            
        }
        
        
        //NSString *string99 = [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementById('sign').offsetWidth;"];
        
        
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy";
        NSString *string = [formatter stringFromDate:[NSDate date]];
        
        
        
        NSString *script1 = [NSString stringWithFormat:@"document.getElementById('currDate').innerHTML = '%@';",string];
        
        
        
        //        [self.htmlWebView stringByEvaluatingJavaScriptFromString:string99];
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:script];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:script1];
        
        //        self.editedHtmlStr = [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
        
        
        [sender setImage: [UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        self.submitBtn.enabled = YES;
        NSLog(@"checked");
        
        
        //[self performSomeAction:sender];
    }
    else
    {
        self.buttonCurrentStatus = NO;
        self.submitBtn.enabled = NO;
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontFamily =\"Courier New\""];
        //        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontSize =\"30\""];
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.fontFamily =\"Courier New\""];
        //        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[1].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].style.fontSize =\"30\""];
        
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontFamily =\"Courier New\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[2].style.fontSize =\"20\""];
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontFamily =\"Courier New\""];
        //        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[4].style.fontSize =\"30\""];
        
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.color =\"Dark Gray\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontFamily =\"Courier New\""];
        //        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontWeight =\"always * forever\""];
        [self.htmlWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[3].style.fontSize =\"30\""];
        
        
        self.submitBtn.backgroundColor = [UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:0.5];
        [sender setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        NSLog(@"unchecked");
        //[self performSomeAction:sender];
    }
}

@end
