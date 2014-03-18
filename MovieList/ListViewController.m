//
//  ListViewController.m
//  MovieList
//
//  Created by David Ladowitz on 3/13/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import "ListViewController.h"
#import "Movie.h"
#import "MovieCell.h"



@interface ListViewController ()

//are the params on one of these backwards?
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;

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
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieTableCell" bundle:nil];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieTableCell"];
    
    
    // Configure the navigation bar title
    self.navigationItem.title = @"Top Box Office Movies";
    //Set navigation buttons on top nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Details" style:UIBarButtonItemStylePlain target:self action:@selector(onDetailsButton)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    [self showSpinnerAnimation];
//    [self getMoviesFromAPI];

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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 150;
//}


#pragma mark - API methods
- (void)getMoviesFromAPI {
    NSLog(@"Getting Movie List from Rotten Tomatoes");
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=re53qkp6bw9zp86m6zn7763x&limit=50&country=us";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *rottenTomatoesResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Finished API Call");
        
        self.movies = [Movie moviesWithArray:rottenTomatoesResults[@"movies"]];
        [self.tableView reloadData];

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


#pragma mark - System methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
