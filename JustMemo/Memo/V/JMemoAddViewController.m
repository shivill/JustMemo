//
//  JMemoAddViewController.m
//  JustMemo
//
//  Created by shivill on 2018/10/29.
//  Copyright © 2018年 StepForward. All rights reserved.
//

#import "JMemoAddViewController.h"
#import "JMemoData.h"

@interface JMemoAddViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UITextView *textView;
@property (nonatomic,strong) JMemoData *jMemoData;
@property (nonatomic,strong) NSString *setTime;

@end

@implementation JMemoAddViewController

- (JMemoData *)jMemoData
{
    if(_jMemoData == nil)
    {
        _jMemoData = [[JMemoData alloc] init];
    }
    return _jMemoData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //color for navigation bar
    [self navColor];
    
    //back button to previous view
    [self backBtn];
    
    //save button to save memo data
    [self saveBtn];
    
    //add textview
    [self initTextView];
    
    [self timeView];
}

- (void)navColor
{
    UIView * navColor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    navColor.backgroundColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:252/255.0 alpha:1];
    
    [self.view addSubview:navColor];
}

#pragma mark - back button and sender
- (void)backBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [backBtn setFrame:CGRectMake(5, 30, 60, 30)];
    
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    backBtn.tintColor = [UIColor whiteColor];
    
    [backBtn addTarget:self action:@selector(backToPreView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backToPreView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - save button & save

- (void)saveBtn
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [saveBtn setFrame:CGRectMake(self.view.frame.size.width -65, 30, 60, 30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    saveBtn.tintColor = [UIColor whiteColor];
    
    [saveBtn addTarget:self action:@selector(saveText:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
}

- (void)saveText:(id)sender
{
    self.jMemoData.data = self.textView.text;
    self.jMemoData.setTime = self.setTime;
    [self.jMemoData insertData:self.jMemoData];
    
    //back after saving
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - set text view
- (void)initTextView
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 120, self.view.frame.size.width-20, self.view.frame.size.height - 130)];
    
    textView.font = [UIFont systemFontOfSize:18];
    textView.layer.borderWidth = 1.5;
    textView.layer.borderColor = [[UIColor blackColor] CGColor];
    textView.layer.cornerRadius = 4.0f;
    textView.layer.masksToBounds = YES;
    //be able to bouceback at vertical
    textView.alwaysBounceVertical = YES;
    //first charactor,not capital
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    //init contend of textview
    
    self.textView = textView;
    
    //what does it meant?
    //self.textView.delegate = self;
    
    [self.view addSubview:textView];
    
    
}

- (void)timeView
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, self.view.frame.size.width-10*2, 30)];
    
    NSDateFormatter *nsDateFmt = [[NSDateFormatter alloc] init];
    [nsDateFmt setDateFormat:@"YYYY/MM/dd  HH:mm:ss"];
    
    NSDate *dateNow = [[NSDate alloc] init];
    
    NSString *currentTime = [nsDateFmt stringFromDate:dateNow];
    
    timeLabel.text = currentTime;
    self.setTime   = currentTime;
    
    [self.view addSubview:timeLabel];
}


@end
