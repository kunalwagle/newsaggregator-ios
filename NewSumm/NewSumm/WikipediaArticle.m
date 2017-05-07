//
//  WikipediaArticle.m
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "WikipediaArticle.h"

@implementation WikipediaArticle

-(WikipediaArticle*)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    self.title = dictionary[@"title"];
    self.extract = dictionary[@"extract"];
    self.imageUrl = dictionary[@"imageUrl"];
    self._id = dictionary[@"_id"];
    return self;
}

@end
