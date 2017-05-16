//
//  Article.m
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "Article.h"

@implementation Article

-(Article*)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    self.articles = dictionary[@"articles"];
    self.summaries = dictionary[@"summaries"];
    self.summaryMap = dictionary[@"summaryMap"];
    if (!self.summaries) {
        self.summaries = [[NSMutableArray alloc] init];
        if ([[dictionary objectForKey:@"summary"] count]>0) {
        NSArray *summary = [[dictionary objectForKey:@"summary"] objectAtIndex: 0];
        [self.summaries addObject:summary];
        }
    }
    self._id = dictionary[@"id"];
    self.imageUrl = dictionary[@"imageUrl"];
    self.lastPublished = dictionary[@"lastPublished"];
    self.title = dictionary[@"title"];
    return self;
}

@end
