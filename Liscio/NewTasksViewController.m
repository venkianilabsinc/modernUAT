//
//  NewTasksViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 26/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "NewTasksViewController.h"
#import "SettingsViewController.h"
#import "PortfolioHttpClient.h"
#import "OpenTasksViewController.h"
#import "NewTaskTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "NewTaskCollectionViewCell.h"
#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface NewTasksViewController ()<UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
#define IS_IPHONE_5 (IS_IPHONE && DEVICE_HEIGHT == 568.0) ? YES : NO
#define IS_IPHONE_6 (IS_IPHONE && DEVICE_HEIGHT == 667.0) ? YES : NO
#define IS_IPHONE_6P (IS_IPHONE && DEVICE_HEIGHT == 736.0) ? YES : NO

#define isiPhone5Device (DEVICE_HEIGHT == 568) ? YES : NO
@property CGFloat shiftForKeyboard;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;

@property (weak, nonatomic) IBOutlet UIButton *firstNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastNameBtn;

@property (strong, nonatomic) IBOutlet UIButton *dropDwownBtn;
@property (weak, nonatomic) IBOutlet UITextField *taskTitleTxtFld;
@property (weak, nonatomic) IBOutlet UITextView *commentsTxtView;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLbl;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLbl1;
@property (weak, nonatomic) IBOutlet UILabel *dropDownLbl2;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrolView;

@property (weak, nonatomic) IBOutlet UIButton *typeChangeBtnDropDown;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtnDropDown;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *calenderLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *contactListArray;
@property (strong, nonatomic) NSMutableArray *contactList1Array;
@property (strong, nonatomic) NSMutableArray *arrData;
//@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

//@property (weak, nonatomic) IBOutlet UIDatePicker *dpDatePicker;

@property (strong, nonatomic) NSMutableDictionary *Dict;
@property (strong, nonatomic) NSMutableDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *ownerLbl;
@property (assign, nonatomic) BOOL isFromFirstName;


@property (weak, nonatomic) IBOutlet UITextField *birthdayDate;
@property (strong, nonatomic) UIDatePicker *datepicker;

@property (weak, nonatomic)    NSString *myStr;
@property (weak, nonatomic)    NSString *myStrOne;

@property (strong, nonatomic) NSString *taskTypeStrinmg;

-(void)rel;

@property (weak, nonatomic) IBOutlet UIButton *attachementBtn;
@property (weak, nonatomic) IBOutlet UIButton *attachementTxtBtn;

@property (weak, nonatomic) IBOutlet UITableView *attachmentsTableView;
@property (strong, nonatomic) NSMutableArray *attachmentsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *attachedImgCollectionView;
@end

@implementation NewTasksViewController

