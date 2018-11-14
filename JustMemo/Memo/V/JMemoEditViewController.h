//
//  JMemoEditViewController.h
//  JustMemo
//
//  Created by shivill on 2018/11/4.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BackDelegate <NSObject>
-(void)returnToPreView;
@end

@interface JMemoEditViewController : UIViewController
@property (nonatomic,assign) int ids;
@property (nonatomic,weak) id <BackDelegate> backDelegate;
@end

NS_ASSUME_NONNULL_END
