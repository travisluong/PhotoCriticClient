//
//  NewPhotoViewController.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 1/27/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "NewPhotoViewController.h"

@interface NewPhotoViewController ()

@end

@implementation NewPhotoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"New Photo";
        
        UIImage *i = [UIImage imageNamed:@"camera-32"];
        self.tabBarItem.image = i;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
