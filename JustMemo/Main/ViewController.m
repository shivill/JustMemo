//
//  ViewController.m
//  JustMemo
//
//  Created by shivill on 2018/10/15.
//  Copyright © 2018年 StepForward. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"hello test");
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    
    self.selectedIndex = 1;
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //set bar tint color
    [navBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1]];
    
    [navBar setBarStyle:UIBarStyleBlack];
    
    //set color for navagation view's 'back' button (on the left of that view
    navBar.tintColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
