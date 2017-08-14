//
//  CommentsTableViewCell.m
//  Liscio
//
//  Created by Anilabs Inc on 30/03/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import "CommentsTableViewCell.h"

@implementation CommentsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

    self.thumbImg.layer.borderWidth = 1.0;
    self.thumbImg.layer.borderColor = [[UIColor colorWithRed:81.0/255.0 green:122.0/255.0 blue:172.0/255.0 alpha:1.0] CGColor];
    
    
    [self.delBtn.titleLabel setFont:[UIFont fontWithName:@"liscio" size:25]];
    [self.delBtn setTitle:[NSString stringWithUTF8String:"\uE815"] forState:UIControlStateNormal];


    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
