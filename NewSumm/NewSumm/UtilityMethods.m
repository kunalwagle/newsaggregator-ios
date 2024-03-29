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
    return @"http://178.62.27.53:8182/api/";
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
        return [UIColor colorWithRed:0 green:128.0/255.0 blue:128.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"independent"]) {
        return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"associated-press"]) {
        return [UIColor colorWithRed:144.0/255.0 green:238.0/255.0 blue:144.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"reuters"]) {
        return [UIColor colorWithRed:165.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"business-insider-uk"]) {
        return [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"daily-mail"]) {
        return [UIColor colorWithRed:128.0/255.0 green:0 blue:128.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"espn-cric-info"]) {
        return [UIColor colorWithRed:173.0/255.0 green:216.0/255.0 blue:230.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"metro"]) {
        return [UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"mirror"]) {
        return [UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"newsweek"]) {
        return [UIColor colorWithRed:255.0/255.0 green:0 blue:255.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"the-telegraph"]) {
        return [UIColor colorWithRed:0 green:0 blue:139.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"the-times-of-india"]) {
        return [UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"bbc-news"]) {
        return [UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"bbc-sport"]) {
        return [UIColor colorWithRed:1.0 green:215.0/255.0 blue:0.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"bloomberg"]) {
        return [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"cnbc"]) {
        return [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"cnn"]) {
        return [UIColor colorWithRed:178.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"espn"]) {
        return [UIColor colorWithRed:60.0/255.0 green:179.0/255.0 blue:113.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"four-four-two"]) {
        return [UIColor colorWithRed:205.0/255.0 green:133.0/255.0 blue:63.0/255.0 alpha:0.4];
    }
    
    if ([source isEqualToString:@"the-washington-post"]) {
        return [UIColor colorWithRed:70.0/255.0 green:130.0/255.0 blue:180.0/255.0 alpha:0.4];
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
    
    if ([source isEqualToString:@"bbc-news"]) {
        return @"BBC News";
    }
    
    if ([source isEqualToString:@"bbc-sport"]) {
        return @"BBC Sport";
    }
    
    if ([source isEqualToString:@"bloomberg"]) {
        return @"Bloomberg";
    }
    
    if ([source isEqualToString:@"cnbc"]) {
        return @"CNBC";
    }
    
    if ([source isEqualToString:@"cnn"]) {
        return @"CNN";
    }
    
    if ([source isEqualToString:@"espn"]) {
        return @"ESPN";
    }
    
    if ([source isEqualToString:@"four-four-two"]) {
        return @"FourFourTwo";
    }
    
    if ([source isEqualToString:@"the-washington-post"]) {
        return @"The Washington Post";
    }
    
    return NULL;
}

+(UIColor *)getBackgroundColor {
    return [UIColor colorWithRed:0.157 green:0.329 blue:0.424 alpha:1.0];
}

+(NSAttributedString*)getRefreshControlTimeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
}

@end
