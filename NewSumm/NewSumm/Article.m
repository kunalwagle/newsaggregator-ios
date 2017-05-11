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
        NSArray *summary = [[dictionary objectForKey:@"summary"] objectAtIndex: 0];
        [self.summaries addObject:summary];
    }
    self._id = dictionary[@"id"];
    return self;
}

@end
