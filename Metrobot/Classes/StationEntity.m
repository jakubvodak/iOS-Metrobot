//
//  StationEntity.m
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "StationEntity.h"

@implementation StationEntity

+ (StationEntity *)initWithName:(NSString *)name metroRoutes:(NSArray *)routes andLocation:(CLLocation *)loc
{
    StationEntity *station = [StationEntity new];
    station.name = name;
    station.location = loc;
    station.routes = routes;
    return station;
}

+ (NSArray *)setupContent
{
    NSMutableArray *array = [NSMutableArray new];
    
    [array addObject:[StationEntity initWithName:@"Muzeum" metroRoutes:@[@(metroRouteA), @(metroRouteC)] andLocation:[[CLLocation alloc] initWithLatitude:50.0792892 longitude:14.4301661]]];
    [array addObject:[StationEntity initWithName:@"Můstek" metroRoutes:@[@(metroRouteA), @(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0839703 longitude:14.4237175]]];
    [array addObject:[StationEntity initWithName:@"Florenc" metroRoutes:@[@(metroRouteB), @(metroRouteC)] andLocation:[[CLLocation alloc] initWithLatitude:50.0907572 longitude:14.4395367]]];
    
    [array addObject:[StationEntity initWithName:@"Dejvická" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.1004672 longitude:14.3932314]]];
    [array addObject:[StationEntity initWithName:@"Hradčanská" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0971131 longitude:14.4037322]]];
    [array addObject:[StationEntity initWithName:@"Malostranská" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0909122 longitude:14.4091425]]];
    [array addObject:[StationEntity initWithName:@"Staroměstská" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0884039 longitude:14.4164283]]];
    [array addObject:[StationEntity initWithName:@"Náměstí Míru" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0753900 longitude:14.4384019]]];
    [array addObject:[StationEntity initWithName:@"Jiřího z Poděbrad" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0773817 longitude:14.4495456]]];
    [array addObject:[StationEntity initWithName:@"Flora" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0778722 longitude:14.4621044]]];
    [array addObject:[StationEntity initWithName:@"Želivského" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0783844 longitude:14.4747892]]];
    [array addObject:[StationEntity initWithName:@"Strašnická" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0729133 longitude:14.4913250]]];
    [array addObject:[StationEntity initWithName:@"Skalka" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0682964 longitude:14.5073314]]];
    [array addObject:[StationEntity initWithName:@"Depo Hostivař" metroRoutes:@[@(metroRouteA)] andLocation:[[CLLocation alloc] initWithLatitude:50.0753142 longitude:14.5154072]]];
    

    [array addObject:[StationEntity initWithName:@"Zličín" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0535711 longitude:14.2906681]]];
    [array addObject:[StationEntity initWithName:@"Stodůlky" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0464358 longitude:14.3065281]]];
    [array addObject:[StationEntity initWithName:@"Luka" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0456411 longitude:14.3212047]]];
    [array addObject:[StationEntity initWithName:@"Lužiny" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0443661 longitude:14.3308597]]];
    [array addObject:[StationEntity initWithName:@"Hůrka" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0498092 longitude:14.3421819]]];
    [array addObject:[StationEntity initWithName:@"Nové Butovice" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0507375 longitude:14.3520867]]];
    [array addObject:[StationEntity initWithName:@"Jinonice" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0543361 longitude:14.3702681]]];
    [array addObject:[StationEntity initWithName:@"Radlická" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0581064 longitude:14.3891067]]];
    [array addObject:[StationEntity initWithName:@"Smíchovské nádraží" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0612583 longitude:14.4089758]]];
    [array addObject:[StationEntity initWithName:@"Anděl" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0708397 longitude:14.4042467]]];
    [array addObject:[StationEntity initWithName:@"Karlovo náměstí" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0752106 longitude:14.4166025]]];
    [array addObject:[StationEntity initWithName:@"Národní třída" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0811292 longitude:14.4203044]]];
    [array addObject:[StationEntity initWithName:@"Náměstí Republiky" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0882844 longitude:14.4304092]]];
    [array addObject:[StationEntity initWithName:@"Křižíkova" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0934500 longitude:14.4515983]]];
    [array addObject:[StationEntity initWithName:@"Invalidovna" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.0970522 longitude:14.4640989]]];
    [array addObject:[StationEntity initWithName:@"Palmovka" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.1040786 longitude:14.4744522]]];
    [array addObject:[StationEntity initWithName:@"Českomoravská" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.1061344 longitude:14.4928053]]];
    [array addObject:[StationEntity initWithName:@"Vysočanská" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.1100403 longitude:14.5006378]]];
    [array addObject:[StationEntity initWithName:@"Kolbenova" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.1102028 longitude:14.5156286]]];
    [array addObject:[StationEntity initWithName:@"Hloubětín" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.1065500 longitude:14.5373831]]];
    [array addObject:[StationEntity initWithName:@"Rajská zahrada" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.1068031 longitude:14.5608186]]];
    [array addObject:[StationEntity initWithName:@"Černý most" metroRoutes:@[@(metroRouteB)] andLocation:[[CLLocation alloc] initWithLatitude:50.1089419 longitude:14.5773994]]];
    
    return array;
}

@end
