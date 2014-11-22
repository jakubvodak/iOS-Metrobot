//
//  LocationViewController.m
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import "StationEntity.h"
#import "EntranceEntity.h"
#import <CoreLocation/CoreLocation.h>
#import <Mapbox/Mapbox.h>
#import "DirectionsTableView.h"
#import "LogService.h"
#import "DirectionsTableHeaderView.h"
#import "StationTitleView.h"
#import "SearchTableViewController.h"
#import "TimeViewController.h"

#define smallCellHeight 60
#define bigCellHeight 120
#define tableViewHeight 280
#define locErrorText @"Hledání nejbližší stanice selhalo."

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface LocationViewController () <RMMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) RMMapView *mapView;
@property (nonatomic, strong) DirectionsTableView *tableView;
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) StationTitleView *titleView;
@property (nonatomic, strong) UILabel *locErrorLabel;

@property (nonatomic, strong) StationEntity *currentStation;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSArray *directions;
@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) NSArray *entrances;

@property (nonatomic, strong) UIView *navigationBarBackgound;
@property (nonatomic, strong) UIBarButtonItem *closeMapButton;
@property (nonatomic, strong) UIBarButtonItem *searchButton;

@property (nonatomic) BOOL startAnimationPreccessed;

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"Location view did load");
    
    [super viewDidLoad];
    
    [self loadData];
    
    [self applyAppearance];
    
    [self startUpdatingLoc];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startUpdatingLoc) name:MetrobotDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    NSLog(@"start");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"metroStations" ofType:@"plist"];
    NSDictionary *dictComplete = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *stationsDetails = [dictComplete valueForKey:@"StationsDetails"];
    NSMutableArray *arrTemp = [NSMutableArray new];
    
    for (NSDictionary *dictStation in stationsDetails) {
        
        StationEntity *station = [[StationEntity alloc] initWithDictionary:dictStation];
        station.location = [[CLLocation alloc] initWithLatitude:station.lat.doubleValue longitude:station.lng.doubleValue];
        [arrTemp addObject:station];
    }
    
    self.stations = arrTemp;
    
    path = [[NSBundle mainBundle] pathForResource:@"metroStations" ofType:@"plist"];
    dictComplete = [[NSDictionary alloc] initWithContentsOfFile:path];
    stationsDetails = [dictComplete valueForKey:@"Entrances"];
    arrTemp = [NSMutableArray new];
    
    for (NSDictionary *dictEntrance in stationsDetails) {
        
        EntranceEntity *entrance = [[EntranceEntity alloc] initWithDictionary:dictEntrance];
        entrance.location = [[CLLocation alloc] initWithLatitude:entrance.lat.doubleValue longitude:entrance.lng.doubleValue];
        [arrTemp addObject:entrance];
    }
    
    self.entrances = arrTemp;
    
    NSLog(@"finish");
}

