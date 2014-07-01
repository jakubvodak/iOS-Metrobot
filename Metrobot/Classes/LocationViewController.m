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

@interface LocationViewController () <RMMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) RMMapView *mapView;
@property (nonatomic, strong) StationEntity *currentStation;

@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) NSArray *entrances;

@property (nonatomic, strong) UIView *navigationBarBackgound;

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self loadData];
        
        [self applyAppearance];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"jakubvodak.ilbppm8e"];
    
    _mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
    [_mapView setZoom:15];
    _mapView.hideAttribution=YES;
    _mapView.delegate = self;
    _mapView.showsUserLocation=YES;
    [self.view addSubview:_mapView];
    
    
    _navigationBarBackgound = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    _navigationBarBackgound.backgroundColor = [MbAppearanceManager darkBlueColor];
    _navigationBarBackgound.alpha = 1;
    [self.view addSubview:_navigationBarBackgound];
    
    _locManager = [CLLocationManager new];
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyBest;
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

#pragma mark - map view


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
    
    
    
    
}

@end
