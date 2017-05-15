//
//  Unsubscribe.h
//  NewSumm
//
//  Created by Kunal Wagle on 15/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unsubscribe : NSObject

+(void)unsubscribe:(NSString*)topicId withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

@end
