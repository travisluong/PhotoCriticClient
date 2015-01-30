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
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(navigateToMainScreen) name:@"loginSuccess" object:nil];
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
    NSDictionary *userDict = @{@"user": @{@"email": self.username.text, @"password": self.password.text}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:nil];
    [req setHTTPBody: jsonData];
    [req addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req addValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *auth_token = [jsonObject objectForKey:@"authentication_token"];
        NSString *user_email = [[jsonObject objectForKey:@"user"] objectForKey:@"email"];
        NSLog(@"%@", user_email);
        NSLog(@"%@", auth_token);
        NSLog(@"%@", jsonObject);
        NSLog(@"completionHandlerFinished");
        
        NSDictionary *authInfo = @{@"email": user_email, @"authentication_token": auth_token};
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            app.authInfo = authInfo;
            [app setRoots];
        });
        
    }];

    [dataTask resume];
    NSLog(@"signInFinished");
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
