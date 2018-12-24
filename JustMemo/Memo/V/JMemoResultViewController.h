//
//  JMemoResultViewController.h
//  JustMemo
//
//  Created by shivill on 2018/12/18.
//  Copyright © 2018 StepForward. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JMemoData;
@protocol ResultDelegate <NSObject>
-(void)pushToEditView:(JMemoData *)jMemoData;
@end
@interface JMemoResultViewController : UITableViewController<UINavigationControllerDelegate>
@property (nonatomic,strong) NSMutableArray *searchResult;
@property (nonatomic,weak) id <ResultDelegate> resultDelegate;

@end

NS_ASSUME_NONNULL_END
