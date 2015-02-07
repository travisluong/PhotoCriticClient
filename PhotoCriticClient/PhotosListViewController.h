//
//  PhotosListViewController.h
//  PhotoCriticClient
//
//  Created by Travis Luong on 2/5/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSDictionary *authInfo;
@property (nonatomic) NSURLSession *session;
@end
