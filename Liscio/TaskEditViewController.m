//
//  TaskEditViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 04/04/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "TaskEditViewController.h"
#import "SettingsViewController.h"
#import "CommentsTableViewCell.h"
#import "PortfolioHttpClient.h"
#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define isiPhone5Device (DEVICE_HEIGHT == 568) ? YES : NO

@interface TaskEditViewController ()

@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *attachmentBtn;

@property (weak, nonatomic) IBOutlet UILabel *rightMarkLbl;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *calenderLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property CGFloat shiftForKeyboard;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UITextField *dateTxtfield;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLbl;
@property (weak, nonatomic) IBOutlet UITextView *subjectTxtLbl;
@property (strong, nonatomic) NSMutableDictionary *openArray;
@property (strong, nonatomic) NSMutableArray *templatesArray;
@property (strong, nonatomic) NSMutableDictionary *totalDict;
@property (weak, nonatomic) IBOutlet UITextField *commentTxtFld;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) NSMutableArray *commentsArray;
//@property (weak, nonatomic) IBOutlet UIDatePicker *dpDatePicker;
@property (strong, nonatomic) UIDatePicker *datepicker;


@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UIButton *subTitleBtn;

@property (weak,nonatomic) IBOutlet UILabel *dropDownLbl;
@property (weak,nonatomic) IBOutlet UILabel *dropDownLbl1;

@property BOOL isFromAddEmployee;
@property (weak, nonatomic)    NSString *myStr;
@property (weak, nonatomic)    NSString *myStrOne;

@property (weak, nonatomic)  NSString *DateString;

@end

@implementation TaskEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.openArray = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.templatesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.totalDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.commentsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [self.subTitleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];

    [self.dropDownLbl setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.dropDownLbl setText:[NSString stringWithUTF8String:"\uE753"]];
    
    [self.dropDownLbl1 setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.dropDownLbl1 setText:[NSString stringWithUTF8String:"\uE753"]];

    self.titleBtn.layer.cornerRadius = 4;
    self.titleBtn.layer.borderWidth = 1;
    self.titleBtn.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.titleBtn.layer.masksToBounds = YES;

    self.subTitleBtn.layer.cornerRadius = 4;
    self.subTitleBtn.layer.borderWidth = 1;
    self.subTitleBtn.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:218/250.0 blue:222/255.0 alpha:1.0] CGColor];
    self.subTitleBtn.layer.masksToBounds = YES;

    
    self.datepicker = [[UIDatePicker alloc] init];
    self.datepicker.datePickerMode = UIDatePickerModeDate;
    
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
    
    self.dateTxtfield.inputView = self.datepicker;
    self.dateTxtfield.inputAccessoryView = toolbar;

    
    // Do any additional setup after loading the view.
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\uE626"] forState:UIControlStateNormal];
    
