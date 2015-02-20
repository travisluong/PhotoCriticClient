//
//  PhotoDetailViewController.h
//  PhotoCriticClient
//
//  Created by Travis Luong on 2/2/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController
@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) UIImage *uiimage;
@property (strong, nonatomic) IBOutlet UILabel *critiqueLabel;
@property (strong, nonatomic) NSString *critique;
@end
