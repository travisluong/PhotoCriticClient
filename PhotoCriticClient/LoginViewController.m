//
//  LoginViewController.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 1/21/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "LoginViewController.h"
#import "NewPhotoViewController.h"
#import "PhotosTableViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (nonatomic) NSURLSession *session;
@end

@implementation LoginViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
        
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

- (IBAction)signIn:(id)sender {
    NSString *requestString = @"http://localhost:3000/api/v1/sessions/create.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
//    NSDictionary *userDict = @{@"user": @{@"email": self.username.text, @"password": self.password.text}};
    NSDictionary *userDict = @{@"user": @{@"email": @"test@example.com", @"password": @"password"}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:nil];
    [req setHTTPBody: jsonData];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *auth_token = [jsonObject objectForKey:@"authentication_token"];
            NSString *user_email = [[jsonObject objectForKey:@"user"] objectForKey:@"email"];
            
            NSDictionary *authInfo = @{@"email": user_email, @"authentication_token": auth_token};
            
            dispatch_async(dispatch_get_main_queue(), ^{
                AppDelegate *app = [UIApplication sharedApplication].delegate;
                app.authInfo = authInfo;
                app.session = self.session;
                [app setRoots];
            });
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was an error." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            
            [alert addAction:defaultAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

    [dataTask resume];
}

- (IBAction)signUpClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://photocritic.herokuapp.com/users/sign_up"]];
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
