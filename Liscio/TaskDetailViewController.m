//
//  TaskDetailViewController.m
//  Liscio
//
//  Created by Anilabs Inc on 27/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "SettingsViewController.h"
#import "PortfolioHttpClient.h"
#import "CommentsTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TaskEditViewController.h"
#import "WebViewController.h"
#import <UIImageView+AFNetworking.h>

#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface TaskDetailViewController ()<UIGestureRecognizerDelegate>
#define isiPhone5Device (DEVICE_WIDTH == 320) ? YES : NO

@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *attachmentBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightMarkLbl;
@property (weak, nonatomic) IBOutlet UILabel *assigneeLbl;
@property (weak, nonatomic) IBOutlet UILabel *taskTypeValue;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property CGFloat shiftForKeyboard;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *subjectTxtLbl;
@property (strong, nonatomic) NSMutableDictionary *openArray;
@property (strong, nonatomic) NSMutableArray *templatesArray;
@property (strong, nonatomic) NSMutableDictionary *totalDict;
@property (weak, nonatomic) IBOutlet UITextView *commentTxtFld;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITableView *attachementsTableView;

@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) NSMutableArray *docsArray;
@property (strong, nonatomic) NSString *webViewStr;
@property (weak, nonatomic) IBOutlet UIButton *documentBtn;
@property (strong, nonatomic) NSMutableArray *myArray;

@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;

@property (strong, nonatomic) NSString *pdfStr;

@property BOOL isFromPdfFile;
@property BOOL isfromCamera;


@property (weak, nonatomic) IBOutlet UIView *alerLbl;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak,nonatomic) IBOutlet UILabel *messageTxtLbl;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrolView;

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    //
    //        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
    //                                                              message:@"Device has no camera"
    //                                                             delegate:nil
    //                                                    cancelButtonTitle:@"OK"
    //                                                    otherButtonTitles: nil];
    //
    //        [myAlertView show];
    //
    //    }
    
    
    
    
    
    
    
    self.sendButton.layer.borderWidth = 1.0;
    self.sendButton.layer.borderColor = [[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0] CGColor];
    self.sendButton.layer.cornerRadius = 4.0;
    
    self.openArray = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.templatesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.totalDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.commentsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.docsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.myArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    NSLog(@"TaskDict is..\n%@", self.taskDict);
    
    if ([self.taskDict[@"status"] isEqualToString:@"Closed"])
    {
        [self.rightMarkLbl setEnabled:NO];
        [self.attachmentBtn setEnabled:NO];
        [self.commentTxtFld setEditable:NO];
        [self.deleteBtn setHidden:YES];
        [self.sendButton setEnabled:NO];
        
    }else if([self.taskDict[@"status"] isEqualToString:@"Review"])
    {
        [self.rightMarkLbl setEnabled:YES];
        [self.commentTxtFld setEditable:YES];
        [self.attachmentBtn setEnabled:YES];
        [self.deleteBtn setHidden:YES];
        [self.sendButton setEnabled:YES];
        
        //        [self.dotsBtn setEnabled:NO];
        
        
    }else{
        [self.rightMarkLbl setEnabled:YES];
        [self.attachmentBtn setEnabled:YES];
        [self.commentTxtFld setEditable:YES];
        [self.deleteBtn setEnabled:YES];
        
        //        [self.dotsBtn setEnabled:YES];
        
        
    }
    
    // Do any additional setup after loading the view.
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\ue94f"] forState:UIControlStateNormal];
    
    [self.deleteBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:20]];
    [self.deleteBtn setTitle:[NSString stringWithUTF8String:"\uE93F"] forState:UIControlStateNormal];
    
    [self.backBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:20]];
    [self.backBtn setTitle:[NSString stringWithUTF8String:"\uE752"] forState:UIControlStateNormal];
    
    
    [self.attachmentBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:20]];
    [self.attachmentBtn setTitle:[NSString stringWithUTF8String:"\uE92E"] forState:UIControlStateNormal];
    
    [self.rightMarkLbl.titleLabel setFont:[UIFont fontWithName:@"liscio" size:30]];
    [self.rightMarkLbl setTitle:[NSString stringWithUTF8String:"\uE92F"]forState:UIControlStateNormal];
    
    
    self.attachmentBtn.layer.borderWidth = 1;
    self.attachmentBtn.layer.borderColor = [[UIColor colorWithRed:92/255.0 green:181/255.0 blue:213/255.0 alpha:1.0] CGColor];
    self.attachmentBtn.layer.cornerRadius = self.attachmentBtn.frame.size.height/2;
    self.attachmentBtn.layer.masksToBounds = YES;
    
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.height/2;
    self.deleteBtn.layer.masksToBounds = YES;
    
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.backBtn.layer.cornerRadius = self.backBtn.frame.size.height/2;
    self.backBtn.layer.masksToBounds = YES;
    
    self.commentsTableView.allowsMultipleSelectionDuringEditing = NO;
    
    //    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    //    self.commentTxtFld.leftView = paddingView;
    //    self.commentTxtFld.leftViewMode = UITextFieldViewModeAlways;
    
    self.commentTxtFld.layer.borderWidth = 1.0;
    self.commentTxtFld.layer.borderColor = [[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0] CGColor];
    self.commentTxtFld.layer.cornerRadius = 4.0;
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tapBackground.delegate = self;
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.commentsTableView addGestureRecognizer:gestureRecognizer];
    
    UITapGestureRecognizer *gestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    gestureRecognizer1.cancelsTouchesInView = NO;
    
    [self.attachementsTableView addGestureRecognizer:gestureRecognizer1];
    
    
    
}

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self TaskDetailAPI];
}