- (void)viewDidLoad {
    
    self.isFromFirstName = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.attachmentsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    self.Dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.navigationController.navigationBarHidden = YES;
    
    self.datepicker = [[UIDatePicker alloc] init];
    self.datepicker.datePickerMode = UIDatePickerModeDate;
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    tapBackground.delegate = self;
    [self.view addGestureRecognizer:tapBackground];
    
    
    [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
    
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,10, self.view.frame.size.width,44)];
    toolbar.barStyle =UIBarStyleDefault;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                 target:self
                                                                                 action:@selector(cancelButtonPressed:)];
    
    UIBarButtonItem *flexibleSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doneButtonPressed:)];
    
    [toolbar setItems:@[cancelButton,flexibleSpace, doneButton]];
    
    self.birthdayDate.inputView = self.datepicker;
    self.birthdayDate.inputAccessoryView = toolbar;
    
    [self.attachementBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    [self.attachementBtn setTitle:[NSString stringWithUTF8String:"\uE92E"] forState:UIControlStateNormal];
    
    self.attachementBtn.layer.borderWidth = 1;
    self.attachementBtn.layer.borderColor = [[UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:1.0] CGColor];
    self.attachementBtn.layer.cornerRadius = self.attachementBtn.frame.size.height/2;
    self.attachementBtn.layer.masksToBounds = YES;
    
    
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\uE626"] forState:UIControlStateNormal];
    
    [self.calenderLbl setFont:[UIFont fontWithName:@"icomoon" size:18]];
    [self.calenderLbl setText:[NSString stringWithUTF8String:"\uE93E"]];
    
    [self.dropDownLbl setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.dropDownLbl setText:[NSString stringWithUTF8String:"\uE753"]];
    
    [self.dropDownLbl1 setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.dropDownLbl1 setText:[NSString stringWithUTF8String:"\uE753"]];
    
    [self.dropDownLbl2 setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.dropDownLbl2 setText:[NSString stringWithUTF8String:"\uE753"]];
    
    
    self.firstName.layer.cornerRadius = self.firstName.frame.size.height/2;
    self.firstName.layer.masksToBounds = YES;
    
    self.lastName.layer.cornerRadius = self.lastName.frame.size.height/2;
    self.lastName.layer.masksToBounds = YES;
    
    self.dropDwownBtn.layer.cornerRadius = 4;
    self.dropDwownBtn.layer.borderWidth = 1;
    self.dropDwownBtn.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.dropDwownBtn.layer.masksToBounds = YES;
    
    self.taskTitleTxtFld.layer.borderWidth = 1;
    self.taskTitleTxtFld.layer.cornerRadius = 2;
    self.taskTitleTxtFld.layer.borderColor =[[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.taskTitleTxtFld.layer.masksToBounds = YES;
    
    self.commentsTxtView.layer.borderWidth = 1;
    self.commentsTxtView.layer.cornerRadius = 2;
    self.commentsTxtView.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.commentsTxtView.layer.masksToBounds = YES;
    
    self.typeChangeBtnDropDown.layer.cornerRadius = 4;
    self.typeChangeBtnDropDown.layer.borderWidth = 1;
    self.typeChangeBtnDropDown.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.typeChangeBtnDropDown.layer.masksToBounds = YES;
    
    self.modifyBtnDropDown.layer.cornerRadius = 4;
    self.modifyBtnDropDown.layer.borderWidth = 1;
    self.modifyBtnDropDown.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.modifyBtnDropDown.layer.masksToBounds = YES;
    
    self.firstNameBtn.layer.cornerRadius = 4;
    self.firstNameBtn.layer.borderWidth = 1;
    self.firstNameBtn.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.firstNameBtn.layer.masksToBounds = YES;
    
    self.lastNameBtn.layer.cornerRadius = 4;
    self.lastNameBtn.layer.borderWidth = 1;
    self.lastNameBtn.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.lastNameBtn.layer.masksToBounds = YES;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.taskTitleTxtFld.leftView = paddingView;
    self.taskTitleTxtFld.leftViewMode = UITextFieldViewModeAlways;
    
    [self.dropDwownBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.typeChangeBtnDropDown setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.modifyBtnDropDown setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [self.firstNameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.lastNameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    self.contactListArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.contactList1Array = [[NSMutableArray alloc] initWithCapacity:0];
    self.arrData = [NSMutableArray new];
    
    
    self.attachmentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([[UIScreen mainScreen] bounds].size.width == 320)
    {
        //        NSLog(@"iphone 5");
        self.firstNameBtn.frame = CGRectMake(self.firstNameBtn.frame.origin.x, self.firstNameBtn.frame.origin.y,self.view.frame.size.width - 65, self.firstNameBtn.frame.size.height);
        [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];

    }else if ([[UIScreen mainScreen] bounds].size.width == 375)
    {
        [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];

    }else{
        [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
    }

    
    
    
    
}
-(void) dismissKeyboard:(id)sender
{
    [self.commentsTxtView resignFirstResponder];
    
    [self.view endEditing:YES];
}



//-(IBAction)datePicker:(UIButton *)sender
//{
//    [self.taskTitleTxtFld resignFirstResponder];
//    [self.commentsTxtView resignFirstResponder];
//
//
//
//    self.dpDatePicker.hidden = NO;
//    self.dpDatePicker.datePickerMode = UIDatePickerModeDate;
//    [self.dpDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
//    self.dpDatePicker.timeZone = [NSTimeZone defaultTimeZone];
//    self.dpDatePicker.minuteInterval = 5;
//
//
//
//    [self.view addSubview:self.dpDatePicker];
//
//
//
//}
//
//-(void)changeDateFromLabel:(id)sender
//{
//    self.dpDatePicker.hidden = YES;
//}
//
//- (void)datePickerValueChanged:(id)sender {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/yy"];
//    self.dateLbl.text = [dateFormatter stringFromDate:self.dpDatePicker.date];
//    self.dpDatePicker.hidden = YES;
//}

- (void)viewDidUnload {
    //    [btnSelect release];
    self.dropDwownBtn = nil;
    [self setDropDwownBtn:nil];
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    self.birthdayDate.text = dateString;
    
    [self.dropDwownBtn setTitle:@"Select a Task" forState:UIControlStateNormal];
    
    [self homeAPI];
    [self getCPAAPI];
    [self getContactsAPI];
    [self getIntialTaskData];
    
    if ([[UIScreen mainScreen] bounds].size.width == 320)
    {
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, 300, self.taskTitleTxtFld.frame.size.height);
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, 300, self.commentsTxtView.frame.size.height);
        self.dropDwownBtn.frame = CGRectMake(self.dropDwownBtn.frame.origin.x, self.dropDwownBtn.frame.origin.y, 300, self.dropDwownBtn.frame.size.height);
        self.typeChangeBtnDropDown.frame = CGRectMake(self.typeChangeBtnDropDown.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, 300, self.typeChangeBtnDropDown.frame.size.height);
        
        self.modifyBtnDropDown.frame = CGRectMake(self.modifyBtnDropDown.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, 300, self.modifyBtnDropDown.frame.size.height);
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, 300, self.attachmentsTableView.frame.size.height);
        
        
        self.dropDownLbl.frame = CGRectMake(260, self.dropDwownBtn.frame.origin.y, self.dropDownLbl1.frame.size.width, self.dropDownLbl1.frame.size.height);
        
    }
    

    
    [self.attachmentsArray removeAllObjects];
    
    [self.attachmentsTableView reloadData];

    
}

-(void) getIntialTaskData
{
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    
    //    NSDictionary *params1 = @{@"authorization" : [[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"]};
    
    [sharedObject getInitialTaskData:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         //         self.contactListArray = (NSMutableArray *)responseObject;
         //
         //
         //         for (int i =0; i < [self.contactListArray count]; i++)
         //         {
         //             self.arrData = [self.contactListArray valueForKey:@"label"];
         //             self.contactList1Array = [[self.contactListArray valueForKey:@"label"] objectAtIndex:i];
         //
         //         }
         //
         //         NSLog(@"%@", self.arrData);
         
         
     }
                             failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
     }];
    
}
-(void) getContactsAPI
{
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    
    //    NSDictionary *params1 = @{@"authorization" : [[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"]};
    
    [sharedObject get_emp_and_contact:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         self.contactListArray = (NSMutableArray *)responseObject;
         
         
         for (int i =0; i < [self.contactListArray count]; i++)
         {
             self.arrData = [self.contactListArray valueForKey:@"label"];
             self.contactList1Array = [[self.contactListArray valueForKey:@"label"] objectAtIndex:i];
             
         }
         
         //         NSLog(@"%@", self.arrData);
         
         
     }
                              failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
     }];
    
}

