//
//  Settings.h
//  NewSumm
//
//  Created by Kunal Wagle on 15/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

+(void)settings:(NSDictionary*)items withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

@end
