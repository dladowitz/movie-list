
//  Movie.m
//  MovieList
//
//  Created by David Ladowitz on 3/17/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.synopsis = dictionary[@"synopsis"];
        self.thumbnail = dictionary[@"posters"][@"thumbnail"];
    }
    return self;
}

+ (NSArray *)moviesWithArray:(NSArray *)array {
    NSLog(@"Starting moviesWithArray");
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        NSLog(@"%@", movie.title);
//        NSLog(@"%@", movie.thumbnail);
        [movies addObject:movie];
    }
    NSLog(@"Finishing moviesWithArray");
    return movies
    ;
}

@end
