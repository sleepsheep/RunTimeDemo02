//
//  ViewController.m
//  runTimeDemo2
//
//  Created by yangL on 16/3/24.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "ViewController.h"
#import "ClassPropertyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ClassPropertyViewController *classVC = [[ClassPropertyViewController alloc] init];
    [self presentViewController:classVC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
