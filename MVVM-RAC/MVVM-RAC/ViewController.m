//
//  ViewController.m
//  MVVM-RAC
//
//  Created by qiupeng on 2018/5/31.
//  Copyright © 2018年 qiupeng. All rights reserved.
//

#import "ViewController.h"
#import "GlobalHeader.h"
#import "RequestViewModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RequestViewModel *requestVM;

@end

@implementation ViewController

- (RequestViewModel *)requestVM
{
    if (_requestVM == nil) {
        _requestVM = [[RequestViewModel alloc] init];
    }
    return _requestVM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self.requestVM;
    self.requestVM.tableView = self.tableView;
    
    [self.requestVM.requestCommand execute:nil];

}




@end
