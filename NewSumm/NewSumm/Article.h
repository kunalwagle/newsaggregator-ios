//
//  Article.h
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property NSArray *articles;
@property NSMutableArray *summaries;
@property NSString *_id;

-(Article*)initWithDictionary:(NSDictionary *)dictionary;

@end
