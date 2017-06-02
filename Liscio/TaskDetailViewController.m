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
#define isiPhone5Device (DEVICE_HEIGHT == 568) ? YES : NO

@property (weak, nonatomic) IBOutlet UIButton *settingBtn;
@property (weak, nonatomic) IBOutlet UIButton *dotsBtn;
@property (weak, nonatomic) IBOutlet UIButton *attachmentBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightMarkLbl;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *calenderLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property CGFloat shiftForKeyboard;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *dateTxtLbl;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *subjectTxtLbl;
@property (strong, nonatomic) NSMutableDictionary *openArray;
@property (strong, nonatomic) NSMutableArray *templatesArray;
@property (strong, nonatomic) NSMutableDictionary *totalDict;
@property (weak, nonatomic) IBOutlet UITextField *commentTxtFld;
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (strong, nonatomic) NSMutableArray *docsArray;
@property (strong, nonatomic) NSString *webViewStr;
@property (weak, nonatomic) IBOutlet UIButton *documentBtn;
@property (strong, nonatomic) NSMutableArray *myArray;

@property (strong, nonatomic) NSString *pdfStr;

@property BOOL isFromPdfFile;


@property (weak, nonatomic) IBOutlet UIView *alerLbl;


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
    }else{
        [self.rightMarkLbl setEnabled:YES];
        
    }

    // Do any additional setup after loading the view.
    [self.settingBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:25]];
    [self.settingBtn setTitle:[NSString stringWithUTF8String:"\uE626"] forState:UIControlStateNormal];
    
    [self.dotsBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    [self.dotsBtn setTitle:[NSString stringWithUTF8String:"\uE75B"] forState:UIControlStateNormal];

    [self.attachmentBtn.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:20]];
    [self.attachmentBtn setTitle:[NSString stringWithUTF8String:"\uE92E"] forState:UIControlStateNormal];

    [self.rightMarkLbl.titleLabel setFont:[UIFont fontWithName:@"icomoon" size:30]];
    [self.rightMarkLbl setTitle:[NSString stringWithUTF8String:"\uE92F"]forState:UIControlStateNormal];
    
    self.firstName.layer.cornerRadius = self.firstName.frame.size.height/2;
    self.firstName.layer.masksToBounds = YES;
    
    self.lastName.layer.cornerRadius = self.lastName.frame.size.height/2;
    self.lastName.layer.masksToBounds = YES;

    self.attachmentBtn.layer.borderWidth = 1;
    self.attachmentBtn.layer.borderColor = [[UIColor colorWithRed:138/255.0 green:30/255.0 blue:144/255.0 alpha:1.0] CGColor];
    self.attachmentBtn.layer.cornerRadius = self.attachmentBtn.frame.size.height/2;
    self.attachmentBtn.layer.masksToBounds = YES;
    
    self.dotsBtn.layer.borderWidth = 1;
    self.dotsBtn.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.dotsBtn.layer.cornerRadius = self.dotsBtn.frame.size.height/2;
    self.dotsBtn.layer.masksToBounds = YES;
    
    [self.calenderLbl setFont:[UIFont fontWithName:@"icomoon" size:18]];
    [self.calenderLbl setText:[NSString stringWithUTF8String:"\uE93E"]];

    self.commentsTableView.allowsMultipleSelectionDuringEditing = NO;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.commentTxtFld.leftView = paddingView;
    self.commentTxtFld.leftViewMode = UITextFieldViewModeAlways;

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
    
    
//    NSLog(@"%f", [[UIScreen mainScreen] bounds].size.width);

//            self.commentsTableView.backgroundColor = [UIColor redColor];


    
//    [self.parentViewController.tabBarController setSelectedIndex:1];
    
}

