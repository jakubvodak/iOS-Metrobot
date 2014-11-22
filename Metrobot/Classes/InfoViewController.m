//
//  InfoViewController.m
//  Metrobot
//
//  Created by Jakub Vodak on 8/3/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

#import "InfoViewController.h"
#import "PersonTableViewCell.h"

@interface InfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InfoViewController

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
    
    self.title = @"O Metrobotovi";
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Img-Background"]];
    [self.view addSubview:backgroundImage];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[PersonTableViewCell class] forCellReuseIdentifier:@"PersonCell"];
    [self.view addSubview:self.tableView];
    
    UIImage *navBarImg = [UIImage imageNamed:@"Img-NavBar-Bg"];
    UIImageView *navBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, navBarImg.size.width, navBarImg.size.height)];
    navBarBg.image = navBarImg;
    [self.view addSubview:navBarBg];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icn-Back"] style:UIBarButtonItemStylePlain target:self action:@selector(closeInfo)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)];
    self.tableView.tableHeaderView = headerView;
    
    UIButton *strvLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    strvLogo.translatesAutoresizingMaskIntoConstraints = NO;
    [strvLogo setImage:[UIImage imageNamed:@"Img-Company-Logo"] forState:UIControlStateNormal];
    [strvLogo addTarget:self action:@selector(openWebBrowser) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:strvLogo];
    
    UILabel *subTitleLabel = [UILabel new];
    subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subTitleLabel.textColor = [UIColor whiteColor];
    subTitleLabel.font = [UIFont fontWithName:[MbAppearanceManager fontNameMedium] size:16];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.text = @"Vytvořeno společností STRV.";
    [headerView addSubview:subTitleLabel];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:strvLogo attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:subTitleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[strvLogo]-25-[subTitleLabel]->=0-|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(strvLogo, subTitleLabel)]];
    
    UIView *separator = [UIView new];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = UIColorWithRGBValues(72, 79, 83);
    [headerView addSubview:separator];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-25-[separator]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(separator)]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separator(0.5)]|" options:0 metrics:Nil views:NSDictionaryOfVariableBindings(separator)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeInfo
{
    self.reloadBlock();
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.photo.image = [UIImage imageNamed:@"Img-Kuba"];
            cell.aboutLabel.text = @"Vývoj";
            cell.nameLabel.text = @"Jakub Vodák";
            break;
        case 1:
            cell.photo.image = [UIImage imageNamed:@"Img-Pavel"];
            cell.aboutLabel.text = @"Design";
            cell.nameLabel.text = @"Pavel Zeifart";
            break;
        case 2:
            cell.photo.image = [UIImage imageNamed:@"Img-Adam"];
            cell.aboutLabel.text = @"Nápad";
            cell.nameLabel.text = @"Adam Vajdák";
            break;
        default:
            break;
    }
    
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

- (void)openWebBrowser
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.strv.com"]];
}

@end