- (void)applyAppearance
{
    self.title = @"Stanice";
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Background"]];
    [self.view addSubview:backgroundImage];
    
    _locManager = [CLLocationManager new];
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locManager setDistanceFilter:kCLDistanceFilterNone];
    if(IS_OS_8_OR_LATER) {
        [_locManager requestWhenInUseAuthorization];
    }
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:MapBoxID];
    
    DEFINE_VIEW_WIDTH;
    DEFINE_VIEW_HEIGHT;
    
    _mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0, 0, w, h-tableViewHeight) andTilesource:tileSource];
    _mapView.zoom = 15;
    _mapView.hideAttribution=YES;
    _mapView.delegate = self;
    _mapView.showsUserLocation=YES;
    _mapView.alpha = 0;
    _mapView.showLogoBug = NO;
    [self.view addSubview:_mapView];
    
    _navigationBarBackgound = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 64)];
    _navigationBarBackgound.backgroundColor = [MbAppearanceManager MBDarkBlueColor];
    _navigationBarBackgound.alpha = 0;
    [_mapView addSubview:_navigationBarBackgound];
    
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    //_overlayView.alpha = 0;
    _overlayView.backgroundColor = UIColorWithRGBAValues(0, 0, 0, 255);
    [_mapView addSubview:_overlayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTable)];
    
    _titleView = [[StationTitleView alloc] initWithFrame:CGRectMake(0, 0, w, h-tableViewHeight)];
    //[_titleView.stationName addTarget:self action:@selector(hideTable) forControlEvents:UIControlEventTouchUpInside];
    _titleView.alpha = 0;
    [_titleView addGestureRecognizer:tap];
    
    [self.view addSubview:_titleView];
    
    _tableView = [[DirectionsTableView alloc] initWithFrame:CGRectMake(0, h, w, tableViewHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    DirectionsTableHeaderView *tableHeaderView = [[DirectionsTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, w, 44)];
    [tableHeaderView.titleLabel addTarget:self action:@selector(directionsFlash) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = tableHeaderView;
    
    _closeMapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icn-Back"] style:UIBarButtonItemStylePlain target:self action:@selector(showTable)];
    _searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icn-Search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchStation)];
    
    self.navigationItem.leftBarButtonItem = _searchButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icn-Location"] style:UIBarButtonItemStylePlain target:self action:@selector(startUpdatingLoc)];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    _locErrorLabel = [UILabel new];
    _locErrorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _locErrorLabel.textColor = [MbAppearanceManager MBBlueColor];
    _locErrorLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:14];
    _locErrorLabel.backgroundColor = [UIColor clearColor];
    _locErrorLabel.textAlignment = NSTextAlignmentCenter;
    _locErrorLabel.numberOfLines = 2;
    _locErrorLabel.alpha = 0;
    _locErrorLabel.text = locErrorText;
    [self.view addSubview:_locErrorLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_locErrorLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_locErrorLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.directions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.directions.count == 4) {
        return smallCellHeight;
    }
    else {
        return bigCellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DirectionCell" forIndexPath:indexPath];

    StationEntity *station = [self.directions objectAtIndex:indexPath.row];
    
    if ([station.name isEqualToString:self.currentStation.name]) {
        [cell setCellDisabled];
    }
    else {
        [cell setCellEnabled];
    }
    
    cell.roundImageView.image = [UIImage imageNamed:[StationEntity roundImageNameForTrace:station.trace]];
    [cell setLineFrameForIndex:indexPath.row andCellHeight:self.directions.count==2?bigCellHeight:smallCellHeight];
    
    cell.stationLabel.text = station.name;
    cell.countLabel.text = [self formatRemainingStationsCount:[self findRemainingStationsCount:self.currentStation toStation:[self.directions objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StationEntity *station = [self.directions objectAtIndex:indexPath.row];
    
    if (![station.name isEqualToString:self.currentStation.name]) {
        [Flurry logEvent:@"Departure" withParameters:@{@"from": self.currentStation.name, @"to":station.name}];
        TimeViewController *viewController = [TimeViewController new];
        viewController.currentStation = self.currentStation;
        viewController.destinationStation = station;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (_tableView.up) {

        [self updateLayoutForScrollViewY:scrollView.contentOffset.y];
        
        if (scrollView.contentOffset.y < -80) {
            
            [self hideTable];
        }
    }
}

#pragma mark - location manager

- (void)startUpdatingLoc
{
    [_locManager startUpdatingLocation];
}

- (void)stopUpdatingLoc
{
    [_locManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Did update to loc: %@", newLocation);
    
    self.currentLocation = newLocation;
    
    [self stopUpdatingLoc];
    
    [self findNearestStations:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Loc failed: %@", error.localizedDescription);
    
    [self stopUpdatingLoc];
    
    if (_currentStation) {
        //[[[UIAlertView alloc] initWithTitle:@"Chyba" message:locErrorText delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            _locErrorLabel.alpha = 1;
        }];
    }
}

- (void)findNearestStations: (CLLocation *)loc
{
    CLLocationDistance distance = 0;
    StationEntity *nearestStation;
    
    for (StationEntity *station in self.stations) {
        if ([station.location distanceFromLocation:loc] < distance || distance == 0) {
            nearestStation = station;
            distance = [station.location distanceFromLocation:loc];
        }
    }
    
    nearestStation.distance = distance;
    
    [self updateCurrentStation:nearestStation];
    
    NSLog(@"Nearest station: %@", nearestStation);
}

#pragma mark - map view

- (void)mapViewRegionDidChange:(RMMapView *)mapView
{
    if (_currentStation && self.mapView.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.mapView.alpha = 1;
            self.overlayView.backgroundColor = UIColorWithRGBAValues(0, 0, 0, 170);
        } completion:nil];
    }
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMarker *marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"Icn-Map-Pin"]];
    marker.canShowCallout = YES;
    //marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return marker;
}

#pragma mark - func

- (void)updateCurrentStation: (StationEntity *)newStation
{
    self.currentStation = newStation;
    
    self.directions = [self findDirectionsForStation:newStation];
    
    [self refreshScreen];
}

