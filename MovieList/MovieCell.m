//
//  MovieCell.m
//  MovieList
//
//  Created by David Ladowitz on 3/15/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

@synthesize movieTitle = _movieTitle;
@synthesize movieSynopsis = _movieSynopsis;
@synthesize moviePoster = _moviePoster;


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