-(void) viewWillAppear:(BOOL)animated
{
//    
//    if ([[UIScreen mainScreen] bounds].size.width == 320)
//    {
//        NSLog(@"iphone 5");
//        self.subjectTxtLbl.frame = CGRectMake(self.subjectTxtLbl.frame.origin.x, self.subjectTxtLbl.frame.origin.y,260, self.subjectTxtLbl.frame.size.height);
//        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, self.commentsTableView.frame.origin.y,self.commentsTableView.frame.size.width, 150);
//        
//    } else if ([[UIScreen mainScreen] bounds].size.width == 375)
//    {
//        NSLog(@"iphone 6");
//        self.subjectTxtLbl.frame = CGRectMake(self.subjectTxtLbl.frame.origin.x, self.subjectTxtLbl.frame.origin.y,260, self.subjectTxtLbl.frame.size.height);
//        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, self.commentsTableView.frame.origin.y,self.commentsTableView.frame.size.width, 229);
//        
//    }
//    else{
//        self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, self.commentsTableView.frame.origin.y,self.commentsTableView.frame.size.width, 320);
//        
//    }
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
         
         if ([responseObject[@"is_signed"] intValue] == 1)
         {
             [self.documentBtn setTitle:@"Click here to View Document" forState:UIControlStateNormal];
             
             self.webViewStr = [NSString stringWithFormat:@"https:%@", [responseObject valueForKey:@"pdf"]];
             
             self.isFromPdfFile = YES;
         }else{
             [self.documentBtn setTitle:@"Click here to Sign Document" forState:UIControlStateNormal];

             self.webViewStr = responseObject[@"agreement"];
             self.isFromPdfFile = NO;


         }
         if (self.webViewStr == nil || [self.webViewStr isEqual:[NSNull null]])
         {
             self.documentBtn.hidden = YES;
             
             if ([[UIScreen mainScreen] bounds].size.width == 320)
             {
                 NSLog(@"iphone 5");
                 self.subjectTxtLbl.frame = CGRectMake(self.subjectTxtLbl.frame.origin.x, self.subjectTxtLbl.frame.origin.y,260, self.subjectTxtLbl.frame.size.height);
                 self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.attachmentBtn.frame) +5 ,self.commentsTableView.frame.size.width, 190);
                 
             } else if ([[UIScreen mainScreen] bounds].size.width == 375)
             {
                 NSLog(@"iphone 6");
                 self.subjectTxtLbl.frame = CGRectMake(self.subjectTxtLbl.frame.origin.x, self.subjectTxtLbl.frame.origin.y,260, self.subjectTxtLbl.frame.size.height);
                 self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.attachmentBtn.frame) +5,self.commentsTableView.frame.size.width, 275);
                 
             }
             else{
                 self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.attachmentBtn.frame) +5,self.commentsTableView.frame.size.width, 360);
                 
             }

             
             
         }else{
             self.documentBtn.hidden = NO;
             
             if ([[UIScreen mainScreen] bounds].size.width == 320)
             {
                 NSLog(@"iphone 5");
                 self.subjectTxtLbl.frame = CGRectMake(self.subjectTxtLbl.frame.origin.x, self.subjectTxtLbl.frame.origin.y,260, self.subjectTxtLbl.frame.size.height);
                 self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.documentBtn.frame) +5 ,self.commentsTableView.frame.size.width, 155);
                 
             } else if ([[UIScreen mainScreen] bounds].size.width == 375)
             {
                 NSLog(@"iphone 6");
                 self.subjectTxtLbl.frame = CGRectMake(self.subjectTxtLbl.frame.origin.x, self.subjectTxtLbl.frame.origin.y,260, self.subjectTxtLbl.frame.size.height);
                 self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.documentBtn.frame) +5,self.commentsTableView.frame.size.width, 235);
                 
             }
             else{
                 self.commentsTableView.frame = CGRectMake(self.commentsTableView.frame.origin.x, CGRectGetMaxY(self.documentBtn.frame) +5,self.commentsTableView.frame.size.width, 325);
                 
             }

             
         }


         
         
         self.myArray = (NSMutableArray *)[self.docsArray arrayByAddingObjectsFromArray:self.commentsArray];

         
             self.name.text = responseObject[@"assigne"];
             self.accountName.text =  responseObject[@"account"];
             self.dateTxtLbl.text =  responseObject[@"due_date"];
             self.subjectTxtLbl.text =  responseObject[@"subject"];
         
             self.ownerNameLbl.text = [NSString stringWithFormat:@"Owner: %@", responseObject[@"owner"]];
         
         NSMutableString * firstCharacters = [NSMutableString string];
         NSArray * words = [responseObject[@"assigne"]  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         for (NSString * word in words) {
             if ([word length] > 0) {
                 NSString * firstLetter = [word substringToIndex:1];
                 [firstCharacters appendString:[firstLetter uppercaseString]];
             }
         }
         
         
         NSMutableString * firstCharacters1 = [NSMutableString string];
         NSArray * words1 = [responseObject[@"account"]  componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         for (NSString * word in words1) {
             if ([word length] > 0) {
                 NSString * firstLetter = [word substringToIndex:1];
                 [firstCharacters1 appendString:[firstLetter uppercaseString]];
             }
         }


         self.firstName.text =   firstCharacters;
         self.lastName.text =  firstCharacters1;


             [self.commentsTableView reloadData];


         
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
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* online = [UIAlertAction
                             actionWithTitle:@"EDIT"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 TaskEditViewController *taskEditVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskEditViewController"];
                                 
                                 NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
                                 for (NSString * key in [self.totalDict allKeys])
                                 {
                                     if (![[self.totalDict objectForKey:key] isKindOfClass:[NSNull class]])
                                         [prunedDictionary setObject:[self.totalDict objectForKey:key] forKey:key];
                                 }
                                 
                                 NSLog(@"pruned dictis\n%@", prunedDictionary);
                                 
                                 taskEditVC.editDict = prunedDictionary;
                                 [self.navigationController pushViewController:taskEditVC animated:YES];
                                 
                                 
                                 //Do some thing here
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    UIAlertAction* offline = [UIAlertAction
                              actionWithTitle:@"DELETE"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
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
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"CANCEL"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                                 //Do some thing here
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];

    
    [view addAction:online];
    [view addAction:offline];
    [view addAction:cancel];

    [self presentViewController:view animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if ([self.commentTxtFld.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Comment field is empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

        return YES;
    }
    [self.activityIndicator startAnimating];
    
    PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
    NSDictionary *params1 = @{@"task_id" : self.taskDict[@"id"],
                              @"comment" : self.commentTxtFld.text};
    [sharedObject addComment:params1 success:^(NSDictionary *responseObject)
     {
         [self.activityIndicator stopAnimating];
         if([responseObject[@"message"] isEqualToString:@"Comment was successfully added."])
         {
             [textField resignFirstResponder];
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
                 self.commentTxtFld.text = @"";
                 [self TaskDetailAPI];
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
     }];

    
    return YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    if (bottomEdge >= 260) {//250
        CGRect viewFrame = self.view.frame;
        self.shiftForKeyboard = bottomEdge - 285;
        if(!isiPhone5Device)
        {
            self.shiftForKeyboard = bottomEdge - 450;
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

#pragma mark UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return self.myArray.count;
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [self.myArray objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"commentsCellID";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *myStr = [[self.myArray valueForKey:@"comment"] objectAtIndex:indexPath.row];
    NSString *myStr5 = [[self.myArray valueForKey:@"file_name"] objectAtIndex:indexPath.row];

    NSString *myStr3 = [[self.myArray valueForKey:@"tym"] objectAtIndex:indexPath.row];
    if (myStr3 == nil || [myStr3 isEqual:[NSNull null]])
    {
        myStr3 = @"";
    }

    
    NSString *myStr1 = [NSString stringWithFormat:@" on %@",myStr3 ];

    if (myStr1 == nil || [myStr1 isEqual:[NSNull null]])
    {
       myStr1 = @"";
    }
    if (myStr == nil || [myStr isEqual:[NSNull null]])
    {
        myStr = @"Image";
    }

    NSString *myStr2 = [NSString stringWithFormat:@"%@%@", myStr, myStr1];

    
    if ([myStr2 isEqualToString:@"Image on "])
    {
        cell.commentsLbl.frame = CGRectMake(cell.commentsLbl.frame.origin.x, 2, cell.commentsLbl.frame.size.width, cell.commentsLbl.frame.size.height);

        cell.thumbImg.hidden = NO;
        
        NSString *urlStr = [NSString stringWithFormat:@"https:%@", dict[@"aws_url"]];
        NSURL *imageURL = [NSURL URLWithString:urlStr];
       // NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
       // UIImage *image = [UIImage imageWithData:imageData];
        //cell.imageView.image = image;
        
        [cell.thumbImg setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ThumbPlaceHolder.png"]];
//        myStr2 = @"Click to view Attached Image";
        myStr2 = [NSString stringWithFormat:@"Click to view %@", myStr5];
    }else{
        
        cell.commentsLbl.frame = CGRectMake(cell.commentsLbl.frame.origin.x, 5, cell.commentsLbl.frame.size.width, cell.commentsLbl.frame.size.height);
        cell.thumbImg.hidden = YES;

    }
    cell.commentsLbl.text = myStr2;
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSURL *url = [NSURL URLWithString:[[self.myArray valueForKey:@"aws_url"] objectAtIndex:indexPath.row]];
    NSString *newStr = [NSString stringWithFormat:@"https:%@", [[self.myArray valueForKey:@"aws_url_origional"] objectAtIndex:indexPath.row]];

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *myStr = [[self.myArray valueForKey:@"comment"] objectAtIndex:indexPath.row];
    NSString *myStr5 = [[self.myArray valueForKey:@"file_name"] objectAtIndex:indexPath.row];
    
    NSString *myStr3 = [[self.myArray valueForKey:@"tym"] objectAtIndex:indexPath.row];
    if (myStr3 == nil || [myStr3 isEqual:[NSNull null]])
    {
        myStr3 = @"";
    }
    
    
    NSString *myStr1 = [NSString stringWithFormat:@" on %@",myStr3 ];
    
    if (myStr1 == nil || [myStr1 isEqual:[NSNull null]])
    {
        myStr1 = @"";
    }
    if (myStr == nil || [myStr isEqual:[NSNull null]])
    {
        myStr = @"Image";
    }
    
    NSString *myStr2 = [NSString stringWithFormat:@"%@%@", myStr, myStr1];
    
    
    if ([myStr2 isEqualToString:@"Image on "])
    {
        return 100.0f;
 
        
    }else{
        return 47.0f;
    }
    return 47.0f;
}

# pragma mark - Cell Setup


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    NSMutableDictionary *dict = [self.myArray objectAtIndex:indexPath.row];
    NSString *mystr1  = dict[@"aws_url_origional"];

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
    NSMutableDictionary *dict = [self.myArray objectAtIndex:indexPath.row];
    NSString *mystr1  = dict[@"aws_url_origional"];
    if (mystr1 == nil || [mystr1 isEqual:[NSNull null]] || [mystr1 isEqualToString:@""])
    {
        [self.commentsTableView reloadData];
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //add code here for when you hit delete
        NSMutableDictionary *dict = [self.myArray objectAtIndex:indexPath.row];
        NSString *mystr  = [dict[@"id"] stringValue];
        [self.activityIndicator startAnimating];
        
        if (mystr == nil || [mystr isEqual:[NSNull null]] || [mystr isEqualToString:@""])
        {
            mystr= @"";
            return;
        }
        
        PortfolioHttpClient *sharedObject = [PortfolioHttpClient portfolioSharedHttpClient];
        NSDictionary *params1 = @{@"task_id" : self.taskDict[@"id"],
                                  @"id" : mystr};
        [sharedObject deletingImgeFromMobile:params1 success:^(NSDictionary *responseObject)
         {
             [self.activityIndicator stopAnimating];
             NSLog(@"My responseObject \n%@", responseObject);
             
             if ([responseObject[@"status"] integerValue] == 200)
             {
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                     //enter code here
                     
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
  }
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
             
             [self TaskDetailAPI];
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
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }

        
    }else{
        WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webVC.string = self.webViewStr;
        webVC.taskString = self.taskDict[@"id"];
        webVC.myDict = self.totalDict;
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
             self.firstName.hidden = YES;
             self.dateTxtLbl.hidden = YES;
             self.name.hidden = YES;
             self.calenderLbl.hidden = YES;
             self.alerLbl.hidden = NO;
             
             int duration = 3; // duration in seconds
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                 
                 self.alerLbl.hidden = YES;
                 
                 if (self.navigationController.tabBarController.selectedIndex == 1)
                 {
                     [self.navigationController.tabBarController setSelectedIndex:0];
                     
                 }else{
                     [self.navigationController.tabBarController setSelectedIndex:1];
                     
                 }
                 
                 self.firstName.hidden = NO;
                 self.dateTxtLbl.hidden = NO;
                 self.name.hidden = NO;
                 self.calenderLbl.hidden = NO;
                 
                 
                 
             });
             
             /* UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
              //enter code here
              
              if (self.navigationController.tabBarController.selectedIndex == 1)
              {
              [self.navigationController.tabBarController setSelectedIndex:0];
              
              }else{
              [self.navigationController.tabBarController setSelectedIndex:1];
              
              }
              
              }];
              [alert addAction:defaultAction];
              //Present action where needed
              [self presentViewController:alert animated:YES completion:nil];*/
             
         }else{
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                 //enter code here
                 
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
@end
