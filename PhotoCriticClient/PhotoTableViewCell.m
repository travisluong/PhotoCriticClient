//
//  PhotoTableViewCell.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 1/30/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "PhotoTableViewCell.h"

@implementation PhotoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showImage:(id)sender {
    NSLog(@"showing image");
}

@end
