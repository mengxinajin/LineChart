//
//  ViewController.m
//  LineChartDemo
//
//  Created by 孟现进 on 2020/5/21.
//  Copyright © 2020 孟现进. All rights reserved.
//

#import "ViewController.h"
#import "LineChartViewController.h"
#import "XJCarmViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(camral) name:@"carm" object:nil];//:@"carm" object:nil];
}
- (void)camral{
    XJCarmViewController *vc = [XJCarmViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)lineChartClick:(id)sender {
    LineChartViewController *lineVC = [[LineChartViewController alloc] init];
    
    [self.navigationController pushViewController:lineVC animated:YES];
}


@end