- (void)cancelButtonPressed:(id)sender
{
    [self.view endEditing:YES];
}

- (void)doneButtonPressed:(id)sender
{
    NSDate *birthdayDate = self.datepicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *birthdayText = [dateFormatter stringFromDate:birthdayDate];
    self.birthdayDate.text = birthdayText;
    
    [self.view endEditing:YES];
    
    
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
             //             NSLog(@"My responseObject \n%@", responseObject);
             
             self.dataDic = responseObject[@"data"];
             
             //             NSLog(@"dataDict is.... \n%@", self.dataDic);
             
             self.ownerLbl.text = [NSString stringWithFormat:@"Owner: %@", [self.dataDic objectForKey:@"uname"]];
             
             
         }
     }
               failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
         
     }];
}

-(void) getCPAAPI
{
    [self.activityIndicator startAnimating];
    __block PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    
    //    NSDictionary *params1 = @{@"authorization" : [[NSUserDefaults standardUserDefaults] stringForKey:@"auth_token"]};
    
    [sharedObject get_cpa_preference_type:nil success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         if([responseObject[@"success"] boolValue] == 1)
         {
             //             NSLog(@"My responseObject \n%@", responseObject);
             
         }
     }
                                  failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"error is \n%@", error.description);
     }];
}

- (IBAction)sendBtnPressed:(UIButton *)sender
{
    if ([self.taskTitleTxtFld.text isEqualToString:@""] || [self.birthdayDate.text isEqualToString:@""] || [self.dropDwownBtn.titleLabel.text isEqualToString:@""] || [self.dropDwownBtn.titleLabel.text isEqualToString:@"Select a Task"] || [self.firstNameBtn.titleLabel.text isEqualToString:@""] || [self.firstNameBtn.titleLabel.text isEqualToString:@"Select Employee"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Please fill Date, Task & Employee" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    sender.enabled = NO;
    
    //Demographics", @"Pay", @"Withholding
    if ([self.modifyBtnDropDown.titleLabel.text isEqualToString:@""] || self.modifyBtnDropDown.titleLabel.text == nil || [self.modifyBtnDropDown.titleLabel.text isEqual:[NSNull null]] )
    {
        self.myStr = @"";
    }
    //Add Employee", @"Modify Employee", @"Terminate Employee
    if ([self.typeChangeBtnDropDown.titleLabel.text isEqualToString:@""] || self.typeChangeBtnDropDown.titleLabel.text == nil || [self.typeChangeBtnDropDown.titleLabel.text isEqual:[NSNull null]])
    {
        self.myStrOne = @"";
    }
    
    //    NSLog(@"payroll_change_type\n %@", self.myStrOne);
    //    NSLog(@"emp_modification_type \n%@", self.myStr);
    
    [self.activityIndicator startAnimating];
    NSDictionary *params1;
    if ([self.self.dropDwownBtn.titleLabel.text isEqualToString:@"Make Payroll Change"])
    {
        params1 = @{@"cpa_id" : self.Dict[@"cpa_id"],
                    @"subject" : self.taskTitleTxtFld.text,
                    @"for_account" : self.Dict[@"id"],
                    @"assigned_to_user" : self.Dict[@"value"],
                    @"due_by" : self.birthdayDate.text,
                    @"assigne_type" : self.Dict[@"assigne_type"],
                    @"description" : self.commentsTxtView.text,
                    @"task_type_key" : @"payroll_change",
                    @"task_type_value" : self.dropDwownBtn.titleLabel.text,
                    @"emp_modification_type" : self.myStr,//pay,demographs
                    @"payroll_change_type" : self.myStrOne};//modify, add,
    }else{
        params1 = @{@"cpa_id" : self.Dict[@"cpa_id"],
                    @"subject" : self.taskTitleTxtFld.text,
                    @"for_account" : self.Dict[@"id"],
                    @"assigned_to_user" : self.Dict[@"value"],
                    @"due_by" : self.birthdayDate.text,
                    @"assigne_type" : self.Dict[@"assigne_type"],
                    @"description" : self.commentsTxtView.text,
                    @"task_type_key" : self.taskTypeStrinmg,
                    @"task_type_value" : self.dropDwownBtn.titleLabel.text};
    }
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    //    NSLog(@"ammu %@", self.Dict);
    [sharedObject creatingATasks:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         sender.enabled = YES;
         
         if([responseObject[@"success"] boolValue] == 1)
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 [self.taskTitleTxtFld resignFirstResponder];
                 [self.commentsTxtView resignFirstResponder];
                 self.taskTitleTxtFld.text = @"";
                 self.commentsTxtView.text = @"Comments";
                 
                 //                 self.firstNameBtn.titleLabel.text = @"Select Employee";
                 
                 [self.firstNameBtn setTitle:@"Select Employee" forState:UIControlStateNormal];
                 self.birthdayDate.text = @"";
                 self.firstName.text = @"";
                 
                 [self.navigationController.tabBarController setSelectedIndex:1];
                 //                 OpenTasksViewController *openVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OpenTasksViewController"];
                 //                 [self.navigationController pushViewController:openVC animated:YES];
                 //
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];
             
             
             //             NSLog(@"My responseObject \n%@", responseObject);
             
             
         }
         else
         {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
         sender.enabled = YES;
     }];
}



- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    [self.birthdayDate resignFirstResponder];

    
    
    if ([sender.venkistr isEqualToString:@"Make Payroll Change"])
    {
        self.typeChangeBtnDropDown.hidden = NO;
        self.dropDownLbl1.hidden = NO;
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.typeChangeBtnDropDown.frame = CGRectMake(self.typeChangeBtnDropDown.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.typeChangeBtnDropDown.frame.size.width, self.typeChangeBtnDropDown.frame.size.height);
        self.dropDownLbl1.frame = CGRectMake(301, self.typeChangeBtnDropDown.frame.origin.y, self.dropDownLbl1.frame.size.width, self.dropDownLbl1.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            self.dropDownLbl1.frame = CGRectMake(260, self.typeChangeBtnDropDown.frame.origin.y, self.dropDownLbl1.frame.size.width, self.dropDownLbl1.frame.size.height);
        }
        
        
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        self.attachementTxtBtn.frame = CGRectMake(CGRectGetMaxX(self.attachementBtn.frame) + 3, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementTxtBtn.frame.size.width, self.attachementTxtBtn.frame.size.height);
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        
//        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            //        NSLog(@"iphone 5");
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
            
        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        {
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
            
        }else{
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        }

        
    }
    else if ([sender.venkistr isEqualToString:@"Send a Document"])
    {
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.typeChangeBtnDropDown.hidden = YES;
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        self.attachementTxtBtn.frame = CGRectMake(CGRectGetMaxX(self.attachementBtn.frame) + 3, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementTxtBtn.frame.size.width, self.attachementTxtBtn.frame.size.height);
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
//        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            //        NSLog(@"iphone 5");
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
            
        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        {
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
            
        }else{
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        }

    }
    else if([sender.venkistr isEqualToString:@"Send a Message"])
    {
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.modifyBtnDropDown.hidden = YES;
        
        self.typeChangeBtnDropDown.hidden = YES;
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        self.attachementTxtBtn.frame = CGRectMake(CGRectGetMaxX(self.attachementBtn.frame) + 3, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementTxtBtn.frame.size.width, self.attachementTxtBtn.frame.size.height);
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
//        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            //        NSLog(@"iphone 5");
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
            
        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        {
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
            
        }else{
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        }

        //        self.taskTitleTxtFld.text = ;
        
        
    }
    else if ([sender.venkistr isEqualToString:@"Request a Meeting"])
    {
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        
        self.modifyBtnDropDown.hidden = YES;
        
        self.typeChangeBtnDropDown.hidden = YES;
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        self.attachementTxtBtn.frame = CGRectMake(CGRectGetMaxX(self.attachementBtn.frame) + 3, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementTxtBtn.frame.size.width, self.attachementTxtBtn.frame.size.height);
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
//        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            //        NSLog(@"iphone 5");
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
            
        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        {
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
            
        }else{
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        }

        
    }
    else if ([sender.venkistr isEqualToString:@"Modify Employee"])
    {
        self.modifyBtnDropDown.hidden = NO;
        self.dropDownLbl2.hidden= NO;
        
        self.modifyBtnDropDown.frame = CGRectMake(self.modifyBtnDropDown.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.modifyBtnDropDown.frame.size.width, self.modifyBtnDropDown.frame.size.height);
        
        self.dropDownLbl2.frame = CGRectMake(301, self.modifyBtnDropDown.frame.origin.y, self.dropDownLbl2.frame.size.width, self.dropDownLbl2.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            self.dropDownLbl2.frame = CGRectMake(260, self.modifyBtnDropDown.frame.origin.y, self.dropDownLbl2.frame.size.width, self.dropDownLbl2.frame.size.height);
        }
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.modifyBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachementTxtBtn.frame = CGRectMake(CGRectGetMaxX(self.attachementBtn.frame) + 3, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementTxtBtn.frame.size.width, self.attachementTxtBtn.frame.size.height);
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
//        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            //        NSLog(@"iphone 5");
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
            
        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        {
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
            
        }else if ([[UIScreen mainScreen] bounds].size.width == 414)
        {
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 750)];
            
        }else{
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
        }

        
    }
    else if ([sender.venkistr isEqualToString:@"Add Employee"])
    {
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        self.attachementTxtBtn.frame = CGRectMake(CGRectGetMaxX(self.attachementBtn.frame) + 3, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementTxtBtn.frame.size.width, self.attachementTxtBtn.frame.size.height);
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
//        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            //        NSLog(@"iphone 5");
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
            
        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        {
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
            
        }else{
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
        }

        
        
    }
    else if ([sender.venkistr isEqualToString:@"Terminate Employee"])
    {
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        self.attachementTxtBtn.frame = CGRectMake(CGRectGetMaxX(self.attachementBtn.frame) + 3, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementTxtBtn.frame.size.width, self.attachementTxtBtn.frame.size.height);
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        
//        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            //        NSLog(@"iphone 5");
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
            
        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        {
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
            
        }else{
            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
        }

        
    }
    
    
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [sender.venkistr  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
        }
    }
    
    if (self.isFromFirstName == YES) {
        
        self.firstName.text = firstCharacters;
        self.lastName.text = [sender.venkistr substringToIndex:2];
        self.Dict = sender.venkiDict;
        //        NSLog(@"hellooooo%@", self.Dict);
        
        
    }
    else{
        
        //        self.firstName.text = @"";
        //        self.lastName.text = @"";
        
    }
    
    if ([sender.venkistr isEqualToString:@"Send a Message"])
    {
        self.taskTypeStrinmg = @"send_message";
        
        self.taskTitleTxtFld.text = [NSString stringWithFormat:@"Message for %@", self.firstNameBtn.titleLabel.text];
    }
    else if ([sender.venkistr isEqualToString:@"Send a Document"])
    {
        self.taskTypeStrinmg = @"send_document";
        
        self.taskTitleTxtFld.text = [NSString stringWithFormat:@"Send a Document to %@", self.firstNameBtn.titleLabel.text];
    }
    else if ([sender.venkistr isEqualToString:@"Request a Meeting"])
    {
        self.taskTypeStrinmg = @"request_meeting";
        
        self.taskTitleTxtFld.text = [NSString stringWithFormat:@"Request a Meeting with %@", self.firstNameBtn.titleLabel.text];
    }
    
    else if([sender.venkistr isEqualToString:@"Make Payroll Change"])
    {
        self.taskTypeStrinmg = @"payroll_change";
        
        self.taskTitleTxtFld.text = @"Request Payroll Change";
        [self.typeChangeBtnDropDown setTitle:@"Type of Change" forState:UIControlStateNormal];
        
    }
    
    
    //    NSLog(@"%@", sender.venkistr);
    if ([sender.venkistr isEqualToString:@"Modify Employee"])
    {
        self.myStrOne = sender.venkistr;
        [self.modifyBtnDropDown setTitle:@"Type of Modification" forState:UIControlStateNormal];
        
    }
    if ([sender.venkistr isEqualToString:@"Add Employee"])
    {
        self.myStrOne = sender.venkistr;
        self.taskTitleTxtFld.text = @"Payroll Change - Add Employee";
    }
    if ([sender.venkistr isEqualToString:@"Terminate Employee"])
    {
        self.myStrOne = sender.venkistr;
        self.taskTitleTxtFld.text = @"Payroll Change - Terminate Employee";
    }
    
    if ([sender.venkistr isEqualToString:@"Demographics"])
    {
        self.myStr = sender.venkistr;
        self.taskTitleTxtFld.text = @"Modify Employee's Payroll - Demographics";
    }
    if ([sender.venkistr isEqualToString:@"Pay"])
    {
        self.myStr = sender.venkistr;
        self.taskTitleTxtFld.text = @"Modify Employee's Payroll - Pay";
    }
    if ([sender.venkistr isEqualToString:@"Withholding"])
    {
        self.myStr = sender.venkistr;
        self.taskTitleTxtFld.text = @"Modify Employee's Payroll - Witholdings";
        
    }
    
    [self rel];
    
    
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (IBAction)dropDwnBtnClicked:(UIButton *)sender;
{
    [self.birthdayDate resignFirstResponder];

    self.isFromFirstName = NO;
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Request a Meeting", @"Send a Message", @"Make Payroll Change", @"Send a Document",nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
}

