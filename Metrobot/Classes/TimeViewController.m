//
//  TimeViewController.m
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "TimeViewController.h"
#import "UIImage+ImageEffects.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "BigCircleView.h"
#import "TimeEntity.h"
#import "NextDeparturesView.h"
#import "InfoViewController.h"

@interface TimeViewController () <UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) BigCircleView *departureView;
@property (nonatomic, strong) NextDeparturesView *bottomView;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) TimeEntity *timeObject;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSURLConnection *dataRequest;

@end

@implementation TimeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self applyAppearance];
    
    _timeObject = [TimeEntity new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appRestart:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [self loadData:[StationEntity prepareURLFrom:_currentStation To:_destinationStation onTime:[TimeEntity getNextDepartureTime:0]]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyAppearance
{
    self.title = @"Nejbližší odjezdy";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icn-Button-Info"] style:UIBarButtonItemStylePlain target:self action:@selector(showInfo)];
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Background"]];
    [self.view addSubview:backgroundImage];
    
    UIView *topView = [UIView new];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:topView];
    
    _bottomView = [NextDeparturesView new];
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    _bottomView.alpha = 0.1;
    [_bottomView.circle3.nextButton addTarget:self action:@selector(loadNextTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomView];
    
    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ticketButton.translatesAutoresizingMaskIntoConstraints = NO;
    ticketButton.titleLabel.textColor = [UIColor whiteColor];
    [ticketButton setTitleColor:[MbAppearanceManager MBBlueColor] forState:UIControlStateHighlighted];
    ticketButton.titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:16];
    [ticketButton setTitle:@"Koupit jízdenku" forState:UIControlStateNormal];
    [ticketButton addTarget:self action:@selector(showTicketOptions) forControlEvents:UIControlEventTouchUpInside];
    [ticketButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGBAValues(185, 223, 237, 20)] forState:UIControlStateNormal];
    [self.view addSubview:ticketButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_bottomView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(_bottomView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[ticketButton]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(ticketButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topView(330)][_bottomView][ticketButton(54)]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(topView, _bottomView, ticketButton)]];
    
    _departureView = [BigCircleView new];
    _departureView.translatesAutoresizingMaskIntoConstraints = NO;
    _departureView.routeLabel.text = [NSString stringWithFormat:@"%@ > %@", [self.currentStation.name uppercaseString], [self.destinationStation.name uppercaseString]];
    [topView addSubview:_departureView];
    
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:_departureView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterY multiplier:1.2 constant:0]];
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:_departureView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}


#pragma mark - func

- (void)showTicketOptions
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vyberte jízdenku"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"30 min za 24,- Kč",
                          @"90 min za 32,- Kč",
                          @"24 hod za 110,- Kč",
                          @"72 hod za 310,- Kč",
                          @"Zrušit",
                          nil];
    
    alert.tag = 0;
    [alert show];
}

#pragma mark - Tickets

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self sendSMS:@"DPT24" recipientList:[NSArray arrayWithObjects:@"90206", nil]];
            break;
            
        case 1:
            [self sendSMS:@"DPT32" recipientList:[NSArray arrayWithObjects:@"90206", nil]];
            break;
            
        case 2:
            [self sendSMS:@"DPT110" recipientList:[NSArray arrayWithObjects:@"90206", nil]];
            break;
            
        case 3:
            [self sendSMS:@"DPT310" recipientList:[NSArray arrayWithObjects:@"90206", nil]];
            break;
            
        default:
            break;
    }
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.navigationBar.tintColor = [UIColor blackColor];
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /*
     if (result == MessageComposeResultCancelled)
     NSLog(@"Message cancelled");
     else if (result == MessageComposeResultSent)
     NSLog(@"Message sent");
     else
     NSLog(@"Message failed");
     */
}

#pragma mark - data load

