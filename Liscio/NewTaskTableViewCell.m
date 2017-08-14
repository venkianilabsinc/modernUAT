//
//  NewTaskTableViewCell.m
//  ModernAdvisors
//
//  Created by Anilabs - Venki on 5/17/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "NewTaskTableViewCell.h"

@implementation NewTaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.thumbImgView.layer.borderWidth = 1.0;
    self.thumbImgView.layer.borderColor = [[UIColor colorWithRed:81.0/255.0 green:122.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor];

    [self.delBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.delBtn setTitle:[NSString stringWithUTF8String:"\uE815"] forState:UIControlStateNormal];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
