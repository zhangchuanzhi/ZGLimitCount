//
//  ViewController.m
//  ZGLimitCount
//
//  Created by offcn_zcz32036 on 2017/6/13.
//  Copyright © 2017年 offcn. All rights reserved.
//

#import "ViewController.h"
#import "UITextView+ZGLimitCounter.h"
@interface ViewController ()
@property(nonatomic,strong) UITextView*textView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self textView];
}
-(UITextView *)textView
{
    if (!_textView) {
        _textView=[[UITextView alloc]initWithFrame:CGRectMake(20, 64+20, [UIScreen mainScreen].bounds.size.width-40, 180)];
        _textView.layer.borderWidth=1;
        _textView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _textView.zg_limitCount=200;
        _textView.zg_labHeight=30;
        [self.view addSubview:_textView];
    }
    return _textView;
}

@end
