//
//  Login.m
//  NewSumm
//
//  Created by Kunal Wagle on 13/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "Login.h"
#import "UtilityMethods.h"

@implementation Login

+(void)login:(NSString *)emailAddress withHandler:(void (^)(NSData *, NSURLResponse *, NSError *))callback{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [UtilityMethods getIPAddress];
    url = [url stringByAppendingString:@"user/subscriptions/"];
    url = [url stringByAppendingString:emailAddress];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:callback] resume];
}

@end
