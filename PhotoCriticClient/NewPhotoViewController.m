//
//  NewPhotoViewController.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 1/27/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "NewPhotoViewController.h"
#import "AppDelegate.h"

@interface NewPhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UILabel *submittedMessage;

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
    self.submitButton.hidden = YES;
    self.submittedMessage.hidden = YES;
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

- (IBAction)takePicture:(id)sender {
    self.submittedMessage.hidden = YES;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.imageView.image = image;
    self.submitButton.hidden = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submit:(id)sender {
    
    UIView *mask = [[UIView alloc] initWithFrame:self.view.frame];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.frame = self.view.frame;
    
    [indicator startAnimating];
    
    [mask addSubview:indicator];
    
    [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.78]];
    
    [self.view addSubview:mask];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
//
//    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *requestString = [NSString stringWithFormat:@"http://localhost:3000/api/v1/photos?user_email=%@&user_token=%@", [app.authInfo objectForKey:@"email"], [app.authInfo objectForKey:@"authentication_token"]];
//    NSURL *url = [NSURL URLWithString:requestString];
//
//    [request setURL:url];
//    
//    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setHTTPBody:imageData];
    
    // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    [_params setObject:@"1.0" forKey:@"ver"];
    [_params setObject:@"en" forKey:@"lan"];
    [_params setObject:@"new image" forKey:@"title"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"photo[pic]";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSString *requestString = [NSString stringWithFormat:@"http://localhost:3000/api/v1/photos?user_email=%@&user_token=%@", [app.authInfo objectForKey:@"email"], [app.authInfo objectForKey:@"authentication_token"]];
    NSURL *requestURL = [NSURL URLWithString:requestString];

    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSURLSessionDataTask *dataTask = [app.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", data);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = nil;
            self.submittedMessage.hidden = NO;
            self.submitButton.hidden = YES;
            [mask removeFromSuperview];
        });

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
