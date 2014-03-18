//
//  MovieCell.m
//  MovieList
//
//  Created by David Ladowitz on 3/15/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import "MovieCell.h"

@interface MovieCell ()
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsis;


@end

@implementation MovieCell


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

# pragma mark - Public Methods

- (void)setMovie:(Movie *)movie{
    _movie = movie;
    
    self.movieTitle.text = movie.title;
    self.movieSynopsis.text = movie.synopsis;
    
//    Add movie images here
//    [self.movieThumbnail setImageWithURL:[NSURL URLWithString:movie.thumbnail]];
}
@end
