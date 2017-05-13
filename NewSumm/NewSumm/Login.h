//
//  Login.h
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject

+(void)login:(NSString*)emailAddress withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback;

@end
