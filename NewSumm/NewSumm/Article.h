//
//  Article.h
//  NewSumm
//
//  Created by Kunal Wagle on 08/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Article : NSObject

@property NSArray *articles;
@property NSMutableArray *summaries;
@property UIImage *image;
@property NSString *_id;
@property NSDictionary *summaryMap;
@property NSString *title;
@property NSString *lastPublished;
@property NSString *imageUrl;

-(Article*)initWithDictionary:(NSDictionary *)dictionary;

@end
