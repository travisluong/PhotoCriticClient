//
//  ProgressViewController.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 2/20/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "ProgressViewController.h"

@interface ProgressViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.activityIndicator.center = [self.view convertPoint:self.view.center fromView:self.view.superview];
    
    [self.activityIndicator startAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.activityIndicator stopAnimating];
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
