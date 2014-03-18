//
//  DetailsViewController.m
//  MovieList
//
//  Created by David Ladowitz on 3/17/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *movieFullSynopsis;
@property (weak, nonatomic) IBOutlet UILabel *castLabel;

@end

@implementation DetailsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.movieName.text = self.movie.title;
    self.movieFullSynopsis.text = self.movie.synopsis;
    self.castLabel.text = self.movie.cast;
    NSURL *imageUrl = [NSURL URLWithString:self.movie.thumbnail];
    UIImage *placeholderImage = [UIImage imageNamed:@"MoviePlaceholder"];
    [self.movieImage setImageWithURL:imageUrl placeholderImage:placeholderImage];
    
    self.navigationItem.title = self.movie.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
