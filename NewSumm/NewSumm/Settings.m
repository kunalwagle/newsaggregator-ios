//
//  Settings.m
//  NewSumm
//
//  Created by Kunal Wagle on 15/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "Settings.h"
#import "UtilityMethods.h"

@implementation Settings

+(void)settings:(NSDictionary*)items withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSError *error;
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:items
                                               options:NSJSONWritingPrettyPrinted
                                                 error:&error];
    NSString *url = [UtilityMethods getIPAddress];
    url = [url stringByAppendingString:@"settings"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsondata length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsondata];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:callback] resume];
}



@end