//    [self.saveBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
//    [self.saveBtn setTitle:[NSString stringWithUTF8String:"\uE75B"] forState:UIControlStateNormal];
    
    [self.attachmentBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    [self.attachmentBtn setTitle:[NSString stringWithUTF8String:"\uE92E"] forState:UIControlStateNormal];
    
    [self.rightMarkLbl setFont:[UIFont fontWithName:@"icomoon" size:30]];
    [self.rightMarkLbl setText:[NSString stringWithUTF8String:"\uE92F"]];
    
    self.firstName.layer.cornerRadius = self.firstName.frame.size.height/2;
    self.firstName.layer.masksToBounds = YES;
    
    self.lastName.layer.cornerRadius = self.lastName.frame.size.height/2;
    self.lastName.layer.masksToBounds = YES;
    
    self.attachmentBtn.layer.borderWidth = 1;
    self.attachmentBtn.layer.borderColor = [[UIColor colorWithRed:148/255.0 green:204/255.0 blue:225/255.0 alpha:1.0] CGColor];
    self.attachmentBtn.layer.cornerRadius = self.attachmentBtn.frame.size.height/2;
    self.attachmentBtn.layer.masksToBounds = YES;
    
//    self.saveBtn.layer.borderWidth = 1;
//    self.saveBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
//    self.saveBtn.layer.cornerRadius = self.saveBtn.frame.size.height/2;
//    self.saveBtn.layer.masksToBounds = YES;
    
    [self.calenderLbl setFont:[UIFont fontWithName:@"icomoon" size:18]];
    [self.calenderLbl setText:[NSString stringWithUTF8String:"\uE93E"]];
//    
//    
//    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
//    [tapBackground setNumberOfTapsRequired:1];
//    [self.view addGestureRecognizer:tapBackground];
    
    NSLog(@"edit dict is%@", self.editDict);
    
    self.name.text = self.editDict[@"assigne"];
    self.accountName.text =  self.editDict[@"account"];
    self.dateTxtfield.text =  self.editDict[@"due_date"];
    self.subjectTxtLbl.text =  self.editDict[@"subject"];
    self.ownerNameLbl.text = [NSString stringWithFormat:@"Owner: %@", self.editDict[@"owner"]];
    
   self.myStr =  self.titleBtn.titleLabel.text;
    self.myStrOne = self.subTitleBtn.titleLabel.text;

    self.DateString = self.editDict[@"due_date"];
    NSString *responseStr = self.editDict[@"id"];
    [[NSUserDefaults standardUserDefaults] setObject:responseStr forKey:@"ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [self.editDict[@"assigne"]  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
        }
    }
    
    
    NSMutableString * firstCharacters1 = [NSMutableString string];
    NSArray * words1 = [self.editDict[@"account"]  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words1) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters1 appendString:[firstLetter uppercaseString]];
        }
    }
    
    
    self.firstName.text =   firstCharacters;
    self.lastName.text =  firstCharacters1;
    
    self.templatesArray = self.editDict[@"templates"];
    self.openArray = [self.templatesArray valueForKey:@"Open"][0][0];
    
    self.commentsArray = self.editDict[@"comments"];

    [self.commentsTableView reloadData];
    

}

-(void) viewWillAppear:(BOOL)animated
{
    //         if (self.webViewStr == nil || [self.webViewStr isEqual:[NSNull null]])

    

    
    
    if ([self.editDict[@"task_type_value"] isEqualToString:@"Send a Message"] || [self.editDict[@"task_type_value"] isEqualToString:@"Send a Document"] || [self.editDict[@"task_type_value"] isEqualToString:@"Request a Meeting"])
    {
        self.isFromAddEmployee = NO;
        self.titleBtn.hidden = YES;
        self.subTitleBtn.hidden = YES;
        self.dropDownLbl.hidden = YES;
        self.dropDownLbl1.hidden = YES;

        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.attachmentBtn.frame), self.commentsTableView.frame.size.width, 300);
        return;

    }
    if ([self.editDict[@"payroll_change_type"] isEqualToString:@""] || self.editDict[@"payroll_change_type"] == nil || [self.editDict[@"payroll_change_type"] isEqual:[NSNull null]])
    {
        self.isFromAddEmployee = NO;

        self.titleBtn.hidden = YES;
        self.subTitleBtn.hidden = YES;
        self.dropDownLbl.hidden = YES;
        self.dropDownLbl1.hidden = YES;


    }else{
        self.isFromAddEmployee = YES;

        self.titleBtn.hidden = NO;
        self.subTitleBtn.hidden = YES;
        self.dropDownLbl.hidden = NO;
        self.dropDownLbl1.hidden = YES;

        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.titleBtn.frame), self.commentsTableView.frame.size.width, 270);

 
    }
    if ([self.editDict[@"emp_modification_type"] isEqualToString:@""] || self.editDict[@"emp_modification_type"] == nil || [self.editDict[@"emp_modification_type"] isEqual:[NSNull null]])
    {
//        self.isFromAddEmployee = NO;

//        self.titleBtn.hidden = YES;
        self.subTitleBtn.hidden = YES;
        
        
    }else{
        self.isFromAddEmployee = YES;

//        self.titleBtn.hidden = NO;
        self.subTitleBtn.hidden = NO;
        self.dropDownLbl.hidden = NO;
        self.dropDownLbl1.hidden = NO;

        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.subTitleBtn.frame), self.commentsTableView.frame.size.width, 210);

        
    }

}

