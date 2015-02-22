//
//  PhotosTableViewController.m
//  PhotoCriticClient
//
//  Created by Travis Luong on 1/27/15.
//  Copyright (c) 2015 Travis Luong. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "PhotoTableViewCell.h"
#import "PhotoDetailViewController.h"
#import "ProgressViewController.h"

@interface PhotosTableViewController () <UIPopoverControllerDelegate>
@property (nonatomic, strong) UIPopoverController *imagePopover;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic) BOOL isLoading;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *loadMoreButton;
@property (nonatomic) int page;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) NSNumber *total;
@end

@implementation PhotosTableViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"My Photos";
        
        UIImage *i = [UIImage imageNamed:@"stack_of_photos-32"];
        self.tabBarItem.image = i;
        self.isLoading = NO;
        self.page = 1;
        self.photos = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)fetchPhotos {
    
    ProgressViewController *pvc = [[ProgressViewController alloc] init];

    [self.view addSubview:pvc.view];

    pvc.view.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    
    if (self.page > 1) {
        self.backButton.hidden = NO;
    } else {
        self.backButton.hidden = YES;
    }
    
    NSString *requestString = [NSString stringWithFormat:@"http://localhost:3000/api/v1/photos?user_email=%@&user_token=%@&page=%d", [self.authInfo objectForKey:@"email"], [self.authInfo objectForKey:@"authentication_token"], self.page];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        self.photos = jsonObject[@"photos"];
//        self.total = jsonObject[@"meta"][@"total"];
//        self.totalLabel.text = jsonObject[@"meta"][@"total"];

 
//        [self.photos addObjectsFromArray:jsonObject[@"photos"]];
        
//        self.photos = jsonObject[@"photos"];
//        NSLog(@"%@", [jsonObject[@"photos"] class]);
        
        
//        NSLog(@"%@", self.photos);
//        NSLog(@"%@", jsonObject[@"meta"][@"total"]);
        
        self.total = jsonObject[@"meta"][@"total"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalLabel.text = [self.total stringValue];
            [self.tableView reloadData];
            [pvc.view removeFromSuperview];
            if ([self.total intValue ] > self.page * 20) {
//                NSLog(@"Not last page");
                self.loadMoreButton.hidden = NO;
            } else {
//                NSLog(@"Last page");
                self.loadMoreButton.hidden = YES;
            }
        });
        self.isLoading = NO;
    }];
    [dataTask resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    UINib *nib = [UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PhotoTableViewCell"];
    
    [self fetchPhotos];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 50.0f, 0.0f);
    
    self.backButton.hidden = YES;
    self.backButton.layer.cornerRadius = 10;
    self.loadMoreButton.layer.cornerRadius = 10;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTableViewCell"];
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
//        NSLog(@"showing image for ...");
        PhotoDetailViewController *pdvc = [[PhotoDetailViewController alloc] init];
        if (photo[@"medium"] != [NSNull null]) {
            NSURL *url = [NSURL URLWithString:photo[@"medium"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            pdvc.uiimage = img;
        }
        if (photo[@"critique"] != [NSNull null]) {
//            NSLog(@"setting critique");
            pdvc.critique = photo[@"critique"];
        }
        if (photo[@"title"] != [NSNull null]) {
//            NSLog(@"setting title");
            pdvc.photoTitle = photo[@"title"];
        }
        [self presentViewController:pdvc animated:YES completion:^{
            
        }];
    };
    return cell;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.imagePopover = nil;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    CGPoint offset = scrollView.contentOffset;
//    CGRect bounds = scrollView.bounds;
//    CGSize size = scrollView.contentSize;
//    UIEdgeInsets inset = scrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    //    NSLog(@"offset: %f", offset.y);
//    //    NSLog(@"content.height: %f", size.height);
//    //    NSLog(@"bounds.height: %f", bounds.size.height);
//    //    NSLog(@"inset.top: %f", inset.top);
//    //    NSLog(@"inset.bottom: %f", inset.bottom);
//    //    NSLog(@"pos: %f of %f", y, h);
//    float reload_distance = 10;
//    if (y > h + reload_distance) {
//        [self loadMore];
//    }
//}

- (void)loadMore {
    if (self.isLoading) {
//        NSLog(@"do nothing");
    } else {
//        NSLog(@"load more rows");
        self.page += 1;
        self.isLoading = YES;
        [self fetchPhotos];
    }
}
- (IBAction)loadMoreButtonClicked:(id)sender {
//    NSLog(@"Load more clicked");
    self.page += 1;
    [self fetchPhotos];
}

- (IBAction)backButtonClicked:(id)sender {
    self.page -= 1;
    [self fetchPhotos];
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self fetchPhotos];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
