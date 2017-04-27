//
//  NewTasksViewController.h
//  Liscio
//
//  Created by Anilabs Inc on 26/01/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface NewTasksViewController : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;


}
@end