-(void) TaskDetailAPI
{
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    NSDictionary *params1 = @{@"id" : self.taskDict[@"id"]};
    [sharedObject taskDetail:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"My responseObject \n%@", responseObject);
         self.totalDict = (NSMutableDictionary *)responseObject;
         self.templatesArray = self.totalDict[@"templates"];
         self.openArray = [self.templatesArray valueForKey:@"Open"][0][0];
         
         self.commentsArray = responseObject[@"comments"];
         self.docsArray = responseObject[@"documents"];
         
         NSLog(@"%f", DEVICE_WIDTH);
         
         //         if ([responseObject[@"account"] isEqualToString:@"N/A"] || [responseObject[@"account"] isEqualToString:@""] )
         //         {
         //             self.assigneeLbl.text = responseObject[@"assigne"];
         //
         //         }else{
         //             self.assigneeLbl.text = [NSString stringWithFormat:@"%@ - %@",responseObject[@"account"],responseObject[@"assigne"]];
         //
         //         }
         
         self.assigneeLbl.text  = responseObject[@"owner"];
         
         
         if ([responseObject[@"owner"] isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"uname"]])
         {
             self.deleteBtn.hidden = NO;
         }else{
             self.deleteBtn.hidden = YES;
             
         }

         self.dueDateLbl.text =  [NSString stringWithFormat:@"Due Date: %@", responseObject[@"due_date"]];
         self.subjectTxtLbl.text =  responseObject[@"subject"];
         //         self.taskTypeValue.text =  responseObject[@"task_type_value"];
         
         NSString *urlStr = [NSString stringWithFormat:@"https:%@", responseObject[@"owner_image"]];
         NSURL *imageURL = [NSURL URLWithString:urlStr];
         
         self.mainImgView.layer.cornerRadius = self.mainImgView.frame.size.height/2;
         self.mainImgView.layer.masksToBounds = YES;
         
         [self.mainImgView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"avatar.png"]];
         
         
         self.ownerNameLbl.text = [NSString stringWithFormat:@"Recipient: %@", responseObject[@"assigne"]];
         
         
         
         CGFloat tableHeight1 = 0.0f;
         
         if (self.docsArray.count)
         {
             for (int i = 0; i < [self.docsArray count]; i ++) {
                 tableHeight1 += [self tableView:self.commentsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
             }
             self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, self.commentsTableView.frame.origin.y, self.commentsTableView.frame.size.width, tableHeight1);
             
             self.line1.frame = CGRectMake(self.line1.frame.origin.x, CGRectGetMaxY(self.commentsTableView.frame) + 15, self.line1.frame.size.width, self.line1.frame.size.height);
             
             self.line2.frame = CGRectMake(self.line2.frame.origin.x, CGRectGetMaxY(self.commentsTableView.frame) + 15, self.line2.frame.size.width, self.line2.frame.size.height);
             
             self.messageTxtLbl.frame = CGRectMake(self.messageTxtLbl.frame.origin.x, CGRectGetMaxY(self.commentsTableView.frame) + 5, self.messageTxtLbl.frame.size.width, self.messageTxtLbl.frame.size.height);
             
         }else{
             
             self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, self.commentsTableView.frame.origin.y, self.commentsTableView.frame.size.width, tableHeight1);
             
             self.line1.frame = CGRectMake(self.line1.frame.origin.x, CGRectGetMaxY(self.attachmentBtn.frame) + 10, self.line1.frame.size.width, self.line1.frame.size.height);
             
             self.line2.frame = CGRectMake(self.line2.frame.origin.x, CGRectGetMaxY(self.attachmentBtn.frame) + 10, self.line2.frame.size.width, self.line2.frame.size.height);
             
             self.messageTxtLbl.frame = CGRectMake(self.messageTxtLbl.frame.origin.x, CGRectGetMaxY(self.attachmentBtn.frame) -3, self.messageTxtLbl.frame.size.width, self.messageTxtLbl.frame.size.height);
             
         }
         
         
         
         
         
         if ([responseObject[@"status"] isEqualToString:@"Closed"])
         {
             [self.rightMarkLbl setEnabled:NO];
             [self.attachmentBtn setEnabled:NO];
             [self.commentTxtFld setHidden:YES];
             [self.deleteBtn setHidden:YES];
             [self.sendButton setHidden:YES];
             
             self.myScrolView.frame = CGRectMake(self.myScrolView.frame.origin.x, self.myScrolView.frame.origin.y, self.myScrolView.frame.size.width, self.myScrolView.frame.size.height + 50);
             
         }else if([responseObject[@"status"] isEqualToString:@"Review"])
         {
             [self.rightMarkLbl setEnabled:YES];
             [self.commentTxtFld setEditable:YES];
             [self.attachmentBtn setEnabled:YES];
             [self.deleteBtn setHidden:YES];
             [self.sendButton setEnabled:YES];
             
             //        [self.dotsBtn setEnabled:NO];
             
             
         }else{
             [self.rightMarkLbl setEnabled:YES];
             [self.attachmentBtn setEnabled:YES];
             [self.commentTxtFld setEditable:YES];
             [self.deleteBtn setEnabled:YES];
             
             //        [self.dotsBtn setEnabled:YES];
             
             
         }
         
         CGFloat tableHeight = 0.0f;
         for (int i = 0; i < [_commentsArray count]; i ++) {
             tableHeight += [self tableView:self.attachementsTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         self.attachementsTableView.frame = CGRectMake(self.attachementsTableView.frame.origin.x, CGRectGetMaxY(self.line1.frame)+ 10, self.attachementsTableView.frame.size.width, tableHeight);
         
         
         
         [self.myScrolView setContentSize:CGSizeMake(self.view.frame.size.width, (self.commentsTableView.frame.size.height + self.attachementsTableView.frame.size.height) + 270)];
         
         if (DEVICE_WIDTH == 320)
         {
             self.commentTxtFld.frame = CGRectMake(self.commentTxtFld.frame.origin.x, 440, self.commentTxtFld.frame.size.width, self.commentTxtFld.frame.size.height);
             self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.commentTxtFld.frame) + 3, self.sendButton.frame.origin.y, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
             
         }
         else if  (DEVICE_WIDTH == 414){
             
             self.commentTxtFld.frame = CGRectMake(self.commentTxtFld.frame.origin.x, self.commentTxtFld.frame.origin.y, self.commentTxtFld.frame.size.width, self.commentTxtFld.frame.size.height);
             self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.commentTxtFld.frame) + 5, self.sendButton.frame.origin.y, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
             
         }
         


         
         [self.commentsTableView reloadData];
         [self.attachementsTableView reloadData];
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dismissKeyboard:(id)sender
{
    [self.commentTxtFld resignFirstResponder];
    [self.view endEditing:YES];
}



