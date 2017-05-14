//
//  Subscribe.h
//  NewSumm
//
//  Created by Kunal Wagle on 14/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subscribe : NSObject

+(void)subscribe:(NSString*)topicId withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

@end
