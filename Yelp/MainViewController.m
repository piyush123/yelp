//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Listing.h"
#import "ListingCell.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YelpClient *client;

@property (nonatomic, strong) NSMutableArray *listings;

@property (nonatomic,strong) Listing *listing;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {

            self.listings = response[@"businesses"];
            
            [self.tableView reloadData];
            NSLog(@"listing: %@", self.listings[0]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;

    // Do any additional setup after loading the view from its nib.
    
    UINib *listingNib=[UINib nibWithNibName:@"ListingCell" bundle:nil];
    [self.tableView registerNib:listingNib forCellReuseIdentifier:@"ListingCell"];
    
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.listings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    ListingCell *listingCell = [tableView dequeueReusableCellWithIdentifier:@"ListingCell"];
   
    Listing *yelpListing;
    
    yelpListing = [MTLJSONAdapter modelOfClass:Listing.class fromJSONDictionary:self.listings[indexPath.row] error:NULL];
    
    NSLog(@"got listing %@", yelpListing);
    
    listingCell.name.text = yelpListing.name;
    
    NSLog(@"address %@", yelpListing.address[0]);
    
    listingCell.address.text = yelpListing.address[0];
    
    NSLog(@"categories %@", yelpListing.categories[0]);
    
    listingCell.radial_distance.text = @"0.75 mi";
    
    NSLog(@"review count %@", yelpListing.review_count);
    listingCell.review_count.text = [NSString stringWithFormat:@"reviews %@", yelpListing.review_count];
    NSURL *image_url = [[NSURL alloc]initWithString:yelpListing.image_url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:image_url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:2*60]; // New line
    
    ListingCell *weakListingCell = listingCell;
    
    //  movieCell.posterImage setImageWithURL:[NSURL URLWithString:movie.posters[@"profile"]]];
    
    [listingCell.image setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             weakListingCell.image.image = image;
                                             [weakListingCell setNeedsLayout];
                                         } failure:nil];
    
    
    NSURL *rating_url = [[NSURL alloc]initWithString:yelpListing.rating_img_url];
    
    NSURL *rating_request = [NSURLRequest requestWithURL:rating_url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:2*60]; // New line
    

    [listingCell.rating_image setImageWithURLRequest:rating_request
                             placeholderImage:nil
                                      success:^(NSURLRequest *rating_request, NSHTTPURLResponse *response, UIImage *image) {
                                          weakListingCell.rating_image.image = image;
                                          [weakListingCell setNeedsLayout];
                                      } failure:nil];
    
    return listingCell;

}


@end
