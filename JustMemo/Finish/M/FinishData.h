//
//  FinishData.h
//  JustMemo
//
//  Created by shivill on 2018/11/13.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinishData : NSObject

@property (nonatomic,assign) int ids;
@property (nonatomic,strong) NSString *data;
@property (nonatomic,strong) NSString *setTime;
@property (nonatomic,strong) NSString *finTime;
@property (nonatomic,assign) int level;


@end

NS_ASSUME_NONNULL_END
