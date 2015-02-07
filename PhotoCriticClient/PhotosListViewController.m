//
//  PhotosListViewController.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 2/5/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "PhotosListViewController.h"
#import "PhotoTableViewCell.h"
#import "PhotoDetailViewController.h"

@interface PhotosListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *photosTable;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic) int page;
@end

@implementation PhotosListViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"My Photos";
        
        UIImage *i = [UIImage imageNamed:@"stack_of_photos-32"];
        self.tabBarItem.image = i;
        self.page = 1;
        self.photos = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil];
    [self.photosTable registerNib:nib forCellReuseIdentifier:@"PhotoTableViewCell"];
    self.photosTable.delegate = self;
    self.photosTable.dataSource = self;
    self.photosTable.layer.borderWidth = 2.0f;
    self.photosTable.layer.borderColor = [UIColor blackColor].CGColor;
    [self fetchPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.photos count];
}

- (void)fetchPhotos {
    NSLog(@"Fetching Photos");
    NSString *requestString = [NSString stringWithFormat:@"http://localhost:3000/api/v1/photos?user_email=%@&user_token=%@&page=%d", [self.authInfo objectForKey:@"email"], [self.authInfo objectForKey:@"authentication_token"], self.page];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([self.photos count] == 0) {
            self.photos = jsonObject[@"photos"];
        } else {
            NSArray *newArray = [self.photos arrayByAddingObjectsFromArray:jsonObject[@"photos"]];
            self.photos = newArray;
        }
        //        [self.photos addObjectsFromArray:jsonObject[@"photos"]];
        
        //        self.photos = jsonObject[@"photos"];
//        NSLog(@"%@", [jsonObject[@"photos"] class]);
        NSLog(@"%@", self.photos);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photosTable reloadData];
        });
    }];
    [dataTask resume];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    static NSString *MyIdentifier = @"PhotoTableViewCell";
    
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
//    if (cell == nil) {
//        cell = [[PhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
//    }
    
    // Configure the cell...
    NSDictionary *photo = self.photos[indexPath.row];
    cell.titleLabel.text = photo[@"title"];
    if (photo[@"thumbnail"] != [NSNull null]) {
        NSURL *url = [NSURL URLWithString:photo[@"thumbnail"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        cell.thumbnailView.image = img;
    }
    if (photo[@"critique"] != [NSNull null]) {
        cell.critiqueLabel.text = photo[@"critique"];
    }
    cell.actionBlock = ^{
        NSLog(@"showing image for ...");
        PhotoDetailViewController *pdvc = [[PhotoDetailViewController alloc] init];
        if (photo[@"medium"] != [NSNull null]) {
            NSURL *url = [NSURL URLWithString:photo[@"medium"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            pdvc.uiimage = img;
        }
        if (photo[@"critique"] != [NSNull null]) {
            NSLog(@"setting critique");
            pdvc.critique = photo[@"critique"];
        }
        [self presentViewController:pdvc animated:YES completion:^{
            
        }];
    };
    return cell;
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
