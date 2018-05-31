//
//  RequestViewModel.m
//  MVVM-RAC
//
//  Created by qiupeng on 2018/5/31.
//  Copyright © 2018年 qiupeng. All rights reserved.
//

#import "RequestViewModel.h"
#import "AFNetworking.h"
#import "Book.h"

@implementation RequestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setUp];
    }
    return self;
    
}

- (void)setUp
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
            
            [mgr GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"基础"} success:^(AFHTTPRequestOperation * _Nonnull operation, NSDictionary * _Nonnull responseObject) {
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
                
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                
            }];
            
            return nil;
        }];
        
        // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
        return [requestSignal map:^id(NSDictionary *value) {
            NSMutableArray *dictArr = value[@"books"];
            // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                return [Book bookWithDict:value];
            }] array];
            return modelArr;
        }];
        
        
    }];
    
    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        // 有了新数据，刷新表格
        self->_models = x;
        // 刷新表格
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    Book *book = self.models[indexPath.row];
    cell.detailTextLabel.text = book.subtitle;
    cell.textLabel.text = book.title;
    
    return cell;
}
@end