- (void)refreshScreen
{
    _locErrorLabel.alpha = 0;
    self.titleView.stationName.text = self.currentStation.name;
    [self.titleView checkTitleSize];
    
    if (self.currentStation.distance>=0) {
        self.titleView.distanceLabel.text = [self formatDistanceString:self.currentStation.distance];
    }
    else {
        self.titleView.distanceLabel.text = @"";
    }
    
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.currentStation.lat.doubleValue, self.currentStation.lng.doubleValue)];
    
    if (!self.startAnimationPreccessed) {
        self.startAnimationPreccessed = YES;
        [self.tableView reloadData];
        [self startAnimation];
    }
    else if (self.tableView.up) {
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        self.titleView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView beginAnimations:@"showView" context:nil];
        //[UIView setAnimationDelegate:self];
        self.titleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.titleView.alpha = 1;
        [UIView commitAnimations];
    }
}

- (void)startAnimation
{
    self.titleView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView beginAnimations:@"showView" context:nil];
    //[UIView setAnimationDelegate:self];
    self.titleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.titleView.alpha = 1;
    [UIView commitAnimations];
    
    [self showHideTable];
}

- (void)updateLayoutForScrollViewY: (CGFloat)y
{
    self.overlayView.alpha = (double)(100 - abs(y))/100;
    self.titleView.alpha = (double)(100 - abs(y))/100;
    self.navigationBarBackgound.alpha = (double)abs(y)/100;
    
    DEFINE_VIEW_WIDTH;
    DEFINE_VIEW_HEIGHT;
    
    self.mapView.frame = CGRectMake(0, 0, w, h-tableViewHeight+abs(y));
    self.overlayView.frame = CGRectMake(0, 0, w, h-tableViewHeight+abs(y));
    self.titleView.frame = CGRectMake(0, 0, w, h-tableViewHeight+(abs(y/1.5)));
}

- (void)showTable
{
    DEFINE_VIEW_WIDTH;
    DEFINE_VIEW_HEIGHT;
    
    self.titleView.frame = CGRectMake(0, 0, w, h-tableViewHeight);
    self.titleView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [UIView beginAnimations:@"showView" context:nil];
    //[UIView setAnimationDelegate:self];
    self.titleView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.titleView.alpha = 1;
    [UIView commitAnimations];
    
    self.navigationItem.leftBarButtonItem = _searchButton;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.overlayView.alpha = 1;
        self.navigationBarBackgound.alpha = 0;
        
        [self.mapView removeAllAnnotations];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.6 animations:^{
            self.mapView.frame = CGRectMake(0, 0, w, h-tableViewHeight);
            self.overlayView.frame = CGRectMake(0, 0, w, h-tableViewHeight);
        } completion:^(BOOL finished) {
            self.tableView.backgroundView = nil;
        }];
    }];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Table-Background-Temp"]];
    [self showHideTable];
}

- (void)hideTable
{
    DEFINE_VIEW_WIDTH;
    DEFINE_VIEW_HEIGHT;
    
    [Flurry logEvent:@"Map"];
    
    _tableView.up = NO;
    
    [self loadAnnotationsForStation:self.currentStation];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.tableView.frame = CGRectMake(0, h, self.tableView.frame.size.width, self.tableView.frame.size.height);
        self.mapView.frame = CGRectMake(0, 0, w, h);
        self.overlayView.frame = CGRectMake(0, 0, w, h);
        
        self.overlayView.alpha = 0;
        self.titleView.alpha = 0;
        self.navigationBarBackgound.alpha = 1;
        
    } completion:^(BOOL finished) {
        self.navigationItem.leftBarButtonItem = _closeMapButton;
    }];
}

- (void)showHideTable {
    
    self.tableView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.tableView.layer.shouldRasterize = YES;
    
    double duration = 0.7;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    
    CGPoint destinationPoint;
    
    if (self.tableView.up)
    {
        self.tableView.up = NO;
        destinationPoint = CGPointMake(self.tableView.layer.position.x, self.tableView.layer.position.y+tableViewHeight);
    }
    else
    {
        self.tableView.up = YES;
        destinationPoint = CGPointMake(self.tableView.layer.position.x, self.tableView.layer.position.y-tableViewHeight);
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.tableView.layer.position.x, self.tableView.layer.position.y);
    CGPathAddLineToPoint(path, NULL, destinationPoint.x, destinationPoint.y);
    
    animation.path = path;
    animation.duration = duration;
    CGPathRelease(path);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.14
                                                                                            :0.40
                                                                                            :0
                                                                                            :1];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation2 setDuration:duration];
    
    group.timingFunction = timingFunction;
    group.animations = [NSArray arrayWithObjects:animation, animation2, nil];
    animation.fillMode = kCAFillModeForwards;
    [self.tableView.layer addAnimation:group forKey:@"doAnimationDemo"];
    
    self.tableView.layer.position = CGPointMake(destinationPoint.x, destinationPoint.y);
    self.tableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
}