- (void)cancelButtonPressed:(id)sender
{
    [self.view endEditing:YES];
}

- (void)doneButtonPressed:(id)sender
{
    NSDate *birthdayDate = self.datepicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yy"];
    
    NSString *birthdayText = [dateFormatter stringFromDate:birthdayDate];
    self.dateTxtfield.text = birthdayText;
    [self.view endEditing:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}


-(IBAction)settingsBtnPressed:(id)sender
{
    SettingsViewController *teamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:teamVC animated:YES];
    
    
}


-(IBAction)threeDotsBtnPressed:(id)sender
{
    
    [self.subjectTxtLbl resignFirstResponder];
    [self.commentTxtFld resignFirstResponder];
    [self.dateTxtfield resignFirstResponder];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormatter dateFromString:self.dateTxtfield.text];

    self.DateString = [dateFormatter stringFromDate:date];


    if ([self.DateString isEqualToString:@""] || [self.subjectTxtLbl.text isEqualToString:@""] || self.DateString == nil)  {
        
        self.dateTxtfield.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!" message:@"Please Date & Subject" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

        [self.activityIndicator startAnimating];
    
        PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    
    if ([self.titleBtn.titleLabel.text isEqualToString:@""] || self.titleBtn.titleLabel.text == nil || [self.titleBtn.titleLabel.text isEqual:[NSNull null]] )
    {
        self.myStr = @"";
    }
    //Add Employee", @"Modify Employee", @"Terminate Employee
    if ([self.subTitleBtn.titleLabel.text isEqualToString:@""] || self.subTitleBtn.titleLabel.text == nil || [self.subTitleBtn.titleLabel.text isEqual:[NSNull null]])
    {
        self.myStrOne = @"";
    }
    
    if ([self.myStr isEqualToString:@"Add Employee"])
    {
        self.myStrOne = @"";
    }

    if (self.isFromAddEmployee == YES)
    {
        NSDictionary *params = @{@"due_by" : self.DateString,
                    @"subject" : self.subjectTxtLbl.text,
                    @"emp_modification_type" :self.myStrOne,//pay, demograph
                    @"payroll_change_type" : self.myStr};//modify, add, terminate
        
        [sharedObject updatePayRoll:params success:^(NSDictionary *responseObject)
         {
             [self.activityIndicator stopAnimating];
             
             if ([responseObject[@"status"] integerValue] == 200)
             {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
                     [self.navigationController.tabBarController setSelectedIndex:1];
                     
                 }];
                 [alert addAction:defaultAction];
                 //Present action where needed
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }else{
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
                 }];
                 [alert addAction:defaultAction];
                 //Present action where needed
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [self.activityIndicator stopAnimating];
         }];

        
        
    }
    else
    {
        NSDictionary *params1 = @{@"due_by" : self.DateString,
                    @"subject" : self.subjectTxtLbl.text};
        
        //                                  @"subject" : self.subjectTxtLbl.text};
        [sharedObject updateTaskField:params1 success:^(NSDictionary *responseObject)
         {
             [self.activityIndicator stopAnimating];
             
             if ([responseObject[@"status"] integerValue] == 200)
             {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
                     
                     //                                  [self.navigationController popViewControllerAnimated:YES];
                     
                     [self.navigationController.tabBarController setSelectedIndex:1];
                     
                 }];
                 [alert addAction:defaultAction];
                 //Present action where needed
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }else{
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
                 }];
                 [alert addAction:defaultAction];
                 //Present action where needed
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [self.activityIndicator stopAnimating];
         }];
        


    }
//        NSDictionary *params1 = @{@"due_by" : newDateString,
}



