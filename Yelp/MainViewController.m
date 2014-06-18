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
#import "FilterViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
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

@property (nonatomic, strong) NSMutableArray* searchResults;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableDictionary *filters;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        
        self.filters = [[NSMutableDictionary alloc] initWithDictionary:@{@"term":@"Thai", @"location":@"San Francisco"}];
        
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.searchResults = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //self.searchResultsTable.delegate = self;
    //self.searchResultsTable.dataSource = self;
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(didClickFilter)];
    
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.showsCancelButton = NO;
    searchBar.frame = CGRectMake(0, 0, 200, 24);
    
    UIView *barWrapper = [[UIView alloc]initWithFrame:searchBar.bounds];
    [barWrapper addSubview:searchBar];
    self.navigationItem.titleView = barWrapper;
    
    self.tableView.delegate = self;

    // Do any additional setup after loading the view from its nib.
    
    UINib *listingNib=[UINib nibWithNibName:@"ListingCell" bundle:nil];
    [self.tableView registerNib:listingNib forCellReuseIdentifier:@"ListingCell"];
    
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    
    [self doSearch];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveFilter
{
    NSLog(@"filter");
    
}


- (IBAction)filter:(id)sender
{
    NSLog(@"filter");
    FilterViewController *j=[[FilterViewController alloc]init];
    [self.navigationController pushViewController:j animated:YES];
    
    
}

- (void)doSearch
{
    [self.client search:self.filters success:^(AFHTTPRequestOperation *operation, id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            id businesses = response[@"businesses"];
            if ([businesses isKindOfClass:[NSArray class]]) {
               [self.searchResults removeAllObjects];
                for (NSDictionary* dict in businesses) {
                    
                    Listing *yelpListing;
                    
                    yelpListing = [MTLJSONAdapter modelOfClass:Listing.class fromJSONDictionary:dict error:NULL];
                
                    [self.searchResults addObject:yelpListing];
                   // NSLog(@"got data %@", yelpListing);
                }

              //  [self.tableView reloadData];
            }
        }
        
    //    NSLog(@"got search %@", self.searchResults);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
    
}

     

- (void)didClickFilter
{
    NSLog(@"did click Filter delegated");
    // TODO: probably shouldn't initialize this every time?
    FilterViewController *filtersController = [[FilterViewController alloc] init];
    filtersController.delegate = self;
    
    // wrap filtersController in a nav controller to get cancel and search buttons
    UINavigationController *wrapperNavController = [[UINavigationController alloc] initWithRootViewController:filtersController];
    [self presentViewController:wrapperNavController animated:YES completion: nil];
}

- (void)didConfirmFilter:(NSDictionary*)filters
{
    self.filters = [filters mutableCopy];
    
    NSLog(@"doing search 1 %@", self.filters);
    [self dismissViewControllerAnimated:YES completion:nil];
    [self doSearch];
}

- (void)didCancelFilter
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    ListingCell *listingCell = [tableView dequeueReusableCellWithIdentifier:@"ListingCell"];
    
    Listing *yelpListing = self.searchResults[indexPath.row];
    
    listingCell.name.text = yelpListing.name;
    listingCell.address.text = yelpListing.address[0];
    NSLog(@"listing cell %@", listingCell);
    [self.tableView reloadData];
    return listingCell;

}


@end
