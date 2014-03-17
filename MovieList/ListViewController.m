//
//  ListViewController.m
//  MovieList
//
//  Created by David Ladowitz on 3/13/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import "ListViewController.h"
#import "MovieCell.h"


@interface ListViewController ()

//are the params on one of these backwards?
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movieList;

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    };
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    return self.movieList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

// Using a custom UITableViewCell
    static NSString *movieTableIdentifier = @"MovieTableCell";
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:movieTableIdentifier];
    
    if (cell == nil)  {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MovieTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    cell.movieTitle.text = [NSString stringWithFormat:@"%@", self.movieList[indexPath.row][@"title"]];
//    cell.movieSynopsis.text = [NSString stringWithFormat:@"%@", self.movieList[indexPath.row][@"synopsis"]];
//
//    // Setting images
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.movieList[indexPath.row][@"posters"][@"thumbnail"]]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
//    
//    [cell.moviePoster setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        cell.moviePoster.image = image;
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        NSLog(@"Request failed with error: %@", error);
//    }];
    return cell;

    
// Using a default UITableViewCell
//    static NSString *movieTableIdentifier = @"MovieTableCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:movieTableIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:movieTableIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.movieList[indexPath.row][@"title"]];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.movieList[indexPath.row][@"synopsis"]];
//    
//    // Setting images
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", self.movieList[indexPath.row][@"posters"][@"thumbnail"]]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
//    
//    __weak UITableViewCell *weakCell = cell;
//    
//    [cell.imageView setImageWithURLRequest:request
//                          placeholderImage:placeholderImage
//                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                                       
//                                       weakCell.imageView.image = image;
//                                       [weakCell setNeedsLayout];
//                                       
//                                   } failure:nil];
//    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


#pragma mark - API methods
- (void)getMoviesFromAPI {
    NSLog(@"Getting Movie List from Rotten Tomatoes");
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=re53qkp6bw9zp86m6zn7763x&limit=50&country=us";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *rottenTomatoesResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.movieList = [rottenTomatoesResults objectForKey:@"movies"];
        [self.tableView reloadData];
    
        // Here are a bunch of ways to manipulate the returned dictionary.
        // Probably should put data into a model

        // puts movie titles into an array and prints to log
        NSMutableArray *movieTitles = [[NSMutableArray alloc] init];
        for (NSDictionary *movieData in self.movieList) {
            [movieTitles addObject: movieData[@"title"] ];
        }

        for (NSArray *movieTitle in movieTitles) {
           NSLog(@"%@", movieTitle);
        }
        
        // NSLog(@"%@", movieTitles);

        // prints title of first movie
        // NSLog(@"%@", [rottenTomatoesResults[@"movies"] objectAtIndex: 0][@"title"]   );
        
        // prints list of everything Rotten Tomatoes returned
        // NSLog(@"%@", rottenTomatoesResults);
        
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
    
    [self.navigationController pushViewController:[[DetailsViewController alloc] init] animated:YES];
}


#pragma mark - System methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
