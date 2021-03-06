//
//  ListViewController.m
//  MovieList
//
//  Created by David Ladowitz on 3/13/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import "ListViewController.h"
#import "DetailsViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "Reachability.h"



@interface ListViewController ()

//are the params on one of these backwards?
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property BOOL apiIsAvailable;

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    NSLog(@"Got to initWithNibName");
    };
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Newer custom cell stuff
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieCell" bundle:nil];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieTableCell"];
    
    
    // Pulldown animation
    UIRefreshControl *refreshAnimation = [[UIRefreshControl alloc] init];
    [refreshAnimation addTarget:self action:@selector(animate:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshAnimation];
    
    // Network Error controls
    [self.errorView setHidden:YES];
    
    NSLog(@"Testing Reachability");
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reaching: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"api.rottentomatoes.com"];
    
    reach.reachableBlock = ^(Reachability*reach)
    {
        self.apiIsAvailable = YES;
        [self.errorView setHidden:YES];
        NSLog(@"api is up");
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        self.apiIsAvailable = NO;
        [self.errorView setHidden:NO];
        NSLog(@"api is down!");
    };
    
    [reach startNotifier];
    
    // Configure the navigation bar title
    self.navigationItem.title = @"Top Box Office Movies";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    [self showSpinnerAnimation];

}


#pragma mark - Table view methods

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableCell" forIndexPath:indexPath];

    cell.movie = self.movies[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell %ld",(long)indexPath.row);
    
    // Display Alert Message
    MovieCell *cell = (MovieCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"choosing %@",cell.description);

    DetailsViewController *dvc = [[DetailsViewController alloc] init];
    dvc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


#pragma mark - API methods
- (void)getMoviesFromAPI {
    NSLog(@"Getting Movie List from Rotten Tomatoes");
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=re53qkp6bw9zp86m6zn7763x&limit=50&country=us";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data){
            NSDictionary *rottenTomatoesResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Finished API Call");
            self.movies = [Movie moviesWithArray:rottenTomatoesResults[@"movies"]];
            [self.tableView reloadData];
        }
    }];
};


#pragma mark - Loading Animation methods

- (void)showSpinnerAnimation {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self waitForTwoSeconds];
        [self getMoviesFromAPI];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)waitForTwoSeconds {
    sleep(2);
}


#pragma mark - Accessing Movie Details methods

- (void)onDetailsButton {
    
//    [self.navigationController pushViewController:[[DetailsViewController alloc] init] animated:YES];
}

- (void)animate:(UIRefreshControl *)refreshAnimation {
    [refreshAnimation endRefreshing];
    [self getMoviesFromAPI];
}

#pragma mark - System methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