#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.commentsTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

-(IBAction)settingsBtnPressed:(id)sender
{
    SettingsViewController *teamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:teamVC animated:YES];
}

-(IBAction)threeDotsBtnPressed:(id)sender
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"You are about to delete this task. Proceed?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //enter code here
        
        PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
        NSDictionary *params1 = @{@"task_id" : self.taskDict[@"id"]};
        [sharedObject deleteTask:params1 success:^(NSDictionary *responseObject)
         {
             [self.activityIndicator stopAnimating];
             NSLog(@"My responseObject \n%@", responseObject);
             
             if ([responseObject[@"status"] integerValue] == 200)
             {
                 
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
                     NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                     [userInfo setObject:[NSNumber numberWithInt:10] forKey:@"total"];
                     
                     NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                     [nc postNotificationName:@"SecVCPopped" object:self userInfo:userInfo];
                     
                     
                     [self.navigationController popViewControllerAnimated:YES];
                     
                     
                 }];
                 
                 
                 [alert addAction:defaultAction];
                 //Present action where needed
                 [self presentViewController:alert animated:YES completion:nil];
             }
             else
             {
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alert show];
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
    
    
    
    
    
}



#pragma mark UITextView methods

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
    if ([textView.text isEqualToString: @"Add Comment"])
    {
        textView.text = @"";
        
    }
    if ([textView.text isEqualToString: @"Add Comment"])
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
        textView.text = @"Add Comment";
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
        self.shiftForKeyboard = bottomEdge - 310;
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

