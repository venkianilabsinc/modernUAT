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
#import <AssetsLibrary/AssetsLibrary.h>




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
@property (weak, nonatomic) IBOutlet UIView *fNameView;

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


//@property (weak, nonatomic) IBOutlet UITextField *birthdayDate;
@property (strong, nonatomic) UIDatePicker *datepicker;

@property (weak, nonatomic)    NSString *myStr;
@property (weak, nonatomic)    NSString *myStrOne;

@property (strong, nonatomic) NSString *taskTypeStrinmg;

-(void)rel;

@property (weak, nonatomic) IBOutlet UIButton *attachementBtn;

@property (weak, nonatomic) IBOutlet UITableView *attachmentsTableView;
@property (strong, nonatomic) NSMutableArray *attachmentsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *attachedImgCollectionView;
@property (strong, nonatomic) NSString *dateString;

@property (weak, nonatomic) IBOutlet UITextField *fNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *lNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property BOOL isfromCamera;

@property (weak, nonatomic) IBOutlet UIView *myView;
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
    
    
    
    [self.cancelBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.cancelBtn setTitle:[NSString stringWithUTF8String:"\uE815"] forState:UIControlStateNormal];
    
    
    //    [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
    
    //    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,10, self.view.frame.size.width,44)];
    //    toolbar.barStyle =UIBarStyleDefault;
    //
    //    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
    //                                                                                 target:self
    //                                                                                 action:@selector(cancelButtonPressed:)];
    //
    //    UIBarButtonItem *flexibleSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
    //                                                                                 target:self
    //                                                                                 action:nil];
    //
    //    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
    //                                                                               target:self
    //                                                                               action:@selector(doneButtonPressed:)];
    
    //    [toolbar setItems:@[cancelButton,flexibleSpace, doneButton]];
    
    //    self.birthdayDate.inputView = self.datepicker;
    //    self.birthdayDate.inputAccessoryView = toolbar;
    //    [self.datepicker setMinimumDate: [NSDate date]];
    
    
    [self.attachementBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:20]];
    [self.attachementBtn setTitle:[NSString stringWithUTF8String:"\uE92E"] forState:UIControlStateNormal];
    
    //    self.attachementBtn.layer.borderWidth = 1;
    //    self.attachementBtn.layer.borderColor = [[UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:1.0] CGColor];
    //    self.attachementBtn.layer.cornerRadius = self.attachementBtn.frame.size.height/2;
    //    self.attachementBtn.layer.masksToBounds = YES;
    
    
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\ue94f"] forState:UIControlStateNormal];
    
    [self.calenderLbl setFont:[UIFont fontWithName:@"liscio" size:18]];
    [self.calenderLbl setText:[NSString stringWithUTF8String:"\uE93E"]];
    
    
    [self.firstName setFont:[UIFont fontWithName:@"liscio" size:18]];
    [self.firstName setText:[NSString stringWithUTF8String:"\uEBFF"]];
    
    
    [self.dropDownLbl setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.dropDownLbl setText:[NSString stringWithUTF8String:"\uE753"]];
    
    [self.dropDownLbl1 setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.dropDownLbl1 setText:[NSString stringWithUTF8String:"\uE753"]];
    
    [self.dropDownLbl2 setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.dropDownLbl2 setText:[NSString stringWithUTF8String:"\uE753"]];
    
    
    self.fNameView.layer.cornerRadius = self.fNameView.frame.size.height/2;
    self.fNameView.layer.masksToBounds = YES;
    
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
    
    
    self.lNameTxtFld.layer.borderWidth = 1;
    self.lNameTxtFld.layer.cornerRadius = 2;
    self.lNameTxtFld.layer.borderColor =[[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.lNameTxtFld.layer.masksToBounds = YES;
    
    self.fNameTxtFld.layer.borderWidth = 1;
    self.fNameTxtFld.layer.cornerRadius = 2;
    self.fNameTxtFld.layer.borderColor =[[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.fNameTxtFld.layer.masksToBounds = YES;
    
    self.emailTxtFld.layer.borderWidth = 1;
    self.emailTxtFld.layer.cornerRadius = 2;
    self.emailTxtFld.layer.borderColor =[[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.emailTxtFld.layer.masksToBounds = YES;
    
    self.phoneTxtFld.layer.borderWidth = 1;
    self.phoneTxtFld.layer.cornerRadius = 2;
    self.phoneTxtFld.layer.borderColor =[[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.phoneTxtFld.layer.masksToBounds = YES;
    
    
    
    
    
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
    
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.fNameTxtFld.leftView = paddingView1;
    self.fNameTxtFld.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.lNameTxtFld.leftView = paddingView2;
    self.lNameTxtFld.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.emailTxtFld.leftView = paddingView3;
    self.emailTxtFld.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.phoneTxtFld.leftView = paddingView4;
    self.phoneTxtFld.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    [self.dropDwownBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.typeChangeBtnDropDown setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.modifyBtnDropDown setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [self.firstNameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.lastNameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    self.contactListArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.contactList1Array = [[NSMutableArray alloc] initWithCapacity:0];
    self.arrData = [NSMutableArray new];
    
    
    self.attachmentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    
    UIImage *image = [[UIImage imageNamed:@"attachment_ico.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(uploadimage:)];
    
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    UIImage *image1 = [[UIImage imageNamed:@"send_btn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(sendBtnPressed:)];
    
    keyboardToolbar.items = @[button, flexBarButton, doneBarButton];
    
    self.commentsTxtView.inputAccessoryView = keyboardToolbar;
    self.taskTitleTxtFld.inputAccessoryView = keyboardToolbar;
    
    
    
    //    self.taskTitleTxtFld.inputAccessoryView = self.myView;
    //    self.commentsTxtView.inputAccessoryView = self.myView;
    //
    
    
    
    
}
-(void)yourTextViewDoneButtonPressed
{
    [self.commentsTxtView resignFirstResponder];
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
    //    if ([[UIScreen mainScreen] bounds].size.width == 320)
    //    {
    //        if (self.firstNameBtn.frame.size.width < 257)
    //        {
    //            self.firstNameBtn.frame = CGRectMake(self.firstNameBtn.frame.origin.x, self.firstNameBtn.frame.origin.y, 257, self.firstNameBtn.frame.size.height);
    //
    //        }
    ////        else
    ////        {
    ////            self.firstNameBtn.frame = CGRectMake(self.firstNameBtn.frame.origin.x, self.firstNameBtn.frame.origin.y, self.firstNameBtn.frame.size.width, self.firstNameBtn.frame.size.height);
    ////
    ////        }
    //
    //    }
    
    self.fNameTxtFld.hidden = YES;
    self.lNameTxtFld.hidden = YES;
    self.emailTxtFld.hidden = YES;
    self.phoneTxtFld.hidden = YES;
    
    [self.dropDwownBtn setTitleColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.firstNameBtn setTitleColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.typeChangeBtnDropDown setTitleColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.modifyBtnDropDown setTitleColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self.firstNameBtn setTitle:@"Select Recipient" forState:UIControlStateNormal];
    self.firstNameBtn.titleLabel.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    
    self.commentsTxtView.text = @"Comments";
    self.commentsTxtView.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    self.dropDownLbl1.hidden = YES;
    self.dropDownLbl2.hidden= YES;
    self.modifyBtnDropDown.hidden = YES;
    self.typeChangeBtnDropDown.hidden = YES;
    self.taskTitleTxtFld.text = @"";
    self.taskTitleTxtFld.placeholder = @"Task Title";
    
    self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, 121, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
    self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
    
    //    self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
    self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
    
    //    self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame)+5, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
    
    
    
    [self.firstName setFont:[UIFont fontWithName:@"liscio" size:18]];
    [self.firstName setText:[NSString stringWithUTF8String:"\uEBFF"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy";
    self.dateString = [formatter stringFromDate:[NSDate date]];
    
    //    self.birthdayDate.text = dateString;
    
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
        
        self.firstNameBtn.frame = CGRectMake(self.firstNameBtn.frame.origin.x, self.firstNameBtn.frame.origin.y, 257, self.firstNameBtn.frame.size.height);
        
    }
    
    
    
    [self.attachmentsArray removeAllObjects];
    
    
    
    CGFloat tableHeight = 0.0f;
    for (int i = 0; i < [self.attachmentsArray count]; i ++) {
        tableHeight += [self tableView:self.attachmentsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.attachementBtn.frame)+ 10, self.attachmentsTableView.frame.size.width, tableHeight);
    
    
    
    [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, (self.attachmentsTableView.frame.size.height + self.commentsTxtView.frame.size.height + self.commentsTxtView.frame.origin.y) + 100)];
    
    
    
    
    
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

- (IBAction)crossBtnPressed:(UIButton *)sender
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isFromViewCtrl"] isEqualToString:@"Home1"])
    {
        [self.tabBarController setSelectedIndex:0];
        
    }else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"isFromViewCtrl"] isEqualToString:@"Open"])
    {
        [self.tabBarController setSelectedIndex:1];
        
    }else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"isFromViewCtrl"] isEqualToString:@"MyRelated"])
    {
        [self.tabBarController setSelectedIndex:3];
        
    }
    else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"isFromViewCtrl"] isEqualToString:@"Team"])
    {
        [self.tabBarController setSelectedIndex:4];
        
    }else{
        [self.tabBarController setSelectedIndex:0];
        
    }
    
}
//- (void)doneButtonPressed:(id)sender
//{
//    NSDate *birthdayDate = self.datepicker.date;
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
//
//    NSString *birthdayText = [dateFormatter stringFromDate:birthdayDate];
//    self.birthdayDate.text = birthdayText;
//
//    [self.view endEditing:YES];
//
//
//}


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
    [self.myView setHidden:YES];
    
    if ([self.taskTitleTxtFld.text isEqualToString:@""] || [self.dateString isEqualToString:@""] || [self.dropDwownBtn.titleLabel.text isEqualToString:@""] || [self.dropDwownBtn.titleLabel.text isEqualToString:@"Select a Task"] || [self.firstNameBtn.titleLabel.text isEqualToString:@""] || [self.firstNameBtn.titleLabel.text isEqualToString:@"Select Recipient"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Please fill Task Details" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self.myView setHidden:NO];
        
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
    
    if ([self.commentsTxtView.text isEqualToString:@""] || [self.commentsTxtView.text isEqualToString:@"Comments"]) {
        self.commentsTxtView.text = @"";
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
                    @"due_by" : self.dateString,
                    @"assigne_type" : self.Dict[@"assigne_type"],
                    @"description" : self.commentsTxtView.text,
                    @"task_type_key" : @"payroll_change",
                    @"task_type_value" : self.dropDwownBtn.titleLabel.text,
                    @"emp_modification_type" : self.myStr,//pay,demographs
                    @"payroll_change_type" : self.myStrOne};//modify, add,
    }
    
    else if ([self.self.dropDwownBtn.titleLabel.text isEqualToString:@"Add additional User"])
    {
        params1 = @{@"cpa_id" : self.Dict[@"cpa_id"],
                    @"subject" : self.taskTitleTxtFld.text,
                    @"for_account" : self.Dict[@"id"],
                    @"assigned_to_user" : self.Dict[@"value"],
                    @"due_by" : self.dateString,
                    @"assigne_type" : self.Dict[@"assigne_type"],
                    @"description" : self.commentsTxtView.text,
                    @"task_type_key" : self.taskTypeStrinmg,
                    @"task_type_value" : self.dropDwownBtn.titleLabel.text,
                    @"user_email" : _emailTxtFld.text,
                    @"user_first_name" :_fNameTxtFld.text,
                    @"user_last_name" : _lNameTxtFld.text,
                    @"user_phone_number" : self.phoneTxtFld.text};
        
        
    }
    else if ([self.self.dropDwownBtn.titleLabel.text isEqualToString:@"Remove a User"])
    {
        params1 = @{@"cpa_id" : self.Dict[@"cpa_id"],
                    @"subject" : self.taskTitleTxtFld.text,
                    @"for_account" : self.Dict[@"id"],
                    @"assigned_to_user" : self.Dict[@"value"],
                    @"due_by" : self.dateString,
                    @"assigne_type" : self.Dict[@"assigne_type"],
                    @"description" : self.commentsTxtView.text,
                    @"task_type_key" : self.taskTypeStrinmg,
                    @"task_type_value" : self.dropDwownBtn.titleLabel.text,
                    @"user_email" : _emailTxtFld.text,
                    @"user_first_name" :_fNameTxtFld.text,
                    @"user_last_name" : _lNameTxtFld.text};
        
    }
    
    else{
        params1 = @{@"cpa_id" : self.Dict[@"cpa_id"],
                    @"subject" : self.taskTitleTxtFld.text,
                    @"for_account" : self.Dict[@"id"],
                    @"assigned_to_user" : self.Dict[@"value"],
                    @"due_by" : self.dateString,
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
                 
                 [self.firstNameBtn setTitle:@"Select Recipient" forState:UIControlStateNormal];
                 self.firstName.text = @"";
                 self.firstNameBtn.titleLabel.textColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
                 
                 
                 UINavigationController *navigationController = self.tabBarController.viewControllers[0];
                 OpenTasksViewController *billsView = (OpenTasksViewController *)navigationController.viewControllers[0];
                 
                 [billsView.navigationController popToRootViewControllerAnimated:NO];
                 [self.tabBarController setSelectedIndex:0];
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
    
    //    [self.birthdayDate resignFirstResponder];
    
    
    
    if ([sender.venkistr isEqualToString:@"Make Payroll Change"])
    {
        self.fNameTxtFld.hidden = YES;
        self.lNameTxtFld.hidden = YES;
        self.emailTxtFld.hidden = YES;
        self.phoneTxtFld.hidden = YES;
        
        self.typeChangeBtnDropDown.hidden = NO;
        self.dropDownLbl1.hidden = NO;
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.typeChangeBtnDropDown.frame = CGRectMake(self.typeChangeBtnDropDown.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.typeChangeBtnDropDown.frame.size.width, self.typeChangeBtnDropDown.frame.size.height);
        self.dropDownLbl1.frame = CGRectMake(self.dropDownLbl.frame.origin.x, self.typeChangeBtnDropDown.frame.origin.y, self.dropDownLbl1.frame.size.width, self.dropDownLbl1.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            self.dropDownLbl1.frame = CGRectMake(260, self.typeChangeBtnDropDown.frame.origin.y, self.dropDownLbl1.frame.size.width, self.dropDownLbl1.frame.size.height);
        }
        
        
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //        }
        
        [self.dropDwownBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.typeChangeBtnDropDown setTitleColor:[UIColor colorWithRed:170/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }
    else if ([sender.venkistr isEqualToString:@"Send a Document"])
    {
        self.fNameTxtFld.hidden = YES;
        self.lNameTxtFld.hidden = YES;
        self.emailTxtFld.hidden = YES;
        self.phoneTxtFld.hidden = YES;
        
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.typeChangeBtnDropDown.hidden = YES;
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 550)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        //        }
        [self.dropDwownBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }
    else if([sender.venkistr isEqualToString:@"Send a Message"])
    {
        self.fNameTxtFld.hidden = YES;
        self.lNameTxtFld.hidden = YES;
        self.emailTxtFld.hidden = YES;
        self.phoneTxtFld.hidden = YES;
        
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.modifyBtnDropDown.hidden = YES;
        
        self.typeChangeBtnDropDown.hidden = YES;
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 550)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        //        }
        //
        //        self.taskTitleTxtFld.text = ;
        [self.dropDwownBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
    }
    else if ([sender.venkistr isEqualToString:@"Request a Meeting"])
    {
        self.fNameTxtFld.hidden = YES;
        self.lNameTxtFld.hidden = YES;
        self.emailTxtFld.hidden = YES;
        self.phoneTxtFld.hidden = YES;
        
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        
        self.modifyBtnDropDown.hidden = YES;
        
        self.typeChangeBtnDropDown.hidden = YES;
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 550)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        //        }
        [self.dropDwownBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
    }
    else if ([sender.venkistr isEqualToString:@"Add additional User"])
    {
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        self.modifyBtnDropDown.hidden = YES;
        self.typeChangeBtnDropDown.hidden = YES;
        
        
        self.fNameTxtFld.hidden = NO;
        self.lNameTxtFld.hidden = NO;
        self.emailTxtFld.hidden = NO;
        self.phoneTxtFld.hidden = NO;
        
        
        self.fNameTxtFld.frame = CGRectMake(self.fNameTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.fNameTxtFld.frame.size.width, self.fNameTxtFld.frame.size.height);
        
        self.lNameTxtFld.frame = CGRectMake(self.lNameTxtFld.frame.origin.x, CGRectGetMaxY(self.fNameTxtFld.frame) + 10, self.lNameTxtFld.frame.size.width, self.lNameTxtFld.frame.size.height);
        
        self.emailTxtFld.frame = CGRectMake(self.emailTxtFld.frame.origin.x, CGRectGetMaxY(self.lNameTxtFld.frame) + 10, self.emailTxtFld.frame.size.width, self.emailTxtFld.frame.size.height);
        
        self.phoneTxtFld.frame = CGRectMake(self.phoneTxtFld.frame.origin.x, CGRectGetMaxY(self.emailTxtFld.frame) + 10, self.phoneTxtFld.frame.size.width, self.phoneTxtFld.frame.size.height);
        
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.phoneTxtFld.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 600)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
        //        }
        [self.dropDwownBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
    }
    else if ([sender.venkistr isEqualToString:@"Remove a User"])
    {
        self.dropDownLbl1.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.fNameTxtFld.hidden = NO;
        self.lNameTxtFld.hidden = NO;
        self.emailTxtFld.hidden = NO;
        self.phoneTxtFld.hidden = YES;
        
        
        self.modifyBtnDropDown.hidden = YES;
        
        self.typeChangeBtnDropDown.hidden = YES;
        self.fNameTxtFld.frame = CGRectMake(self.fNameTxtFld.frame.origin.x, CGRectGetMaxY(self.dropDwownBtn.frame) + 10, self.fNameTxtFld.frame.size.width, self.fNameTxtFld.frame.size.height);
        
        self.lNameTxtFld.frame = CGRectMake(self.lNameTxtFld.frame.origin.x, CGRectGetMaxY(self.fNameTxtFld.frame) + 10, self.lNameTxtFld.frame.size.width, self.lNameTxtFld.frame.size.height);
        
        self.emailTxtFld.frame = CGRectMake(self.emailTxtFld.frame.origin.x, CGRectGetMaxY(self.lNameTxtFld.frame) + 10, self.emailTxtFld.frame.size.width, self.emailTxtFld.frame.size.height);
        
        
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.emailTxtFld.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 550)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
        //        }
        [self.dropDwownBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
    }
    
    else if ([sender.venkistr isEqualToString:@"Modify Employee"])
    {
        self.fNameTxtFld.hidden = YES;
        self.lNameTxtFld.hidden = YES;
        self.emailTxtFld.hidden = YES;
        self.phoneTxtFld.hidden = YES;
        
        self.modifyBtnDropDown.hidden = NO;
        self.dropDownLbl2.hidden= NO;
        
        self.modifyBtnDropDown.frame = CGRectMake(self.modifyBtnDropDown.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.modifyBtnDropDown.frame.size.width, self.modifyBtnDropDown.frame.size.height);
        
        self.dropDownLbl2.frame = CGRectMake(self.dropDownLbl.frame.origin.x, self.modifyBtnDropDown.frame.origin.y, self.dropDownLbl2.frame.size.width, self.dropDownLbl2.frame.size.height);
        
        if ([[UIScreen mainScreen] bounds].size.width == 320)
        {
            self.dropDownLbl2.frame = CGRectMake(260, self.modifyBtnDropDown.frame.origin.y, self.dropDownLbl2.frame.size.width, self.dropDownLbl2.frame.size.height);
        }
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.modifyBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 414)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 750)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
        //        }
        
        [self.typeChangeBtnDropDown setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.modifyBtnDropDown setTitleColor:[UIColor colorWithRed:170/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }
    else if ([sender.venkistr isEqualToString:@"Add Employee"])
    {
        self.fNameTxtFld.hidden = YES;
        self.lNameTxtFld.hidden = YES;
        self.emailTxtFld.hidden = YES;
        self.phoneTxtFld.hidden = YES;
        
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
        //        }
        
        [self.typeChangeBtnDropDown setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
    }
    else if ([sender.venkistr isEqualToString:@"Terminate Employee"])
    {
        self.fNameTxtFld.hidden = YES;
        self.lNameTxtFld.hidden = YES;
        self.emailTxtFld.hidden = YES;
        self.phoneTxtFld.hidden = YES;
        
        self.modifyBtnDropDown.hidden = YES;
        self.dropDownLbl2.hidden= YES;
        
        
        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
        
        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
        //        self.attachementBtn.frame = CGRectMake(self.attachementBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachementBtn.frame.size.width, self.attachementBtn.frame.size.height);
        
        
        self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 10, self.attachmentsTableView.frame.size.width, self.attachmentsTableView.frame.size.height);
        
        //        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.attachmentsTableView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        
        //        self.ownerLbl.frame = CGRectMake(self.ownerLbl.frame.origin.x, CGRectGetMaxY(self.sendBtn.frame) + 20, self.ownerLbl.frame.size.width, self.ownerLbl.frame.size.height);
        //        if ([[UIScreen mainScreen] bounds].size.width == 320)
        //        {
        //            //        NSLog(@"iphone 5");
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //
        //        }else if ([[UIScreen mainScreen] bounds].size.width == 375)
        //        {
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
        //
        //        }else{
        //            [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, 650)];
        //        }
        //
        [self.typeChangeBtnDropDown setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
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
    else if([sender.venkistr isEqualToString:@"Add additional User"])
    {
        self.taskTypeStrinmg = @"add_user";
        
        self.taskTitleTxtFld.text = @"Add Additional User";
        //        [self.typeChangeBtnDropDown setTitle:@"Type of Change" forState:UIControlStateNormal];
        
    }
    else if([sender.venkistr isEqualToString:@"Remove a User"])
    {
        self.taskTypeStrinmg = @"remove_user";
        
        self.taskTitleTxtFld.text = @"Remove User";
        //        [self.typeChangeBtnDropDown setTitle:@"Type of Change" forState:UIControlStateNormal];
        
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
        [self.modifyBtnDropDown setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }
    if ([sender.venkistr isEqualToString:@"Pay"])
    {
        self.myStr = sender.venkistr;
        self.taskTitleTxtFld.text = @"Modify Employee's Payroll - Pay";
        [self.modifyBtnDropDown setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }
    if ([sender.venkistr isEqualToString:@"Withholding"])
    {
        self.myStr = sender.venkistr;
        self.taskTitleTxtFld.text = @"Modify Employee's Payroll - Witholdings";
        [self.modifyBtnDropDown setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        
    }
    
    
    [self.firstNameBtn setTitleColor:[UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    
    
    CGFloat tableHeight = 0.0f;
    for (int i = 0; i < [self.attachmentsArray count]; i ++) {
        tableHeight += [self tableView:self.attachmentsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame)+ 10, self.attachmentsTableView.frame.size.width, tableHeight);
    
    
    
    [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, (self.attachmentsTableView.frame.size.height + self.commentsTxtView.frame.size.height + self.commentsTxtView.frame.origin.y) + 100)];
    
    
    
    [self rel];
    
    
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (IBAction)dropDwnBtnClicked:(UIButton *)sender;
{
    //    [self.birthdayDate resignFirstResponder];
    
    self.isFromFirstName = NO;
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Request a Meeting", @"Send a Message", @"Make Payroll Change", @"Send a Document", nil];
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
    //    [self.birthdayDate resignFirstResponder];
    
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
    //    [self.birthdayDate resignFirstResponder];
    
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
    //    [self.birthdayDate resignFirstResponder];
    
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
    //    [self.birthdayDate resignFirstResponder];
    
    SettingsViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    
    return YES;
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//
//    return YES;
//}

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
            textView.textColor = [UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0];
            
            return NO;
        }
    }
    
    return YES;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    if ([textView.text isEqualToString: @"comments"])
    {
        textView.text = @"";
        
    }
    if ([textView.text isEqualToString: @"Comments"])
    {
        textView.text = @"";
        
    }
    
    textView.textColor = [UIColor colorWithRed:62.0/255.0 green:78.0/255.0 blue:104.0/255.0 alpha:1.0];
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
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
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
            self.shiftForKeyboard = bottomEdge - 320;
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


//- (void)keyboardDidShow:(NSNotification *)notification
//{
//    // Assign new frame to your view
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//    //Given size may not account for screen rotation
//    int height = MIN(keyboardSize.height,keyboardSize.width);
//    int width = MAX(keyboardSize.height,keyboardSize.width);
//
//
//    [self.myView setFrame:CGRectMake(0,(self.view.frame.size.height - height) - 50,self.view.frame.size.width,50)]; //here taken -110 for example i.e. your view will be scrolled to -110. change its value according to your requirement.
//
//}
//
//-(void)keyboardDidHide:(NSNotification *)notification
//{
//    [self.myView setFrame:CGRectMake(0,525,self.view.frame.size.width,50)];
//}

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
    [self.myView setHidden:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Take a Photo"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                              UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                              picker.delegate = self;
                                                              //                                                              picker.allowsEditing = YES;
                                                              self.isfromCamera = YES;
                                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              
                                                              [self presentViewController:picker animated:YES completion:NULL];
                                                              
                                                              [self.myView setHidden:NO];
                                                              
                                                              NSLog(@"You pressed button one");
                                                          }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Choose from Existing"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed button two");
                                                               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                               picker.delegate = self;
                                                               picker.allowsEditing = YES;
                                                               self.isfromCamera = NO;
                                                               
                                                               picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                               
                                                               [self presentViewController:picker animated:YES completion:NULL];
                                                               
                                                               [self.myView setHidden:NO];
                                                               
                                                           }];
    
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button two");
                                                              [self.myView setHidden:NO];
                                                              
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
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init]; [format setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *imageName = [NSString stringWithFormat:@"Image_%@.jpg", [format stringFromDate:now]];
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://liscioapistage.herokuapp.com/api/v1/documents"];  // enter your url to upload
    //    [sharedObject uploadImage:params1 selectImage:data success:^(NSDictionary *responseObject)
    
    if (self.isfromCamera)
    {
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
             
             
             CGFloat tableHeight = 0.0f;
             for (int i = 0; i < [self.attachmentsArray count]; i ++) {
                 tableHeight += [self tableView:self.attachmentsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
             }
             self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame)+ 10, self.attachmentsTableView.frame.size.width, tableHeight);
             
             
             
             [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, (self.attachmentsTableView.frame.size.height + self.commentsTxtView.frame.size.height + self.commentsTxtView.frame.origin.y) + 100)];
             
             
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
        
    }else{
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:info[UIImagePickerControllerReferenceURL]
                 resultBlock:^(ALAsset *fileAsset) {
                     
                     NSLog(@"%@", [[fileAsset defaultRepresentation] filename]);
                     
                     
                     
                     [self.activityIndicator startAnimating];
                     
                     PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
                     NSDictionary *params1 = @{@"task_id" : @"",
                                               @"aws_url" : base64,
                                               @"file_name" : [[fileAsset defaultRepresentation] filename]};
                     [sharedObject uploadImgeFromMobile:params1 success:^(NSDictionary *responseObject)
                      {
                          [self.activityIndicator stopAnimating];
                          //         NSLog(@"My responseObject \n%@", responseObject);
                          
                          [self.attachmentsArray addObject:responseObject[@"data"]];
                          
                          
                          CGFloat tableHeight = 0.0f;
                          for (int i = 0; i < [self.attachmentsArray count]; i ++) {
                              tableHeight += [self tableView:self.attachmentsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                          }
                          self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame)+ 10, self.attachmentsTableView.frame.size.width, tableHeight);
                          
                          
                          
                          [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, (self.attachmentsTableView.frame.size.height + self.commentsTxtView.frame.size.height + self.commentsTxtView.frame.origin.y) + 100)];
                          
                          
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
                     
                 } failureBlock:nil];
        
    }
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
        [cell.attamentImgLbl setFont:[UIFont fontWithName:@"liscio" size:18]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 54;
}

-(IBAction)delBtnPressed:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.attachmentsTableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    
    NSMutableDictionary *dict = [self.attachmentsArray objectAtIndex:indexPath.row];
    NSString *mystr1  = [dict[@"id"] stringValue];
    if (mystr1 == nil || [mystr1 isEqual:[NSNull null]] || [mystr1 isEqualToString:@""])
    {
        [self.attachmentsTableView reloadData];
        //        [self.attachedImgCollectionView reloadData];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure want to delete the Attachment" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
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
                     
                     
                     CGFloat tableHeight = 0.0f;
                     for (int i = 0; i < [self.attachmentsArray count]; i ++) {
                         tableHeight += [self tableView:self.attachmentsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                     }
                     self.attachmentsTableView.frame = CGRectMake(self.attachmentsTableView.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame)+ 10, self.attachmentsTableView.frame.size.width, tableHeight);
                     
                     [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, (self.attachmentsTableView.frame.size.height + self.commentsTxtView.frame.size.height + self.commentsTxtView.frame.origin.y) + 100)];
                     
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
        
        
    }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:defaultAction];
    [alert addAction:noButton];
    //Present action where needed
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    NSLog(@"%ld",(long)indexPath.row);
    
}

@end
