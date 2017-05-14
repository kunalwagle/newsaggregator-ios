//
//  TopicSearch.m
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "TopicSearch.h"
#import "UtilityMethods.h"

@implementation TopicSearch

+(void)getTopic:(NSString *)topicId withHandler:(void (^)(NSData *, NSURLResponse *, NSError *))callback {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [UtilityMethods getIPAddress];
    url = [url stringByAppendingString:@"topic/"];
    url = [url stringByAppendingString:topicId];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"loggedIn"]) {
       NSString *emailAddress = [defaults objectForKey:@"emailAddress"];
       url = [url stringByAppendingString:@"/user/"];
       url = [url stringByAppendingString:emailAddress];
    }
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:callback] resume];
}

@end
