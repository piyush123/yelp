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



NSString * const kYelpConsumerKey = @"2COXi2he0ApxqbBkdRP9Rw";
NSString * const kYelpConsumerSecret = @"dfhKfLpPO4OAC8-xPHZPVly3WjQ";
NSString * const kYelpToken = @"qrxKGWebiy_tZwaOn6V5YBchYM2Hfo4B";
NSString * const kYelpTokenSecret = @"RG9wcvTJ-pNAkutQCnelwA1T5DE";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

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
    self.searchResults = [[NSMutableArray alloc] init];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.filters = [[NSMutableDictionary alloc] initWithDictionary:@{@"term":@"food", @"location":@"San Francisco"}];
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self search];
    }
    
    return self;
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    
    //[self.searchBar sizeToFit];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(filter)];
    

    self.searchBar.showsCancelButton = NO;
    self.searchBar.frame = CGRectMake(0, 0, 200, 24);
    
    UIView *barWrapper = [[UIView alloc]initWithFrame:self.searchBar.bounds];
    [barWrapper addSubview:self.searchBar];
    self.navigationItem.titleView = barWrapper;

    // Do any additional setup after loading the view from its nib.
    
    UINib *listingNib=[UINib nibWithNibName:@"ListingCell" bundle:nil];
    [self.tableView registerNib:listingNib forCellReuseIdentifier:@"ListingCell"];
    
    self.tableView.rowHeight = 100;
    
    //NSLog(@"Calling search from viewDid load");
    //[self doSearch];
    //NSLog(@"view did load search result size: %d", [self.searchResults count]);

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

- (void)search
{
    NSLog(@"In  search %@", self.filters);
    [self.client search:self.filters success:^(AFHTTPRequestOperation *operation, id response) {
       
        
               [self.searchResults removeAllObjects];
                for (NSDictionary* dict in response[@"businesses"]) {
                    
                    Listing *yelpListing;
                    
                    yelpListing = [MTLJSONAdapter modelOfClass:Listing.class fromJSONDictionary:dict error:NULL];
                
                    [self.searchResults addObject:yelpListing];
                 
                }

        
        [self.tableView reloadData];

     

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
    
}

     

- (void)filter
{
    
    FilterViewController *filtersController = [[FilterViewController alloc] init];
    filtersController.delegate = self;
    
    UINavigationController *wrapperNavController = [[UINavigationController alloc] initWithRootViewController:filtersController];
    [self presentViewController:wrapperNavController animated:YES completion: nil];
}

- (void)confirmFilter:(NSDictionary*)filters
{
    self.filters = [filters mutableCopy];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self search];
    
}

- (void)cancelFilter
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

    [listingCell setListing:yelpListing];    
    
    return listingCell;

}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"text edit");
    searchBar.text = self.filters[@"term"];
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarTextShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"text edit");
    searchBar.text = self.filters[@"term"];
    self.searchBar.showsCancelButton = YES;
}


- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"text 2 edit");
    self.searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
     NSLog(@"text 3 edit");
    self.searchBar.showsCancelButton = NO;
    self.filters[@"term"] = searchBar.text;
    [self search];
    [searchBar resignFirstResponder];
}


@end
