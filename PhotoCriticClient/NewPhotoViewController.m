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

- (IBAction)buttonClicked:(id)sender {
    UIAlertController *avc = [[UIAlertController alloc] init];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"foo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"action handler");
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"bar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"action handler");
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"baz" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"action handler");
    }];
    
    [avc addAction:action];
    [avc addAction:action2];
    [avc addAction:action3];
    
    [self presentViewController:avc animated:YES completion:nil];
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
