//
//  WikipediaArticle.h
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WikipediaArticle : NSObject

@property NSString *title;
@property NSString *extract;
@property NSString *imageUrl;
@property NSString *_id;
@property NSString *articleCount;
@property UIImage *image;

-(WikipediaArticle*)initWithDictionary:(NSDictionary *)dictionary;



@end