- (void)loadData: (NSURL *) urlPath
{
    if (_dataRequest) {
        [_dataRequest cancel];
        _dataRequest = nil;
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlPath cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    _dataRequest = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connection: (NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

- (void) connection: (NSURLConnection *) connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void) connection: (NSURLConnection *) connection didFailWithError:(NSError *)error
{
    [[LogService sharedInstance] logError:error];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
    NSString *htmlString = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    
    [_timeObject parseHtml:htmlString];
    
    [_departureView timeFormatted: [[self getRemainingTimeForTime:0] integerValue]];
    
    [self showViewForTime:[[self getRemainingTimeForTime:0] integerValue]];
    
    [self updateCounter];
}

- (void)showViewForTime: (NSInteger)time
{
    if (_departureView.loader.alpha == 1) {
        
        UILabel *targetLabel;
        if (time>0) {
            targetLabel = _departureView.titleLabel;
        }
        else {
            targetLabel = _departureView.inStationLabel;
        }
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _departureView.routeLabel.center = CGPointMake(_departureView.routeLabel.center.x, _departureView.routeLabel.center.y+50);
            _departureView.loader.alpha = 0;
            self.bottomView.circle3.nextButton.alpha = 1;
            
        } completion:^(BOOL finished){
            [_loader.layer removeAllAnimations];
            
            _departureView.routeLabel.transform = CGAffineTransformMakeTranslation(_departureView.routeLabel.center.x, _departureView.routeLabel.center.y+100);
            targetLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [UIView beginAnimations:@"showView" context:nil];
            targetLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            targetLabel.alpha = 1;
            [UIView commitAnimations];
        }];
        
        [UIView animateWithDuration:1.0 delay:0.4 options:0 animations:^{
            _departureView.progressView.alpha = 1;
            _bottomView.alpha = 1;
            _bottomView.circle1.titleLabel.alpha = 1;
            _bottomView.circle2.titleLabel.alpha = 1;
            _bottomView.circle3.nextButton.alpha = 1;
        } completion:nil];
    }
    else if ([self.bottomView.circle3.loader isAnimating]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.circle3.nextButton.alpha = 1;
            [self.bottomView.circle3.loader stopAnimating];
        }];
    }
}

- (IBAction)appBackground:(id)sender
{
    [_timer invalidate];
}

- (IBAction)appRestart:(id)sender
{
    [self updateCounter];
}

- (void)updateCounter
{
    [_timer invalidate];
    
    CGFloat progress = (300 - [[self getRemainingTimeForTime:0] floatValue])/300.0;
    [_departureView.progressView setProgress:progress animated:YES];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                               target:self
                                             selector:@selector(countDown)
                                             userInfo:nil
                                              repeats:YES];
    
    
}

- (void)countDown
{
    NSInteger time1 = [[self getRemainingTimeForTime:0] integerValue];
    NSInteger time2 = [[self getRemainingTimeForTime:1] integerValue];
    NSInteger time3 = [[self getRemainingTimeForTime:2] integerValue];
    
    if (time1 < -30) {
        [_timer invalidate];
        [self loadData:[StationEntity prepareURLFrom:_currentStation To:_destinationStation onTime:[TimeEntity getNextDepartureTime:0]]];
    }
    else if (time3 < -30) {
        [_timer invalidate];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        
        [_departureView timeFormatted:time1];
        [_bottomView.circle1 timeFormatted:time2];
        [_bottomView.circle2 timeFormatted:time3];
    }
}

- (NSNumber *)getRemainingTimeForTime: (NSInteger)index
{
    CGFloat remainingTime = [[_timeObject.regularDepartures objectAtIndex:index] timeIntervalSinceDate:[NSDate date]];
    
    if (remainingTime < -50000)
    {
        remainingTime += 86400;
    }
    
    return @(remainingTime);
}

- (void)loadNextTime
{
    NSInteger additionalTime = [[self getRemainingTimeForTime:0] integerValue]+200;
    
    if (additionalTime > 3000) {
        [[[UIAlertView alloc] initWithTitle:@"Nepřeháněj to!" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomView.circle3.nextButton.alpha = 0;
            self.bottomView.circle3.loader.alpha = 1;
            [self.bottomView.circle3.loader startAnimating];
        } completion:^(BOOL finished) {
           [self loadData:[StationEntity prepareURLFrom:_currentStation To:_destinationStation onTime:[TimeEntity getNextDepartureTime:additionalTime]]];
        }];
    }
}

- (void)showInfo
{
    InfoViewController *infoController = [InfoViewController new];
    infoController.reloadBlock = ^{
        [self updateCounter];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    infoController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:infoController];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
