//
//  PhotoTableViewCell.h
//  PhotoCriticClient
//
//  Created by Travis Luong on 1/30/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@end
