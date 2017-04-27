//
//  TaskDetailViewController.h
//  Liscio
//
//  Created by Anilabs Inc on 27/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableDictionary *taskDict;

@end