- (IBAction)typeChangeBtnClicked:(UIButton *)sender;
{
    [self.birthdayDate resignFirstResponder];

    self.isFromFirstName =NO;
    
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Add Employee", @"Modify Employee", @"Terminate Employee",nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
}

- (IBAction)modifyBtnClicked:(UIButton *)sender;
{
    [self.birthdayDate resignFirstResponder];

    self.isFromFirstName =NO;
    
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Demographics", @"Pay", @"Withholding",nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
}


- (IBAction)firstNameBtnClicked:(UIButton *)sender;
{
    [self.birthdayDate resignFirstResponder];

    [self.taskTitleTxtFld resignFirstResponder];
    [self.commentsTxtView resignFirstResponder];
    
    self.isFromFirstName =YES;
    
    [self.dropDwownBtn setTitle:@"Select a Task" forState:UIControlStateNormal];
    self.taskTitleTxtFld.text = @"";
    //    self.taskTitleTxtFld.placeholder = @"Task Title";
    //    NSArray * arr = [[NSArray alloc] init];
    //    arr = [NSArray arrayWithObjects:@"sekhar", @"anil", @"kinjal",nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.arrData :self.contactListArray :@"down"];
        dropDown.delegate = self;
        
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)secondNameBtnClicked:(UIButton *)sender;
{
    self.isFromFirstName =YES;
    
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"venki", @"sandeep", @"srikanth",nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)settingsBtnClicked:(id)sender
{
    [self.birthdayDate resignFirstResponder];

    SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [self.taskTitleTxtFld resignFirstResponder];
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //    if([text isEqualToString:@"\n"]) {
    //
    //        if(textView.text.length == 0){
    //            textView.textColor = [UIColor lightGrayColor];
    //            textView.text = @"Comments";
    //        }
    //        [textView resignFirstResponder];
    //        return NO;
    //    }
    if (range.length == 1) {
        if ([text isEqualToString:@"\n"]) {
            textView.text = [NSString stringWithFormat:@"%@\n\t",textView.text];
            return NO;
        }
    }
    
    return YES;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"comments"])
    {
        textView.text = @"";
        
    }
    if ([textView.text isEqualToString: @"Comments"])
    {
        textView.text = @"";
        
    }
    
    //    textView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    //    if(textView.text.length == 0){
    //        textView.textColor = [UIColor lightGrayColor];
    //        textView.text = @"Comments";
    //        [textView resignFirstResponder];
    //    }
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Comments";
        //        [textView resignFirstResponder];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    CGRect textViewRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    if (bottomEdge >= 260) {//250
        CGRect viewFrame = self.view.frame;
        self.shiftForKeyboard = bottomEdge - 280;
        if(!isiPhone5Device)
        {
            self.shiftForKeyboard = bottomEdge - 330;
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

- (void)textViewDidEndEditing:(UITextView *)textView;
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

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:dropDown]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    if ([touch.view isDescendantOfView:self.attachmentsTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }

    return YES;
}


