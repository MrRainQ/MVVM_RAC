//
//  RequestViewModel.h
//  MVVM-RAC
//
//  Created by qiupeng on 2018/5/31.
//  Copyright © 2018年 qiupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalHeader.h"

@interface RequestViewModel : NSObject<UITableViewDataSource>

@property (nonatomic, strong, readonly) RACCommand *requestCommand;

//模型数组
@property (nonatomic, strong, readonly) NSArray *models;

// 控制器中的view
@property (nonatomic, weak) UITableView *tableView;

@end
