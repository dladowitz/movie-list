//
//  Movie.h
//  MovieList
//
//  Created by David Ladowitz on 3/17/14.
//  Copyright (c) 2014 Little Cat Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

// Instance properties
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *thumbnail;

//Instance Methods
- (id)initWithDictionary:(NSDictionary *)dictionary;

// Class Methods
+ (NSArray *)moviesWithArray:(NSArray *)array;
@end
