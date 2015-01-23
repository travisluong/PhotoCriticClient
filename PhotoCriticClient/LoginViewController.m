//
//  LoginViewController.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 1/21/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "LoginViewController.h"

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
    NSLog(@"%@, %@", self.username.text, self.password.text);
    NSString *requestString = @"http://localhost:3000/api/v1/sessions/create.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    NSString *jsonString = [NSString stringWithFormat:@"{\"user\": {\"email\": \"%@\", \"password\": \"%@\"} }", self.username.text, self.password.text];
    NSLog(@"%@", jsonString);
    NSData *postData = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [req setHTTPBody: postData];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", json);
    }];
    
    [dataTask resume];
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