#pragma mark UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.commentsTableView)
    {
        return self.docsArray.count;
        
    }
    else{
        return self.commentsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.commentsTableView)
    {
        NSMutableDictionary *dict = [self.docsArray objectAtIndex:indexPath.row];
        
        static NSString *cellIdentifier = @"commentsCellID";
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.commentsLbl.text = dict[@"file_name"];
        
        NSString *urlStr = [NSString stringWithFormat:@"https:%@", dict[@"aws_url"]];
        NSURL *imageURL = [NSURL URLWithString:urlStr];
        
        [cell.thumbImg setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ThumbPlaceHolder.png"]];
        
        
        
        return cell;
        
    }
    else{
        NSMutableDictionary *dict = [self.commentsArray objectAtIndex:indexPath.row];
        
        static NSString *cellIdentifier1 = @"commentsCellID1";
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        
        //        if ([dict[@"for"] isEqualToString:@"N/A"] || [dict[@"for"] isEqualToString:@""] ) {
        //            cell.commentsLbl.text = dict[@"comment_by"];
        //            cell.commentsLbl.textColor = [UIColor colorWithRed:92.0/255.0 green:181.0/255.0 blue:213.0/255.0 alpha:1.0];
        //        }else{
        //            cell.commentsLbl.text = dict[@"for"];
        //            cell.commentsLbl.textColor = [UIColor colorWithRed:138.0/255.0 green:30.0/255.0 blue:144.0/255.0 alpha:1.0];
        //
        //
        //        }
        cell.lbl.text = dict[@"tym"];
        
        cell.commentsLbl.text = dict[@"comment_by"];
        
        cell.lbl1.text = dict[@"comment"];
        
        
        if ([dict[@"comment"] isEqualToString:@"document_link"])
        {
            cell.lbl1.hidden = YES;
            
            cell.documentBtn.frame = CGRectMake(cell.documentBtn.frame.origin.x, cell.lbl1.frame.origin.y+4, cell.documentBtn.frame.size.width, cell.documentBtn.frame.size.height);
            
            
        }else{
            cell.lbl1.hidden = NO;
            cell.lbl1.text = dict[@"comment"];
            
        }
        
        
        CGRect rect = [cell.lbl1.text boundingRectWithSize:CGSizeMake(cell.lbl1.frame.size.width, CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: cell.lbl1.font}
                                                   context:nil];
        rect.size.width = ceil(rect.size.width);
        rect.size.height = ceil(rect.size.height);
        
        
        cell.lbl1.frame = CGRectMake(cell.lbl1.frame.origin.x, CGRectGetMaxY(cell.commentsLbl.frame) + 2, cell.lbl1.frame.size.width, rect.size.height);
        
        
        if ([dict[@"color"] isEqualToString:@"blue"])
        {
            cell.commentsLbl.textColor = [UIColor blackColor];
        }else{
            
            cell.commentsLbl.textColor = [UIColor colorWithRed:92.0/255.0 green:181.0/255.0 blue:213.0/255.0 alpha:1.0];
            
        }

        
        if ([self.totalDict[@"is_signed"] intValue] == 1)
        {
            [cell.documentBtn setTitle:@"Click here to View Document" forState:UIControlStateNormal];
            
            self.webViewStr = [NSString stringWithFormat:@"https:%@", [self.totalDict valueForKey:@"pdf"]];
            
            self.isFromPdfFile = YES;
        }else{
            
            
            [cell.documentBtn setTitle:@"Click here to Sign Document" forState:UIControlStateNormal];
            
            if ([self.totalDict[@"status"] isEqualToString:@"Review"])
            {
                [cell.documentBtn setTitle:@"Click here to View Document" forState:UIControlStateNormal];
                
            }
            
            self.webViewStr = self.totalDict[@"agreement"];
            self.isFromPdfFile = NO;
        }
        
        
        
        if ([dict[@"comment"] isEqualToString:@"document_link"])
        {
            cell.documentBtn.hidden = NO;
            
        }else{
            cell.documentBtn.hidden = YES;
            
        }
        
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellIdentifier1 = @"commentsCellID1";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    
    NSMutableDictionary *dict = [self.commentsArray objectAtIndex:indexPath.row];
    if (tableView == self.commentsTableView)
    {
        return 45;
    }else{
        if ([dict[@"comment"] isEqualToString:@"document_link"])
        {
            return 77;
            
        }
        else{
            cell.commentsLbl.text = dict[@"comment_by"];
            
            cell.lbl1.text = dict[@"comment"];
            
            
            
            CGRect rect = [cell.lbl1.text boundingRectWithSize:CGSizeMake(cell.lbl1.frame.size.width, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName: cell.lbl1.font}
                                                       context:nil];
            CGRect rect1 = [cell.lbl1.text boundingRectWithSize:CGSizeMake(cell.commentsLbl.frame.size.width, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: cell.commentsLbl.font}
                                                        context:nil];
            
            rect.size.width = ceil(rect.size.width);
            rect.size.height = ceil(rect.size.height);
            
            rect1.size.width = ceil(rect.size.width);
            rect1.size.height = ceil(rect.size.height);
            
            //            if (rect.size.height > 200)
            //            {
            //                return rect1.size.height + 30;
            //
            //            }
            //            else if (rect.size.height > 100)
            //            {
            //                return rect.size.height + rect1.size.height - 90;
            //
            //            }
            //            else if (rect.size.height > 89)
            //            {
            //                return rect.size.height + rect1.size.height - 50;
            //
            //            }else if (rect.size.height > 50)
            //            {
            //
            //                return rect.size.height + rect1.size.height - 20;
            //
            //            }
            //            else{
            //                return rect.size.height + rect1.size.height + 5;
            //
            //            }
            
            return rect1.size.height + 25;
            
            
        }
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSURL *url = [NSURL URLWithString:[[self.myArray valueForKey:@"aws_url"] objectAtIndex:indexPath.row]];
    if (tableView == self.commentsTableView)
    {
        NSString *newStr = [NSString stringWithFormat:@"https:%@", [[self.docsArray valueForKey:@"aws_url_origional"] objectAtIndex:indexPath.row]];
        
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
        
    }
    
    
    //    [[UIApplication sharedApplication] openURL:url];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(IBAction)uploadimage:(UIButton *)sender
{
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
    
    
    NSData* data = UIImageJPEGRepresentation(chosenImage, 0.4f);
    NSUInteger imageSize = [data length];
    
    NSLog(@"Size of Image(bytes):%lu",(unsigned long)[data length]);
    
    
    NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    //    NSString *jsonString = [[NSString alloc] initWithData:data
    //                                                 encoding:NSUTF8StringEncoding];
    
    
    if([base64 isEqual:[NSNull null]]||[base64 isEqualToString:@""]||([base64 length]<=0))
    {
        base64 = @"";
        
    }else{
        
    }
    //    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init]; [format setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *imageName = [NSString stringWithFormat:@"Image_%@.JPG", [format stringFromDate:now]];
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://liscioapistage.herokuapp.com/api/v1/documents"];  // enter your url to upload
    //    [sharedObject uploadImage:params1 selectImage:data success:^(NSDictionary *responseObject)
    
    if (self.isfromCamera)
    {
        [self.activityIndicator startAnimating];
        
        PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
        NSDictionary *params1 = @{@"task_id" : self.taskDict[@"id"],
                                  @"aws_url" : base64,
                                  @"file_name" : imageName};
        [sharedObject uploadImgeFromMobile:params1 success:^(NSDictionary *responseObject)
         {
             [self.activityIndicator stopAnimating];
             NSLog(@"My responseObject \n%@", responseObject);
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 if (DEVICE_WIDTH == 320)
                 {
                     self.commentTxtFld.frame = CGRectMake(self.commentTxtFld.frame.origin.x, self.commentTxtFld.frame.origin.y, self.commentTxtFld.frame.size.width, self.commentTxtFld.frame.size.height);
                     self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.commentTxtFld.frame) + 3, self.sendButton.frame.origin.y, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
                     
                 }
                 
                 [self TaskDetailAPI];
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
                     NSDictionary *params1 = @{@"task_id" : self.taskDict[@"id"],
                                               @"aws_url" : base64,
                                               @"file_name" : [[fileAsset defaultRepresentation] filename]};
                     [sharedObject uploadImgeFromMobile:params1 success:^(NSDictionary *responseObject)
                      {
                          [self.activityIndicator stopAnimating];
                          NSLog(@"My responseObject \n%@", responseObject);
                          
                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                          UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                              //enter code here
                              
                              if (DEVICE_WIDTH == 320)
                              {
                                  self.commentTxtFld.frame = CGRectMake(self.commentTxtFld.frame.origin.x, self.commentTxtFld.frame.origin.y, self.commentTxtFld.frame.size.width, self.commentTxtFld.frame.size.height);
                                  self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.commentTxtFld.frame) + 3, self.sendButton.frame.origin.y, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
                                  
                              }
                              
                              [self TaskDetailAPI];
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

-(IBAction)signInEngagementLetterBtnPressed:(id)sender
{
    if (self.isFromPdfFile)
    {
        if (self.webViewStr == nil || [self.webViewStr isEqual:[NSNull null]] || [self.webViewStr isEqualToString:@""])
        {
            return;
        }
        NSURL *url = [NSURL URLWithString:self.webViewStr];
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else{
        WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webVC.string = self.webViewStr;
        webVC.taskString = self.taskDict[@"id"];
        webVC.myDict = self.totalDict;
        //        webVC.reviewDict = self.ta;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
}

-(IBAction)rightMarkBtnPressed:(id)sender
{
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    NSDictionary *params1 = @{@"task_id" : self.taskDict[@"id"]};
    [sharedObject updateTaskStatus:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         NSLog(@"My responseObject \n%@", responseObject);
         
         if ([responseObject[@"status"] integerValue] == 200)
         {
             self.alerLbl.hidden = NO;
             
             int duration = 3; // duration in seconds
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                 
                 self.alerLbl.hidden = YES;
                 
                 NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
                 [userInfo setObject:[NSNumber numberWithInt:10] forKey:@"total"];
                 
                 NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                 [nc postNotificationName:@"SecVCPopped" object:self userInfo:userInfo];
                 
                 [self.navigationController popViewControllerAnimated:YES];
                 
                 
             });
         }else{
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 if (DEVICE_WIDTH == 320)
                 {
                     self.commentTxtFld.frame = CGRectMake(self.commentTxtFld.frame.origin.x, self.commentTxtFld.frame.origin.y, self.commentTxtFld.frame.size.width, self.commentTxtFld.frame.size.height);
                     self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.commentTxtFld.frame) + 3, self.sendButton.frame.origin.y, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
                     
                 }
                 [self TaskDetailAPI];
             }];
             [alert addAction:defaultAction];
             //Present action where needed
             [self presentViewController:alert animated:YES completion:nil];
             
         }
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self.activityIndicator stopAnimating];
     }];
    
    
}

-(IBAction)sendCommmentBtnPressed:(id)sender
{
    if ([self.commentTxtFld.text isEqualToString:@""] || [self.commentTxtFld.text isEqualToString:@"Add Comment"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Comment field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
        
    }
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    NSDictionary *params1 = @{@"task_id" : self.taskDict[@"id"],
                              @"comment" : self.commentTxtFld.text};
    [sharedObject addComment:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         if ([responseObject[@"status"] integerValue] == 200)
         {
             [self.commentTxtFld resignFirstResponder];
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 self.commentTxtFld.text = @"Add Comment";
                 self.attachementsTableView.frame = CGRectMake(self.attachementsTableView.frame.origin.x, CGRectGetMaxY(self.line2.frame) + 15, self.attachementsTableView.frame.size.width, self.attachementsTableView.frame.size.height - 60);
                 
                 
                 if (DEVICE_WIDTH == 320)
                 {
                     self.commentTxtFld.frame = CGRectMake(self.commentTxtFld.frame.origin.x, self.commentTxtFld.frame.origin.y, self.commentTxtFld.frame.size.width, self.commentTxtFld.frame.size.height);
                     self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.commentTxtFld.frame) + 3, self.sendButton.frame.origin.y, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
                     
                 }
                 
                 
                 [self TaskDetailAPI];
                 
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
     }];
    
}

-(IBAction)delAttachementBtnPressed:(id)sender
{
    
    if ([self.taskDict[@"status"] isEqualToString:@"Closed"])
    {
        return;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure want to delete the Attachment" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //enter code here
        CommentsTableViewCell *eventCell= (CommentsTableViewCell *)[[sender superview] superview];
        NSIndexPath *indexPath = (NSIndexPath *)[self.commentsTableView indexPathForCell:eventCell];
        NSLog(@"indepath is %@", indexPath);
        
        NSMutableDictionary *dict = [self.docsArray objectAtIndex:indexPath.row];
        NSString *mystr  = [dict[@"id"] stringValue];
        [self.activityIndicator startAnimating];
        
        if (mystr == nil || [mystr isEqual:[NSNull null]] || [mystr isEqualToString:@""])
        {
            mystr= @"";
            return;
        }
        
        PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
        NSDictionary *params1 = @{@"task_id" : self.taskDict[@"id"],
                                  @"id" : mystr,
                                  @"comment_id" : @""};
        [sharedObject deletingImgeFromMobile:params1 success:^(NSDictionary *responseObject)
         {
             [self.activityIndicator stopAnimating];
             NSLog(@"My responseObject \n%@", responseObject);
             
             if ([responseObject[@"status"] integerValue] == 200)
             {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
                     if (DEVICE_WIDTH == 320)
                     {
                         self.commentTxtFld.frame = CGRectMake(self.commentTxtFld.frame.origin.x, self.commentTxtFld.frame.origin.y, self.commentTxtFld.frame.size.width, self.commentTxtFld.frame.size.height);
                         self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.commentTxtFld.frame) + 3, self.sendButton.frame.origin.y, self.sendButton.frame.size.width, self.sendButton.frame.size.height);
                         
                     }
                     
                     
                     [self TaskDetailAPI];
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
    
    
    
    
}

@end
