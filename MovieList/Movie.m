
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
        self.thumbnail = dictionary[@"posters"][@"original"];
        
        NSDictionary *cast = dictionary[@"abridged_cast"];
        NSMutableString *castNames = [NSMutableString string];
        
        for (NSDictionary* actor in cast) {
            [castNames appendFormat:@"%@, ",actor[@"name"]];
        }
        self.cast = castNames;
    }
    return self;
}

+ (NSArray *)moviesWithArray:(NSArray *)array {
    NSLog(@"Starting moviesWithArray");
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
//        NSLog(@"%@", movie.title);
        [movies addObject:movie];
    }
    NSLog(@"Finishing moviesWithArray");
    return movies
    ;
}

@end
