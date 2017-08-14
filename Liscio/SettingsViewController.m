//
//  SettingsViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 26/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "SettingsViewController.h"
#import "TeamViewController.h"
#import "PortfolioHttpClient.h"
#import <UIImageView+AFNetworking.h>

#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface SettingsViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#define IS_IPHONE_5 (IS_IPHONE && DEVICE_HEIGHT == 568.0) ? YES : NO
#define IS_IPHONE_6 (IS_IPHONE && DEVICE_HEIGHT == 667.0) ? YES : NO
#define IS_IPHONE_6P (IS_IPHONE && DEVICE_HEIGHT == 736.0) ? YES : NO

#define isiPhone5Device (DEVICE_HEIGHT == 568) ? YES : NO

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *teamBtn;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTxtFld;
@property (strong, nonatomic) NSMutableDictionary *accountsDict;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property CGFloat shiftForKeyboard;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrolView;

@property (strong, nonatomic) NSString *base64;
@property (strong, nonatomic) IBOutlet UIView *customeHeaderView;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.accountsDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self.navigationController setNavigationBarHidden:YES];
    self.updateBtn.layer.masksToBounds = true;
    self.updateBtn.layer.cornerRadius = 15.0;
    
    if (isiPhone5Device)
    {
        [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        
    }
    
    //    [self.logoutBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    //    [self.logoutBtn setTitle:[NSString stringWithUTF8String:"\uE900"] forState:UIControlStateNormal];
    
    [self.editBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.editBtn setTitle:[NSString stringWithUTF8String:"\uEB92"] forState:UIControlStateNormal];
    
    [self.cameraBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.cameraBtn setTitle:[NSString stringWithUTF8String:"\uE6AE"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    self.editBtn.layer.borderWidth = 1;
    self.editBtn.layer.borderColor = [[UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:1.0] CGColor];
    self.editBtn.layer.cornerRadius = self.editBtn.frame.size.height/2;
    self.editBtn.layer.masksToBounds = YES;
    
    self.cameraBtn.layer.borderWidth = 1;
    self.cameraBtn.layer.borderColor = [[UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:1.0] CGColor];
    self.cameraBtn.layer.cornerRadius = self.cameraBtn.frame.size.height/2;
    self.cameraBtn.layer.masksToBounds = YES;
    
//    self.userImage.layer.borderWidth = 1;
//    self.userImage.layer.borderColor = [[UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:1.0] CGColor];
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;
    self.userImage.layer.masksToBounds = YES;
    
    self.teamBtn.hidden = YES;
    [self.firstNameTxtFld setEnabled:NO];
    [self.lastNameTxtFld setEnabled:NO];
    [self.emailTxtFld setEnabled:NO];
    [self.phoneNumberTxtFld setEnabled:NO];
    
    [self.backBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:20]];
    [self.backBtn setTitle:[NSString stringWithUTF8String:"\uE752"] forState:UIControlStateNormal];
    
    
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.backBtn.layer.cornerRadius = self.backBtn.frame.size.height/2;
    self.backBtn.layer.masksToBounds = YES;
    
    [self getAccountInfomation];
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}
-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) getAccountInfomation
{
    
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    //    NSDictionary *params1 = @{@"email" : self.emailTxtFld.text};
    
    [sharedObject getProfile:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         self.accountsDict = responseObject[@"data"];
         
         NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
         for (NSString * key in [self.accountsDict allKeys])
         {
             if (![[self.accountsDict objectForKey:key] isKindOfClass:[NSNull class]])
                 [prunedDictionary setObject:[self.accountsDict objectForKey:key] forKey:key];
         }
         
         if ([responseObject[@"status"] integerValue] == 200)
         {
             self.firstNameTxtFld.text = [prunedDictionary objectForKey:@"first_name"];
             self.lastNameTxtFld.text = [prunedDictionary objectForKey:@"last_name"];
             self.emailTxtFld.text = [prunedDictionary objectForKey:@"email"];
             self.phoneNumberTxtFld.text = [prunedDictionary objectForKey:@"phone"];
             
             if ([[prunedDictionary objectForKey:@"avatar"] isEqualToString:@""])
             {
                 self.userImage.image = [UIImage imageNamed:@"contact_placeholder.png"];
                 
             }else{
                 [self.activityIndicator startAnimating];
                 
                 NSString *urlStr = [NSString stringWithFormat:@"https:%@", prunedDictionary[@"avatar"]];
                 // NSURL *imageURL = [NSURL URLWithString:urlStr];
                 
                 [self.userImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]] placeholderImage:[UIImage imageNamed:@"contact_placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                     
                     self.userImage.image = image;
                     NSData* data = UIImageJPEGRepresentation(self.userImage.image, 1.0f);
                     self.base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                     
                     [self.activityIndicator stopAnimating];
                     
                     
                 } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                     
                 }];
                 //[self.userImage setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"contact_placeholder.png"]];
                 
                 
                 //    NSString *jsonString = [[NSString alloc] initWithData:data
                 //                                                 encoding:NSUTF8StringEncoding];
                 
                 
                 if([self.base64 isEqual:[NSNull null]]||[self.base64 isEqualToString:@""]||([self.base64 length]<=0))
                 {
                     self.base64 =@"";
                     
                 }else{
                     
                 }
             }
             
         }
     }
                     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
     }];
    
}

