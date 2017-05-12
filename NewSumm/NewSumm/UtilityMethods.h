//
//  UtilityMethods.h
//  NewSumm
//
//  Created by Kunal Wagle on 07/05/2017.
//  Copyright © 2017 Kunal Wagle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilityMethods : NSObject

+(NSString*)getIPAddress;
+(UICollectionViewFlowLayout*)getCollectionViewFlowLayout;
+(BOOL)isIPad;
+(UIColor*)getColour:(NSString*)source;
+(NSString*)getPublicationName:(NSString*)source;

@end
