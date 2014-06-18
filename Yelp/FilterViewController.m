 //
//  FilterViewController.m
//  Yelp
//
//  Created by piyush shah on 6/16/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"

#import "Categories.h"
#import "selectCell.h"
#import "switchCell.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) NSMutableDictionary* filters;


// TODO: should really be writing structs / classes to manage all this stuff
@property (strong, nonatomic) NSArray const* sections;
@property (strong, nonatomic) NSArray const* sortByOptions;
@property (strong, nonatomic) NSArray const* distanceOptions;
@property (strong, nonatomic) NSArray const* toggleOptions;
@property (strong, nonatomic) Categories const* categories;
@property (assign, nonatomic) NSInteger const NumCategoriesWhenCollapsed;

@property (assign, nonatomic) BOOL sortByExpanded;
@property (assign, nonatomic) BOOL distanceExpanded;
@property (assign, nonatomic) BOOL categoriesExpanded;
@property (assign, nonatomic) NSInteger selectedSortByIndex;
@property (assign, nonatomic) NSInteger selectedDistanceIndex;

typedef NS_ENUM(NSInteger, FilterSection) {
    SortBySection,
    DistanceSection,
    MiscSection,
    CategorySection
};
@end

@implementation FilterViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filters = [[NSMutableDictionary alloc] init];
        
        self.categories = [[Categories alloc] init];
        self.selectedSortByIndex = 0;
        self.selectedDistanceIndex = 0;
        
        
        self.sections = @[@"Sort by", @"Distance", @"General", @"Category"];
        self.sortByOptions =  @[@"Best matched", @"Distance", @"Highest Rated"];
        self.distanceOptions = @[@[@0,@"Automatic"], @[@0.3,@"0.3 miles"], @[@1.0,@"1 mile"], @[@5.0,@"5 miles"], @[@20.0,@"20 miles"]];
        self.toggleOptions = @[@[@"deals_filter",@"Offering a Deal"]];
        self.NumCategoriesWhenCollapsed = 5;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    NSLog(@"got there");
    
    UINib *selectCellNib = [UINib nibWithNibName:@"selectCell" bundle:nil];
    [self.table registerNib:selectCellNib forCellReuseIdentifier:@"selectCell"];
    
    
    UINib *switchCellNib = [UINib nibWithNibName:@"switchCell" bundle:nil];
    [self.table registerNib:switchCellNib forCellReuseIdentifier:@"switchCell"];
    
   
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SeeAllCell"];
    
  
    UIBarButtonItem *cancelButton= [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(cancelFilter)];
    UIBarButtonItem *searchButton= [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(confirmFilter)];
    
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = searchButton;
}

- (void) setDelegate:(id<FiltersDelegate>)delegate
{
    _delegate = delegate;
    [self.filters removeAllObjects];
    [self deepCopyFilterFrom:delegate.filters to:self.filters];
    [self computeSelectedIndices];
    if (delegate.filters[@"category_filter"]) {
        self.categories = [[Categories alloc] initWithApiParam:delegate.filters[@"category_filter"]];
    }
    
}

// sync helper (read redundant) state vars
- (void)computeSelectedIndices
{
    self.selectedSortByIndex = [self.filters[@"sort"] integerValue];
    self.selectedDistanceIndex = 0;
    for (int i = 1; i < self.distanceOptions.count; ++i) {
        // TODO: possible shady float comparision going on here
        if (self.filters[@"radius_filter"] && [self.distanceOptions[i][0] isEqualToNumber:self.filters[@"radius_filter"]]) {
            self.selectedDistanceIndex = i;
        }
    }
}

// TODO: write a better copy method(s) somewhere else
- (void)deepCopyFilterFrom:(NSDictionary*)from to:(NSMutableDictionary*)to
{
    [self setNilableValueInDict:to key:@"term" value:from[@"term"]];
    [self setNilableValueInDict:to key:@"location" value:from[@"location"]];
    [self setNilableValueInDict:to key:@"radius_filter" value:from[@"radius_filter"]];
    [self setNilableValueInDict:to key:@"sort" value:from[@"sort"]];
    [self setNilableValueInDict:to key:@"deals_filter" value:from[@"deals_filter"]];
    [self setNilableValueInDict:to key:@"kicks" value:from[@"kicks"]];
}

// TODO: should probably write category for this
// deletes value from dict if nil
- (void)setNilableValueInDict:(NSMutableDictionary*)dict key:(id)key value:(id)value
{
    if (value) {
        dict[key] = value;
    } else {
        [dict removeObjectForKey:key];
    }
}

- (void) cancelFilter
{
    NSLog(@"got cancel filter");
    [self.delegate didCancelFilter];
}

