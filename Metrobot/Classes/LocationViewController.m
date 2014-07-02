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
#import <Mapbox/Mapbox.h>
#import "DirectionsTableView.h"
#import "LogService.h"
#import "DirectionsTableHeaderView.h"

#define tableViewHeight 280

@interface LocationViewController () <RMMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) RMMapView *mapView;
@property (nonatomic, strong) DirectionsTableView *tableView;
@property (nonatomic, strong) UIView *overlayView;

@property (nonatomic, strong) StationEntity *currentStation;
@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) NSArray *entrances;

@property (nonatomic, strong) UIView *navigationBarBackgound;
@property (nonatomic, strong) UIBarButtonItem *closeMapButton;

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
    [super viewDidLoad];
    
    [self loadData];
    
    [self applyAppearance];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startUpdatingLoc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
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
}

- (void)applyAppearance
{
    self.title = @"Station";
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Background"]];
    [self.view addSubview:backgroundImage];
    
    _locManager = [CLLocationManager new];
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"jakubvodak.ilbppm8e"];
    
    _mapView = [[RMMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-tableViewHeight) andTilesource:tileSource];
    _mapView.zoom = 15;
    _mapView.hideAttribution=YES;
    _mapView.delegate = self;
    _mapView.showsUserLocation=YES;
    _mapView.alpha = 0;
    [self.view addSubview:_mapView];
    
    _navigationBarBackgound = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    _navigationBarBackgound.backgroundColor = [MbAppearanceManager darkBlueColor];
    _navigationBarBackgound.alpha = 0;
    [_mapView addSubview:_navigationBarBackgound];
    
    _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    //_overlayView.alpha = 0;
    _overlayView.backgroundColor = UIColorWithRGBAValues(0, 0, 0, 255);
    [_mapView addSubview:_overlayView];
    
    UIImageView *test = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Pin"]];
    test.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mapView addSubview:test];
    [self.mapView addConstraint:[NSLayoutConstraint constraintWithItem:test attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.mapView addConstraint:[NSLayoutConstraint constraintWithItem:test attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    _tableView = [[DirectionsTableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, tableViewHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:_tableView];
    
    DirectionsTableHeaderView *tableHeaderView = [[DirectionsTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView = tableHeaderView;
    
    _closeMapButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeMap)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icn-Location"] style:UIBarButtonItemStylePlain target:self action:@selector(startUpdatingLoc)];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"Dejvická";
    cell.textLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameStrong] size:17];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }

    if (_tableView.up) {
        self.overlayView.alpha = (double)(100 - abs(scrollView.contentOffset.y))/100;
        self.navigationBarBackgound.alpha = (double)abs(scrollView.contentOffset.y)/100;
        self.mapView.frame = CGRectMake(0, 0, 320, 300+abs(scrollView.contentOffset.y));
        self.overlayView.frame = CGRectMake(0, 0, 320, 300+abs(scrollView.contentOffset.y));
    }
    
    if (scrollView.contentOffset.y < -80 && _tableView.up) {
        
        _tableView.up = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
        
            self.tableView.frame = CGRectMake(0, self.view.bounds.size.height, self.tableView.frame.size.width, self.tableView.frame.size.height);
            self.overlayView.alpha = 0;
            self.navigationBarBackgound.alpha = 1;
        } completion:^(BOOL finished) {
            self.navigationItem.leftBarButtonItem = _closeMapButton;
        }];
    }
}

#pragma mark - location manager

- (void)startUpdatingLoc
{
    [self.locManager startUpdatingLocation];
}

- (void)stopUpdatingLoc
{
    [self.locManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self stopUpdatingLoc];
    
    [self findNearestStations:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[LogService sharedInstance] logError:error];
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

#pragma mark - func

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
    
    self.currentStation = nearestStation;
    
    [self refreshScreen];
}


- (void)refreshScreen
{
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.currentStation.lat.doubleValue, self.currentStation.lng.doubleValue)];
    
    if (!self.startAnimationPreccessed) {
        self.startAnimationPreccessed = YES;
        [self showHideTable];
    }
}

- (void)closeMap
{
    [UIView animateWithDuration:0.2 animations:^{
        self.overlayView.alpha = 1;
        self.navigationBarBackgound.alpha = 0;
        self.navigationItem.leftBarButtonItem = nil;
    } completion:^(BOOL finished) {
        [self showHideTable];
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

@end