-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    
    [textField resignFirstResponder];

    return YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    if (bottomEdge >= 260) {//250
        CGRect viewFrame = self.view.frame;
        self.shiftForKeyboard = bottomEdge - 260;
        if(!isiPhone5Device)
        {
            self.shiftForKeyboard = bottomEdge - 400;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"commentsCellID";
    
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *myStr = [[self.commentsArray valueForKey:@"comment"] objectAtIndex:indexPath.row];
    
    NSString *myStr1 = [NSString stringWithFormat:@" on %@", [[self.commentsArray valueForKey:@"tym"] objectAtIndex:indexPath.row]];
    
    NSString *myStr2 = [NSString stringWithFormat:@"%@%@", myStr, myStr1];
    
    cell.commentsLbl.text = myStr2;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)typeChangeBtnClicked:(UIButton *)sender;
{
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

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    
    
    
    if ([sender.venkistr isEqualToString:@"Modify Employee"])
    {
        self.subTitleBtn.hidden = NO;
        self.dropDownLbl1.hidden= NO;
        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.subTitleBtn.frame), self.commentsTableView.frame.size.width, 270);

        
//        self.sub.frame = CGRectMake(self.modifyBtnDropDown.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.modifyBtnDropDown.frame.size.width, self.modifyBtnDropDown.frame.size.height);
        
//        self.dropDownLbl2.frame = CGRectMake(321, self.modifyBtnDropDown.frame.origin.y, self.dropDownLbl2.frame.size.width, self.dropDownLbl2.frame.size.height);
//        
//        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.modifyBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
//        
//        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
//        
//        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
    }
    else if ([sender.venkistr isEqualToString:@"Add Employee"])
    {
        
        self.subTitleBtn.hidden = YES;
        self.dropDownLbl1.hidden= YES;
        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.titleBtn.frame), self.commentsTableView.frame.size.width, 270);

//
//        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
//        
//        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
//        
//        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
//        
        
    }
    else if ([sender.venkistr isEqualToString:@"Terminate Employee"])
    {
        self.subTitleBtn.hidden = YES;
        self.dropDownLbl1.hidden= YES;
        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.titleBtn.frame), self.commentsTableView.frame.size.width, 270);

//
//
//        self.taskTitleTxtFld.frame = CGRectMake(self.taskTitleTxtFld.frame.origin.x, CGRectGetMaxY(self.typeChangeBtnDropDown.frame) + 10, self.taskTitleTxtFld.frame.size.width, self.taskTitleTxtFld.frame.size.height);
//        
//        self.commentsTxtView.frame = CGRectMake(self.commentsTxtView.frame.origin.x, CGRectGetMaxY(self.taskTitleTxtFld.frame) + 10, self.commentsTxtView.frame.size.width, self.commentsTxtView.frame.size.height);
//        
//        self.sendBtn.frame = CGRectMake(self.sendBtn.frame.origin.x, CGRectGetMaxY(self.commentsTxtView.frame) + 20, self.sendBtn.frame.size.width, self.sendBtn.frame.size.height);
        
        
    }
    
    if ([sender.venkistr isEqualToString:@"Modify Employee"])
    {
        self.myStr = sender.venkistr;
    }
    if ([sender.venkistr isEqualToString:@"Add Employee"])
    {
        self.myStr = sender.venkistr;
        self.myStrOne = @"";

    }
    if ([sender.venkistr isEqualToString:@"Terminate Employee"])
    {
        self.myStr = sender.venkistr;
        self.myStrOne = @"";

    }
    
    if ([sender.venkistr isEqualToString:@"Demographics"])
    {
        self.myStrOne = sender.venkistr;
    }
    if ([sender.venkistr isEqualToString:@"Pay"])
    {
        self.myStrOne = sender.venkistr;
    }
    if ([sender.venkistr isEqualToString:@"Withholding"])
    {
        self.myStrOne = sender.venkistr;
    }

    [self rel];
    
    
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
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
