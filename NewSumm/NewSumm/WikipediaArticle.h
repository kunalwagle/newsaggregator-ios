//
//  WikipediaArticle.h
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikipediaArticle : NSObject

@property NSString *title;
@property NSString *extract;
@property NSString *imageUrl;
@property NSString *_id;

-(WikipediaArticle*)initWithDictionary:(NSDictionary *)dictionary;



@end
