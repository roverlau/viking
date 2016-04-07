//
//  MenuModel.h
//  Lunbo
//
//  Created by RoverLau on 16/4/6.
//  Copyright © 2016年 RoverLau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuModel : NSObject

@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *presentPrice;
@property (nonatomic,strong) NSString *commodityID;
@property (nonatomic,strong) NSString *commodityName;
@property (nonatomic,strong) NSString *originalPrice;

@end
