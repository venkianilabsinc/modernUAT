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

#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface NewTasksViewController ()<UIGestureRecognizerDelegate>
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


-(void)rel;

@end

@implementation NewTasksViewController

- (void)viewDidLoad {
    
    self.isFromFirstName = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];

    self.Dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.navigationController.navigationBarHidden = YES;
    
    self.datepicker = [[UIDatePicker alloc] init];
    self.datepicker.datePickerMode = UIDatePickerModeDate;
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    tapBackground.delegate = self;
    [self.view addGestureRecognizer:tapBackground];
    

    
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
    [self homeAPI];
    [self getCPAAPI];
    [self getContactsAPI];
    


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
         
         NSLog(@"%@", self.arrData);

         
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
             NSLog(@"My responseObject \n%@", responseObject);
             
             self.dataDic = responseObject[@"data"];
             
             NSLog(@"dataDict is.... \n%@", self.dataDic);
             
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
             NSLog(@"My responseObject \n%@", responseObject);
             
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
    if ([self.taskTitleTxtFld.text isEqualToString:@""] || [self.birthdayDate.text isEqualToString:@""] || [self.dropDwownBtn.titleLabel.text isEqualToString:@""])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Please fill Date & Employee" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

    NSLog(@"payroll_change_type\n %@", self.myStrOne);
    NSLog(@"emp_modification_type \n%@", self.myStr);

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
                                  @"task_type_key" : self.dropDwownBtn.titleLabel.text,
                                  @"task_type_value" : self.dropDwownBtn.titleLabel.text};
    }
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    NSLog(@"ammu %@", self.Dict);
    [sharedObject creatingATasks:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         
         sender.enabled = YES;
         
         if([responseObject[@"success"] boolValue] == 1)
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
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


             NSLog(@"My responseObject \n%@", responseObject);
             

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
    

    
    if ([sender.venkistr isEqualToString:@"Make Payroll Change"])
    {
        self.typeChangeBtnDropDown.hidden = NO;
        self.dropDownLbl1.hidden = NO;
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;

        self.typeChangeBtnDropDown.frame = CGRectMake(self.typeChangeBtnDropDown.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.typeChangeBtnDropDown.frame.size.width, self.typeChangeBtnDropDown.frame.size.height);
        self.dropDownLbl1.frame = CGRectMake(321, self.typeChangeBtnDropDown.frame.origin.y, self.dropDownLbl1.frame.size.width, self.dropDownLbl1.frame.size.height);
        
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);

        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);

    }
    else if ([sender.venkistr isEqualToString:@"Send a Document"])
    {
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;

        self.typeChangeBtnDropDown.hidden = YES;

        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, 235, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, 285, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, 388, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);

        
    }
    else if([sender.venkistr isEqualToString:@"Send a Message"])
    {
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;

        self.modifyBtnDropDown.hidden = YES;

        self.typeChangeBtnDropDown.hidden = YES;
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, 235, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, 285, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, 388, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        
//        self.taskTitleTxtFld.text = ;

 
    }
    else if ([sender.venkistr isEqualToString:@"Request a Meeting"])
    {
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;


        self.modifyBtnDropDown.hidden = YES;

        self.typeChangeBtnDropDown.hidden = YES;
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, 235, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, 285, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, 388, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
    }
    else if ([sender.venkistr isEqualToString:@"Modify Employee"])
    {
        self.modifyBtnDropDown.hidden = NO;
        self.dropDownLbl2.hidden= NO;

        self.modifyBtnDropDown.frame = CGRectMake(self.modifyBtnDropDown.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.modifyBtnDropDown.frame.size.width, self.modifyBtnDropDown.frame.size.height);

        self.dropDownLbl2.frame = CGRectMake(321, self.modifyBtnDropDown.frame.origin.y, self.dropDownLbl2.frame.size.width, self.dropDownLbl2.frame.size.height);
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.modifyBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
    }
    else if ([sender.venkistr isEqualToString:@"Add Employee"])
    {
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;

        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        
        
    }
    else if ([sender.venkistr isEqualToString:@"Terminate Employee"])
    {
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;

        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        
        
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
        NSLog(@"hellooooo%@", self.Dict);


    }
    else{
        
//        self.firstName.text = @"";
//        self.lastName.text = @"";

    }
    
    if ([sender.venkistr isEqualToString:@"Send a Message"])
    {
        self.taskTitleTxtFld.text = [NSString stringWithFormat:@"Message for %@", self.firstNameBtn.titleLabel.text];
    }
   else if ([sender.venkistr isEqualToString:@"Send a Document"])
    {
        self.taskTitleTxtFld.text = [NSString stringWithFormat:@"Send a Document to %@", self.firstNameBtn.titleLabel.text];
    }
    else if ([sender.venkistr isEqualToString:@"Request a Meeting"])
    {
        self.taskTitleTxtFld.text = [NSString stringWithFormat:@"Request a Meeting with %@", self.firstNameBtn.titleLabel.text];
    }
    
    else if([sender.venkistr isEqualToString:@"Make Payroll Change"])
    {
        self.taskTitleTxtFld.text = @"Request Payroll Change";
    }


    NSLog(@"%@", sender.venkistr);
    if ([sender.venkistr isEqualToString:@"Modify Employee"])
    {
        self.myStrOne = sender.venkistr;
    }
    if ([sender.venkistr isEqualToString:@"Add Employee"])
    {
        self.myStrOne = sender.venkistr;
    }
    if ([sender.venkistr isEqualToString:@"Terminate Employee"])
    {
        self.myStrOne = sender.venkistr;
    }

    if ([sender.venkistr isEqualToString:@"Demographics"])
    {
        self.myStr = sender.venkistr;
    }
    if ([sender.venkistr isEqualToString:@"Pay"])
    {
        self.myStr = sender.venkistr;
    }
    if ([sender.venkistr isEqualToString:@"Withholding"])
    {
        self.myStr = sender.venkistr;
    }

    [self rel];


}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (IBAction)dropDwnBtnClicked:(UIButton *)sender;
{
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
    self.isFromFirstName =YES;
    
    [self.dropDwownBtn setTitle:@"Request a Meeting" forState:UIControlStateNormal];
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
    
    return YES;
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