-(IBAction)uploadimage:(UIButton *)sender
{
    [self.birthdayDate resignFirstResponder];

    self.attachmentsTableView.hidden = NO;
    
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
                                                              
                                                              //                                                              NSLog(@"You pressed button one");
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Choose from Existing"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               //                                                               NSLog(@"You pressed button two");
                                                               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                               picker.delegate = self;
                                                               picker.allowsEditing = YES;
                                                               picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                               
                                                               [self presentViewController:picker animated:YES completion:NULL];
                                                               
                                                               
                                                           }];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                              //                                                               NSLog(@"You pressed button two");
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
    NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    //    NSString *jsonString = [[NSString alloc] initWithData:data
    //                                                 encoding:NSUTF8StringEncoding];
    
    if([base64 isEqual:[NSNull null]]||[base64 isEqualToString:@""]||([base64 length]<=0))
    {
        base64 =@"";
        
    }else{
        
    }
    //    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init]; [format setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *imageName = [NSString stringWithFormat:@"Image_%@.jpg", [format stringFromDate:now]];
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://liscioapistage.herokuapp.com/api/v1/documents"];  // enter your url to upload
    //    [sharedObject uploadImage:params1 selectImage:data success:^(NSDictionary *responseObject)
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    NSDictionary *params1 = @{@"task_id" : @"",
                              @"aws_url" : base64,
                              @"file_name" : imageName};
    [sharedObject uploadImgeFromMobile:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         //         NSLog(@"My responseObject \n%@", responseObject);
         
         [self.attachmentsArray addObject:responseObject[@"data"]];
         
         
         //         self.attachmentsArray = responseObject[@"data"];
         
         
         
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
             //enter code here
             
             
             
             
             [self.attachmentsTableView reloadData];
             
         }];
         [alert addAction:defaultAction];
         //Present action where needed
         [self presentViewController:alert animated:YES completion:nil];
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attachmentsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"commentsCellID";
    NewTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (self.attachmentsArray.count)
    {
        [cell.attamentImgLbl setFont:[UIFont fontWithName:@"icomoon" size:18]];
        [cell.attamentImgLbl setText:[NSString stringWithUTF8String:"\uE688"]];
        
    }else{
        
    }
    
    //    NSString *myStr = [[self.attachmentsArray valueForKey:@"new_comment"] objectAtIndex:indexPath.row];
    NSString *myStr5 = [[self.attachmentsArray valueForKey:@"file_name"] objectAtIndex:indexPath.row];
    
    cell.titleLbl.text = myStr5;
    

    
    NSString *urlStr = [NSString stringWithFormat:@"https:%@", [[self.attachmentsArray valueForKey:@"aws_url"] objectAtIndex:indexPath.row]];
    NSURL *imageURL = [NSURL URLWithString:urlStr];
    //NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    //UIImage *image = [UIImage imageWithData:imageData];

    [cell.thumbImgView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ThumbPlaceHolder.png"]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSURL *url = [NSURL URLWithString:[[self.myArray valueForKey:@"aws_url"] objectAtIndex:indexPath.row]];
    NSString *newStr = [NSString stringWithFormat:@"https:%@", [[self.attachmentsArray valueForKey:@"aws_url_origional"] objectAtIndex:indexPath.row]];
    
    if (newStr == nil || [newStr isEqual:[NSNull null]] || [newStr isEqualToString:@""])
    {
        return;
    }
    NSURL *url = [NSURL URLWithString:newStr];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
    }else{
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:url];
    }
    
    
    //    [[UIApplication sharedApplication] openURL:url];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    NSMutableDictionary *dict = [self.attachmentsArray objectAtIndex:indexPath.row];
    NSString *mystr1  = dict[@"aws_url"];
    
    if (mystr1 == nil || [mystr1 isEqual:[NSNull null]] || [mystr1 isEqualToString:@""])
    {
        //        [self.commentsTableView reloadData];
        return NO;
    }
    
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.attachmentsArray objectAtIndex:indexPath.row];
    NSString *mystr1  = dict[@"aws_url_origional"];
    if (mystr1 == nil || [mystr1 isEqual:[NSNull null]] || [mystr1 isEqualToString:@""])
    {
        [self.attachmentsTableView reloadData];
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //add code here for when you hit delete
        NSMutableDictionary *dict = [self.attachmentsArray objectAtIndex:indexPath.row];
        NSString *mystr  = [dict[@"id"] stringValue];
        [self.activityIndicator startAnimating];
        
        if (mystr == nil || [mystr isEqual:[NSNull null]] || [mystr isEqualToString:@""])
        {
            mystr= @"";
            return;
        }
        
        PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
        NSDictionary *params1 = @{@"task_id" : @"",
                                  @"id" : mystr};
        [sharedObject deletingImgeFromMobile:params1 success:^(NSDictionary *responseObject)
         {
             [self.activityIndicator stopAnimating];
             //             NSLog(@"My responseObject \n%@", responseObject);
             
             if ([responseObject[@"status"] integerValue] == 200)
             {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here

                     [self.attachmentsArray removeObjectAtIndex:indexPath.row];
                     [self.attachmentsTableView reloadData];

                     
                 }];
                 [alert addAction:defaultAction];
                 //Present action where needed
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }else{
                 
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
                     //                     [self TaskDetailAPI];
                 }];
                 [alert addAction:defaultAction];
                 //Present action where needed
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [self.activityIndicator stopAnimating];
         }];
    }
}

