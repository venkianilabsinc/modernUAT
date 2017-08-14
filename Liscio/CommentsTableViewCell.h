//
//  CommentsTableViewCell.h
//  Liscio
//
//  Created by Anilabs Inc on 30/03/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentsLbl;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;


@property (weak, nonatomic) IBOutlet UILabel *lbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UIButton *documentBtn;

@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@end
