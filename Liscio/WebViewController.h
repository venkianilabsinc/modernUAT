//
//  WebViewController.h
//  Liscio
//
//  Created by Anilabs - Venki on 4/11/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) NSString *string;
@property (strong, nonatomic) NSString *taskString;
@property BOOL isfromPdf;
@property (strong, nonatomic) NSMutableDictionary *myDict;
@property (strong, nonatomic) NSMutableDictionary *reviewDict;

@end