- (void) confirmFilter
{
    NSLog(@"got confirm here");
    self.filters[@"category_filter"] = self.categories.apiParam;
    [self.delegate didConfirmFilter:self.filters];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)didToggleSwitch:(UISwitch*)sender
{
    NSLog(@"Toggling row %ld", (long)sender.tag);
    NSString* filterKey = self.toggleOptions[sender.tag][0];
    if (sender.on) {
        self.filters[filterKey] = @YES;
    } else {
        [self.filters removeObjectForKey:filterKey];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sections[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SortBySection:
            return self.sortByExpanded ? self.sortByOptions.count : 1;
        case DistanceSection:
            return self.distanceExpanded ? self.distanceOptions.count : 1;
        case MiscSection:
            return self.toggleOptions.count;
        case CategorySection:
            return self.categoriesExpanded ? [self.categories count] : self.NumCategoriesWhenCollapsed + 1;
        default:
            return 0;
            
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SortBySection: {
            self.sortByExpanded = !self.sortByExpanded;
            [self.table beginUpdates];
            
            // need this to get checkmark/expand to show properly
            [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            if (self.sortByExpanded) {
                NSArray* changedPaths = [self changedIndexPathsForSection:indexPath.section
                                                                 startRow:0
                                                                   endRow:self.sortByOptions.count
                                                                  exclude:self.selectedSortByIndex];
                [self.table insertRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } else { // set value in filters dictionary and helper var
                self.selectedSortByIndex = indexPath.row;
                self.filters[@"sort"] = [NSNumber numberWithInteger:indexPath.row];
                NSArray* changedPaths = [self changedIndexPathsForSection:indexPath.section
                                                                 startRow:0
                                                                   endRow:self.sortByOptions.count
                                                                  exclude:indexPath.row];
                [self.table deleteRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            [self.table endUpdates];
            break;
        }
        case DistanceSection: {
            self.distanceExpanded = !self.distanceExpanded;
            [self.table beginUpdates];
            
            // need this to get checkmark/expand to show properly
            [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (self.distanceExpanded) {
                NSArray* changedPaths = [self changedIndexPathsForSection:indexPath.section
                                                                 startRow:0
                                                                   endRow:self.distanceOptions.count
                                                                  exclude:self.selectedDistanceIndex];
                
                [self.table insertRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                
            } else { // set value in filters dictionary and index helper var
                self.selectedDistanceIndex = indexPath.row;
                
                // only set the value in filters dictionary if it is not automatic
                [self.filters removeObjectForKey:@"radius_filter"];
                if (indexPath.row >= 1) {
                    self.filters[@"radius_filter"] = self.distanceOptions[indexPath.row][0];
                }
                NSArray* changedPaths = [self changedIndexPathsForSection:indexPath.section
                                                                 startRow:0
                                                                   endRow:self.distanceOptions.count
                                                                  exclude:indexPath.row];
                [self.table deleteRowsAtIndexPaths:changedPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
            [self.table endUpdates];
            break;
        }
       
        case CategorySection: {
            if (!self.categoriesExpanded && indexPath.row == self.NumCategoriesWhenCollapsed) {
                self.categoriesExpanded = !self.categoriesExpanded;
            } else {
                if ([self.categories isCategorySelectedAtIndex:indexPath.row]) {
                    [self.categories selectCategoryAtIndex:indexPath.row selected:NO];
                } else {
                    [self.categories selectCategoryAtIndex:indexPath.row selected:YES];
                }
            }
            [self.table reloadData];
            break;
        }
    }
}

- (NSArray*) changedIndexPathsForSection:(NSInteger)section startRow:(NSInteger)start endRow:(NSInteger)end exclude:(NSInteger)exclude
{
    NSMutableArray* ret = [[NSMutableArray alloc] init];
    for (int row = start; row < end; ++row) {
        if (row != exclude) {
            NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:section];
            [ret addObject:path];
        }
    }
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       NSLog(@"entering here in table cell");
    switch (indexPath.section) {
        case SortBySection: {
            
            NSLog(@"sort here in table cell");
            if (self.sortByExpanded) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                cell.textLabel.text = self.sortByOptions[indexPath.row];
                if (self.selectedSortByIndex == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
            } else {
                selectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
                cell.textLabel.text = self.sortByOptions[self.selectedSortByIndex];
                return cell;
            }
        }
        case DistanceSection: {
            
            NSLog(@"distance here in table cell");
            if (self.distanceExpanded) {
                UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                cell.textLabel.text = self.distanceOptions[indexPath.row][1];
                if (self.selectedDistanceIndex == indexPath.row) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                return cell;
            } else {
                selectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
                cell.textLabel.text = self.distanceOptions[self.selectedDistanceIndex][1];
                return cell;
            }
        }
        case MiscSection: {
            NSLog(@"getting in Misc");
            switchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
            cell.textLabel.text = self.toggleOptions[indexPath.row][1];
            NSString* filterKey = self.toggleOptions[indexPath.row][0];
            if (self.filters[filterKey]) {
                cell.toggleSwitch.on = YES;
            } else {
                cell.toggleSwitch.on = NO;
            }
            
            cell.toggleSwitch.tag = indexPath.row;
            [cell.toggleSwitch removeTarget:self action:@selector(didToggleSwitch:) forControlEvents:UIControlEventValueChanged];
            [cell.toggleSwitch addTarget:self action:@selector(didToggleSwitch:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }

        case CategorySection: {
            
            NSLog(@"category here in table cell");
            if (!self.categoriesExpanded && indexPath.row == self.NumCategoriesWhenCollapsed) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeeAllCell"];
                cell.textLabel.text = @"See All";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                cell.textLabel.text = [self.categories categoryAtIndex:indexPath.row];
                
                if ([self.categories isCategorySelectedAtIndex:indexPath.row]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                NSLog(@"got here in table cell");
                return cell;
            }
        }
    }
    
    
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
}
@end

