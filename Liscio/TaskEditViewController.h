//
//  TaskEditViewController.h
//  Liscio
//
//  Created by Anilabs Inc on 04/04/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface TaskEditViewController : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;

}

@property (strong, nonatomic) NSMutableDictionary *editDict;

@end
