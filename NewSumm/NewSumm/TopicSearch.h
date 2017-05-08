//
//  TopicSearch.h
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicSearch : NSObject

+(void)getTopic:(NSString*)topicId withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

@end