#pragma mark UICollectionViewDataSource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.attachmentsArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CollectionCell";
    NewTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.delBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:15]];
    [cell.delBtn setTitle:[NSString stringWithUTF8String:"\uE815"] forState:UIControlStateNormal];

    cell.thumbImageView.layer.borderWidth = 1;
    cell.thumbImageView.layer.borderColor = [[UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:1.0] CGColor];
   // cell.thumbImageView.layer.cornerRadius = cell.thumbImageView.frame.size.height/2;
    //cell.thumbImageView.layer.masksToBounds = YES;
    
    
    NSString *urlStr = [NSString stringWithFormat:@"https:%@", [[self.attachmentsArray valueForKey:@"aws_url"] objectAtIndex:indexPath.row]];
    NSURL *imageURL = [NSURL URLWithString:urlStr];
    //NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    
    //UIImage *image = [UIImage imageWithData:imageData];
    
    [cell.thumbImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ThumbPlaceHolder.png"]];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(IBAction)delBtnPressed:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.attachedImgCollectionView indexPathForCell:(UICollectionViewCell *)sender.superview.superview];
    
    NSMutableDictionary *dict = [self.attachmentsArray objectAtIndex:indexPath.row];
    NSString *mystr1  = dict[@"aws_url_origional"];
    if (mystr1 == nil || [mystr1 isEqual:[NSNull null]] || [mystr1 isEqualToString:@""])
    {
        [self.attachmentsTableView reloadData];
        [self.attachedImgCollectionView reloadData];
        return;
    }

    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    NSDictionary *params1 = @{@"task_id" : @"",
                              @"id" : mystr1};
    [sharedObject deletingImgeFromMobile:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         //             NSLog(@"My responseObject \n%@", responseObject);
         
         if ([responseObject[@"status"] integerValue] == 200)
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 [self.attachmentsArray removeObjectAtIndex:indexPath.row];
                 [self.attachmentsTableView reloadData];
                 [self.attachedImgCollectionView reloadData];
                 
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];
             
         }else{
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 //                     [self TaskDetailAPI];
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];
             
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];

    
    
    
    NSLog(@"%ld",(long)indexPath.row);

}

@end