-(IBAction)logoutBtnPressed:(id)sender
{
    
    
    
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    NSDictionary *params1 = @{@"device_id" : [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"]};
    
    [sharedObject removeDevice:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
         
         
     }
    failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
     }];
    
    
    
//    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
    
    
    
    
    
    
    
    
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(IBAction)editBtnPressed:(id)sender
{
    self.teamBtn.hidden = NO;
    self.cameraBtn.hidden = NO;
    self.editBtn.hidden = YES;
    self.logoutBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
    self.titleLbl.text = @"Edit Profile";
    [self.firstNameTxtFld setEnabled:YES];
    [self.lastNameTxtFld setEnabled:YES];
    //    [self.emailTxtFld setEnabled:YES];
    [self.phoneNumberTxtFld setEnabled:YES];
    
    
    
}

-(IBAction)cancelBtnPressed:(id)sender
{
    self.editBtn.hidden = NO;
    self.teamBtn.hidden = YES;
    self.cameraBtn.hidden = YES;
    self.logoutBtn.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.titleLbl.text = @"Settings";
    [self.firstNameTxtFld setEnabled:NO];
    [self.lastNameTxtFld setEnabled:NO];
    [self.emailTxtFld setEnabled:NO];
    [self.phoneNumberTxtFld setEnabled:NO];
    
    
}
-(IBAction)cameraBtnPressed:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Take a Photo"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                              picker.delegate = self;
                                                                                                                            picker.allowsEditing = YES;
                                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              
                                                              [self presentViewController:picker animated:YES completion:NULL];
                                                              
                                                              NSLog(@"You pressed button one");
                                                          }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Choose from Existing"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed button two");
                                                               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                               picker.delegate = self;
                                                               picker.allowsEditing = YES;
                                                               picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                               
                                                               [self presentViewController:picker animated:YES completion:NULL];
                                                               
                                                               
                                                           }];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button two");
                                                          }];
    
    
    [alert addAction:firstAction];
    [alert addAction:secondAction];
    [alert addAction:thirdAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    //    self.resumeImg.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    NSData* data = UIImageJPEGRepresentation(chosenImage, 0.5f);
    self.base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    //    NSString *jsonString = [[NSString alloc] initWithData:data
    //                                                 encoding:NSUTF8StringEncoding];
    
    
    if([self.base64 isEqual:[NSNull null]]||[self.base64 isEqualToString:@""]||([self.base64 length]<=0))
    {
        self.base64 =@"";
        
    }else{
        
    }
    //    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init]; [format setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *imageName = [NSString stringWithFormat:@"Image_%@.jpg", [format stringFromDate:now]];
    
    self.userImage.image = chosenImage;
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


-(IBAction)updatePressed:(id)sender
{
    [self dismissKeyboard:self];
    
    if ([self.firstNameTxtFld.text isEqualToString:@""]|| [self.lastNameTxtFld.text isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please fill all the first and lastname" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //enter code here
            
        }];
        [alert addAction:defaultAction];
        //Present action where needed
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
        
    }
    
    if ([self.phoneNumberTxtFld.text isEqualToString:@""]) {
        
        self.phoneNumberTxtFld.text = @"";
    }
    if([self.base64 isEqual:[NSNull null]]||[self.base64 isEqualToString:@""]||([self.base64 length]<=0))
    {
        self.base64 = @"";
    }
    
    [self.teamBtn setEnabled:NO];
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    NSDictionary *params1 = @{@"first_name" : self.firstNameTxtFld.text,
                              @"last_name" : self.lastNameTxtFld.text,
                              @"phone" : self.phoneNumberTxtFld.text,
                              @"plateform":@"true",
                              @"avatar":self.base64};
    
    [sharedObject updateProfile:params1 success:^(NSDictionary *responseObject)
     {
         
         [self.activityIndicator stopAnimating];
         
         [self.teamBtn setEnabled:YES];

         if ([responseObject[@"status"] integerValue] == 200)
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 self.editBtn.hidden = NO;
                 self.teamBtn.hidden = YES;
                 self.cameraBtn.hidden = YES;
                 self.logoutBtn.hidden = NO;
                 self.cancelBtn.hidden = YES;
                 self.titleLbl.text = @"Settings";
                 [self.firstNameTxtFld setEnabled:NO];
                 [self.lastNameTxtFld setEnabled:NO];
                 [self.emailTxtFld setEnabled:NO];
                 [self.phoneNumberTxtFld setEnabled:NO];
                 
                 
                 [self getAccountInfomation];
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];
             
             
         }else{
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 //                 [self getAccountInfomation];
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];
             
         }
     }
    failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
         [self.teamBtn setEnabled:YES];

         [self.activityIndicator stopAnimating];
         self.editBtn.hidden = YES;
         self.teamBtn.hidden = NO;
         self.cameraBtn.hidden = NO;
         self.logoutBtn.hidden = YES;
         self.cancelBtn.hidden = NO;
         self.titleLbl.text = @"Edit Profile";
         [self.firstNameTxtFld setEnabled:YES];
         [self.lastNameTxtFld setEnabled:YES];
         //         [self.emailTxtFld setEnabled:YES];
         [self.phoneNumberTxtFld setEnabled:YES];
         NSLog(@"error is \n%@", error.description);
         
     }];
    
}

#pragma mark - UITextFieldDelegates

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [self.emailTxtFld resignFirstResponder];
    [self.firstNameTxtFld resignFirstResponder];
    [self.lastNameTxtFld resignFirstResponder];
    [self.phoneNumberTxtFld resignFirstResponder];
    
    return YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    if (bottomEdge >= 260) {//250
        CGRect viewFrame = self.myScrolView.frame;
        self.shiftForKeyboard = bottomEdge - 280;
        if(!isiPhone5Device)
        {
            self.shiftForKeyboard = bottomEdge - 375;
        }
        viewFrame.origin.y -= self.shiftForKeyboard;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [self.myScrolView setFrame:viewFrame];
        [UIView commitAnimations];
    }
    else
    {
        self.shiftForKeyboard = 0.0f;
    }
    
    [self.view addSubview:self.customeHeaderView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.myScrolView.frame;
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
        [self.myScrolView setFrame:viewFrame];
        // More animation code
        [UIView commitAnimations];
    }
}

//-(IBAction)teamBtnPressed:(id)sender
//{
//    TeamViewController *teamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamViewController"];
//    [self.navigationController pushViewController:teamVC animated:YES];
//}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
