//
//  WikipediaSearch.m
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "WikipediaSearch.h"
#import "UtilityMethods.h"

@implementation WikipediaSearch

+(void)performSearch:(NSString *)searchTerm withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))callback {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [UtilityMethods getIPAddress];
    url = [url stringByAppendingString:@"wikipedia/"];
    url = [url stringByAppendingString:searchTerm];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:callback] resume];
}

@end
