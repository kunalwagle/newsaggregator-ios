//
//  WikipediaSearch.h
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikipediaSearch : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+(void)performSearch:(NSString*)searchTerm withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

@end
