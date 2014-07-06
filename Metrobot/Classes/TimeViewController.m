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

@interface TimeViewController () <UIAlertViewDelegate, MFMessageComposeViewControllerDelegate>

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self applyAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)applyAppearance
{
    self.title = @"Nejbližší odjezdy";
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Background"]];
    [self.view addSubview:backgroundImage];
    
    UIView *topView = [UIView new];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:topView];
    
    UIView *bottomView = [UIView new];
    bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bottomView];
    
    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ticketButton.translatesAutoresizingMaskIntoConstraints = NO;
    ticketButton.titleLabel.textColor = [UIColor whiteColor];
    [ticketButton setTitleColor:[MbAppearanceManager MBBlueColor] forState:UIControlStateHighlighted];
    ticketButton.titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:17];
    [ticketButton setTitle:@"Koupit jízdenku" forState:UIControlStateNormal];
    [ticketButton addTarget:self action:@selector(showTicketOptions) forControlEvents:UIControlEventTouchUpInside];
    [ticketButton setBackgroundImage:[UIImage imageWithColor:UIColorWithRGBAValues(185, 223, 237, 20)] forState:UIControlStateNormal];
    [self.view addSubview:ticketButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(bottomView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[ticketButton]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(ticketButton)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topView(330)][bottomView][ticketButton(54)]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(topView, bottomView, ticketButton)]];
    
    UIImageView *bigCircleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Round-Big"]];
    bigCircleView.translatesAutoresizingMaskIntoConstraints = NO;
    bigCircleView.alpha = 0.2;
    [topView addSubview:bigCircleView];
    
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:bigCircleView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterY multiplier:1.2 constant:0]];
    [topView addConstraint:[NSLayoutConstraint constraintWithItem:bigCircleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    UIView *bottomCenterView = [UIView new];
    bottomCenterView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:bottomCenterView];
    
    UIView *subTitleView = [UIView new];
    subTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomCenterView addSubview:subTitleView];
    
    UIImageView *arrowsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icn-Title-Next"]];
    arrowsImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [subTitleView addSubview:arrowsImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:17];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Další odjezdy";
    [subTitleView addSubview:titleLabel];
    
    [subTitleView addConstraint:[NSLayoutConstraint constraintWithItem:arrowsImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:subTitleView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [subTitleView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:subTitleView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [subTitleView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[arrowsImageView(18)]-[titleLabel]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(arrowsImageView, titleLabel)]];
    
    UIView *nextDeparturesView = [UIView new];
    nextDeparturesView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomCenterView addSubview:nextDeparturesView];

    [bottomCenterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[nextDeparturesView]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(nextDeparturesView)]];
    [bottomCenterView addConstraint:[NSLayoutConstraint constraintWithItem:subTitleView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomCenterView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    if (!IS_IPHONE4) {
        [bottomCenterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[subTitleView]-40-[nextDeparturesView(66)]-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(subTitleView, nextDeparturesView)]];
    }
    else {
        subTitleView.alpha = 0;
        [bottomCenterView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nextDeparturesView(66)]-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(nextDeparturesView)]];
    }
    
    UIImageView *smallCircleView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Round-Small"]];
    smallCircleView1.translatesAutoresizingMaskIntoConstraints = NO;
    smallCircleView1.alpha = 0.2;
    [nextDeparturesView addSubview:smallCircleView1];
    
    UIImageView *smallCircleView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Round-Small"]];
    smallCircleView2.translatesAutoresizingMaskIntoConstraints = NO;
    smallCircleView2.alpha = 0.2;
    [nextDeparturesView addSubview:smallCircleView2];
    
    UIImageView *smallCircleView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Round-Small"]];
    smallCircleView3.translatesAutoresizingMaskIntoConstraints = NO;
    smallCircleView3.alpha = 0.2;
    [nextDeparturesView addSubview:smallCircleView3];
    
    [nextDeparturesView addConstraint:[NSLayoutConstraint constraintWithItem:smallCircleView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:nextDeparturesView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [nextDeparturesView addConstraint:[NSLayoutConstraint constraintWithItem:smallCircleView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:nextDeparturesView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [nextDeparturesView addConstraint:[NSLayoutConstraint constraintWithItem:smallCircleView3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:nextDeparturesView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [nextDeparturesView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[smallCircleView1]-27-[smallCircleView2]-27-[smallCircleView3]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(smallCircleView1, smallCircleView2, smallCircleView3)]];
    
    [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:bottomCenterView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [bottomView addConstraint:[NSLayoutConstraint constraintWithItem:bottomCenterView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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

@end
