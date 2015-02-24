//
//  SettingsViewController.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 2/23/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"Settings";
        
        UIImage *i = [UIImage imageNamed:@"Settings-32"];
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

- (IBAction)logout:(id)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.authInfo = nil;
    LoginViewController *lvc = [[LoginViewController alloc] init];
    
    app.window.rootViewController = lvc;
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
