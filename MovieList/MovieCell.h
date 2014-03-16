//
//  MovieCell.h
//  MovieList
//
//  Created by David Ladowitz on 3/15/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsis;
@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;

@end
