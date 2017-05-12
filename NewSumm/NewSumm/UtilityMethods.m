//
//  UtilityMethods.m
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import "UtilityMethods.h"

@implementation UtilityMethods

+(NSString*)getIPAddress {
    return @"http://localhost:8182/api/";
}

+(UICollectionViewFlowLayout*)getCollectionViewFlowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:-10.0f];
    [flowLayout setMinimumLineSpacing:15.0f];
    [flowLayout setItemSize:CGSizeMake(315, 250)];
    flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    return flowLayout;
}

+(BOOL)isIPad {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

+(UIColor*)getColour:(NSString*)source {
    
    if ([source isEqualToString:@"the-guardian-uk"]) {
        return [UIColor colorWithRed:0 green:128 blue:128 alpha:0.4];
    }
    
    if ([source isEqualToString:@"independent"]) {
        return [UIColor colorWithRed:255 green:255 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"associated-press"]) {
        return [UIColor colorWithRed:144 green:238 blue:144 alpha:0.4];
    }
    
    if ([source isEqualToString:@"reuters"]) {
        return [UIColor colorWithRed:165 green:42 blue:42 alpha:0.4];
    }
    
    if ([source isEqualToString:@"business-insider-uk"]) {
        return [UIColor colorWithRed:0 green:128 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"daily-mail"]) {
        return [UIColor colorWithRed:128 green:0 blue:128 alpha:0.4];
    }
    
    if ([source isEqualToString:@"espn-cric-info"]) {
        return [UIColor colorWithRed:173 green:216 blue:230 alpha:0.4];
    }
    
    if ([source isEqualToString:@"metro"]) {
        return [UIColor colorWithRed:255 green:215 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"mirror"]) {
        return [UIColor colorWithRed:255 green:0 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"newsweek"]) {
        return [UIColor colorWithRed:255 green:0 blue:255 alpha:0.4];
    }
    
    if ([source isEqualToString:@"the-telegraph"]) {
        return [UIColor colorWithRed:0 green:0 blue:139 alpha:0.4];
    }
    
    if ([source isEqualToString:@"the-times-of-india"]) {
        return [UIColor colorWithRed:255 green:165 blue:0 alpha:0.4];
    }
    
    return NULL;
}

+(NSString*)getPublicationName:(NSString *)source {
    if ([source isEqualToString:@"the-guardian-uk"]) {
        return @"The Guardian";
    }
    
    if ([source isEqualToString:@"independent"]) {
        return @"The Independent";
    }
    
    if ([source isEqualToString:@"associated-press"]) {
        return @"Associated Press";
    }
    
    if ([source isEqualToString:@"reuters"]) {
        return @"Reuters";
    }
    
    if ([source isEqualToString:@"business-insider-uk"]) {
        return @"Business Insider";
    }
    
    if ([source isEqualToString:@"daily-mail"]) {
        return @"The Daily Mail";
    }
    
    if ([source isEqualToString:@"espn-cric-info"]) {
        return @"ESPN Cricinfo";
    }
    
    if ([source isEqualToString:@"metro"]) {
        return @"Metro";
    }
    
    if ([source isEqualToString:@"mirror"]) {
        return @"The Mirror";
    }
    
    if ([source isEqualToString:@"newsweek"]) {
        return @"Newsweek";
    }
    
    if ([source isEqualToString:@"the-telegraph"]) {
        return @"The Telegraph";
    }
    
    if ([source isEqualToString:@"the-times-of-india"]) {
        return @"The Times of India";
    }
    
    return NULL;
}

@end
