//
//  TeamDetailTableViewCell.h
//  Liscio
//
//  Created by Anilabs - Venki on 4/20/17.
//  Copyright © 2017 anilabsinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *mailBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@end
