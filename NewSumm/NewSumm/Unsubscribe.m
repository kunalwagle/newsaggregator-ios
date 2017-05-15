//
//  Unsubscribe.m
//  NewSumm
//
//  Created by Kunal Wagle on 15/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "Unsubscribe.h"
#import "UtilityMethods.h"

@implementation Unsubscribe

+(void)unsubscribe:(NSString *)topicId withHandler:(void (^)(NSData *, NSURLResponse *, NSError *))callback {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *emailAddress = [defaults objectForKey:@"emailAddress"];
    NSString *url = [UtilityMethods getIPAddress];
    url = [url stringByAppendingString:@"user/unsubscribe/"];
    url = [url stringByAppendingString:emailAddress];
    url = [url stringByAppendingString:@"/"];
    url = [url stringByAppendingString:topicId];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:callback] resume];
}


@end
