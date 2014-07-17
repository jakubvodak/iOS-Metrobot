//
//  SearchTableViewController.m
//  Metrobot
//
//  Created by Jakub Vodak on 7/6/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "SearchTableViewController.h"
#import "UIImage+ImageEffects.h"
#import "SearchTableViewCell.h"

@interface SearchTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) NSArray *allStations;
@property (nonatomic, strong) NSArray *searchStations;
@property (nonatomic, strong) UIView *navigationBarBackgound;

@end

@implementation SearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self applyAppearance];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_searchField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyAppearance
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelSearch)];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Background"]];
    self.tableView.backgroundView = backgroundImage;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"SearchCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 65;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 250, 44)];
    searchBar.barTintColor = [UIColor clearColor];
    searchBar.layer.borderWidth = 1;
    searchBar.delegate = self;
    searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    searchBar.tintColor = [UIColor whiteColor];
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:15];
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"Img-SearchBar-Background"] forState:UIControlStateNormal];
    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setSearchTextPositionAdjustment:UIOffsetMake(5, 0)];
    [searchBar setImage:[UIImage imageNamed:@"Icn-Search-Small"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    _searchField = searchField;
    
    UIView *searchBarContainer = [[UIView alloc] initWithFrame:searchBar.frame];
    [searchBarContainer addSubview:searchBar];
    searchBarContainer.bounds = CGRectOffset(searchBarContainer.frame, 12, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBarContainer];
    
    _navigationBarBackgound = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.view.bounds.size.width, 64)];
    _navigationBarBackgound.backgroundColor = [MbAppearanceManager MBDarkBlueColor];
    [self.view addSubview:_navigationBarBackgound];
}

- (void)loadData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"metroStations" ofType:@"plist"];
    NSDictionary *dictComplete = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSMutableArray *temp = [NSMutableArray new];
    
    for (NSDictionary *dict in [dictComplete valueForKey:@"StationsDetails"]) {
        StationEntity *station = [[StationEntity alloc] initWithDictionary:dict];
        station.location = [[CLLocation alloc] initWithLatitude:station.lat.doubleValue longitude:station.lng.doubleValue];
        [temp addObject:station];
    }
    
    _allStations = temp;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchStations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    StationEntity *station = [_searchStations objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = station.name;
    cell.routeLabel.text = [self formatTraceTextForStation:station];
    cell.circleView.image = [UIImage imageNamed: [self formatTraceImageForStation:station]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StationEntity *station = [self.searchStations objectAtIndex:indexPath.row];
    
    self.finishBlock(station);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect fixedFrame = self.navigationBarBackgound.frame;
    fixedFrame.origin.y = scrollView.contentOffset.y;
    self.navigationBarBackgound.frame = fixedFrame;
}

#pragma mark - searchBar

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *results = [NSMutableArray new];
    
    for (StationEntity *station in _allStations) {
        
        NSRange r = [station.name rangeOfString:searchText options:(NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch)];
        if (r.location != NSNotFound)
        {
            [results addObject:station];
        }
    }
    
    _searchStations = results;
    
    [self.tableView reloadData];
}

#pragma mark - func

- (void)cancelSearch
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)formatTraceTextForStation: (StationEntity *)station
{
    if ([station.name isEqualToString:@"Můstek"]) {
        return @"Trasa A, B";
    }
    else if ([station.name isEqualToString:@"Muzeum"]) {
        return @"Trasa A, C";
    }
    else if ([station.name isEqualToString:@"Florenc"]) {
        return @"Trasa B, C";
    }
    else {
        for (int i=0; i<3; i++) {
            
            NSArray *stations = [StationEntity getStationsForTrace:i];
            if ([stations containsObject:station.name]) {
                if (i==0) {
                    return @"Trasa A";
                }
                else if (i==1) {
                    return @"Trasa B";
                }
                else if (i==2) {
                    return @"Trasa C";
                }
            }
        }
    }
    
    return nil;
}

- (NSString *)formatTraceImageForStation: (StationEntity *)station
{
    if ([station.name isEqualToString:@"Můstek"]) {
        return @"Icn-Round-GreenYellow";
    }
    else if ([station.name isEqualToString:@"Muzeum"]) {
        return @"Icn-Round-GreenRed";
    }
    else if ([station.name isEqualToString:@"Florenc"]) {
        return @"Icn-Round-YellowRed";
    }
    else {
        for (int i=0; i<3; i++) {
            
            NSArray *stations = [StationEntity getStationsForTrace:i];
            if ([stations containsObject:station.name]) {
                if (i==0) {
                    return @"Icn-Round-Green";
                }
                else if (i==1) {
                    return @"Icn-Round-Yellow";
                }
                else if (i==2) {
                    return @"Icn-Round-Red";
                }
            }
        }
    }
    
    return nil;
}

@end