- (void)directionsFlash
{
    DirectionTableViewCell *cell = (DirectionTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    DirectionTableViewCell *cell2 = (DirectionTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    [cell setHighlighted:YES animated:YES];
    [cell setHighlighted:NO animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC/10), dispatch_get_main_queue(), ^{
        [cell2 setHighlighted:YES animated:YES];
        [cell2 setHighlighted:NO animated:YES];
    });
    
    if (self.directions.count == 4) {
        DirectionTableViewCell *cell3 = (DirectionTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        DirectionTableViewCell *cell4 = (DirectionTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC/5), dispatch_get_main_queue(), ^{
            [cell3 setHighlighted:YES animated:YES];
            [cell3 setHighlighted:NO animated:YES];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC/3), dispatch_get_main_queue(), ^{
            [cell4 setHighlighted:YES animated:YES];
            [cell4 setHighlighted:NO animated:YES];
        });
    }
}

#pragma mark - Other

- (NSString *)formatDistanceString: (CLLocationDistance)distance
{
    if (distance < 1000) {
        return [NSString stringWithFormat:@"%.0fm", distance];
    }
    else if (distance < 10000) {
        return [NSString stringWithFormat:@"%.1fkm", distance/1000];
    }
    else {
        return [NSString stringWithFormat:@"%.0fkm", distance/1000];
    }
}

- (NSArray *)findDirectionsForStation: (StationEntity *)station
{
    NSMutableArray *arrTemp = [NSMutableArray new];

    for (int i=0; i<3; i++) {
        
        NSArray *stations = [StationEntity getStationsForTrace:i];
        
        if ([stations containsObject:station.name]) {
            
            StationEntity *station = [StationEntity new];
            station.name = stations.firstObject;
            station.trace = i;

            StationEntity *station2 = [StationEntity new];
            station2.name = stations.lastObject;
            station2.trace = i;
            
            [arrTemp addObject:station];
            [arrTemp addObject:station2];
        }
    }
    
    return arrTemp;
}

- (NSInteger)findRemainingStationsCount: (StationEntity *)fromStation toStation: (StationEntity *)toStation
{
    for (int i=0; i<3; i++) {
        
        NSArray *stations = [StationEntity getStationsForTrace:i];
        
        if ([stations containsObject:fromStation.name] && [stations containsObject:toStation.name]) {
            NSInteger index1 = [stations indexOfObject:fromStation.name];
            NSInteger index2 = [stations indexOfObject:toStation.name];
            
            return index1>index2?index1-index2:index2-index1;
        }
    }
    
    return 0;
}

- (NSString *)formatRemainingStationsCount: (NSInteger)count
{
    if (count == 0 || count >= 5) {
        return [NSString stringWithFormat:@"%d stanic", (int)count];
    }
    else {
        return [NSString stringWithFormat:@"%d stanice", (int)count];
    }
}

- (void)searchStation
{
    SearchTableViewController *searchController = [SearchTableViewController new];
    
    searchController.finishBlock = ^(StationEntity *station){
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            station.distance = [station.location distanceFromLocation:self.currentLocation];
            
            [Flurry logEvent:@"Search" withParameters:@{@"station": station.name}];
            
            [self updateCurrentStation:station];
        }];
    };

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)loadAnnotationsForStation: (StationEntity *)station
{
    [_mapView removeAllAnnotations];
    
    NSMutableArray *tempArr = [NSMutableArray new];
    
    for (EntranceEntity *entrance in self.entrances) {
        NSLog(@"%@", entrance);
        if ([entrance.name isEqualToString:self.currentStation.name]) {
            RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:_mapView
                                                                  coordinate:CLLocationCoordinate2DMake(entrance.location.coordinate.latitude, entrance.location.coordinate.longitude)
                                                                    andTitle:entrance.street.length>0?entrance.street:@"Vchod"];
            [tempArr addObject:annotation];
                    NSLog(@"%@", entrance);
        }
    }
    
    [_mapView addAnnotations:tempArr];
}

@end
