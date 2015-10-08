//
//  DLWallPaper.h
//  WallPaper
//
//  Created by MaChunhui on 14-8-23.
//  Copyright (c) 2014年 MaChunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DLWallPaper : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * deviceType;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * imageicon;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * type_en;
@property (nonatomic, retain) NSString * type_zh;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * des;

@end
