//
//  UITextView+ZGLimitCounter.m
//  ZGLimitCount
//
//  Created by offcn_zcz32036 on 2017/6/13.
//  Copyright © 2017年 offcn. All rights reserved.
//

#import "UITextView+ZGLimitCounter.h"
#import <objc/runtime.h>
static char limitCountKey;
static char labMarginKey;
static char labHeightKey;
@implementation UITextView (ZGLimitCounter)
+(void)load
{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")), class_getInstanceMethod(self.class, @selector(zglimitCount_swizzing_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(self.class, @selector(zglimitCount_swizzled_dealloc)));
}
-(void)zglimitCount_swizzled_dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:@"layer.borderWidth"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    [self zglimitCount_swizzled_dealloc];
}
-(void)zglimitCount_swizzing_layoutSubviews
{
    [self zglimitCount_swizzing_layoutSubviews];
    if (self.zg_limitCount) {
        UIEdgeInsets textContainerInset=self.textContainerInset;
        textContainerInset.bottom=self.zg_labHeight;
        self.contentInset=textContainerInset;
        CGFloat x=CGRectGetMinX(self.frame)+self.layer.borderWidth;
        CGFloat y =CGRectGetMaxY(self.frame)-self.contentInset.bottom-self.layer.borderWidth;
        CGFloat width=CGRectGetWidth(self.bounds)-self.layer.borderWidth*2;
        CGFloat height=self.zg_labHeight;
        self.zg_inputLimitLabel.frame=CGRectMake(x, y, width, height);
        if ([self.superview.subviews containsObject:self.zg_inputLimitLabel]) {
            return;
        }
        [self.superview insertSubview:self.zg_inputLimitLabel aboveSubview:self];
    }
}

-(NSInteger)zg_limitCount
{
    return [objc_getAssociatedObject(self, &limitCountKey)integerValue];
}

-(void)setZg_limitCount:(NSInteger)zg_limitCount
{
    objc_setAssociatedObject(self, &limitCountKey, @(zg_limitCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}

-(CGFloat)zg_labMargin
{
    return [objc_getAssociatedObject(self, &labMarginKey)floatValue];
}
-(void)setZg_labMargin:(CGFloat)zg_labMargin
{
    objc_setAssociatedObject(self, &labMarginKey, @(zg_labMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}
-(CGFloat)zg_labHeight
{
    return [objc_getAssociatedObject(self, &labHeightKey)floatValue];
}
-(void)setZg_labHeight:(CGFloat)zg_labHeight
{
    objc_setAssociatedObject(self, &labHeightKey, @(zg_labHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}
-(void)configTextView
{
    self.zg_labHeight=20;
    self.zg_labMargin=10;
}
-(void)updateLimitCount
{
    if (self.text.length>self.zg_limitCount) {
        self.text=[self.text substringToIndex:self.zg_limitCount];
    }
    NSString *showText=[NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.text.length,(long)self.zg_limitCount];
    self.zg_inputLimitLabel.text=showText;
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc]initWithString:showText];
    NSUInteger length=[showText length];
    NSMutableParagraphStyle *style=[[NSParagraphStyle defaultParagraphStyle]mutableCopy];
    style.tailIndent=-self.zg_labMargin;//与尾部的距离
    style.alignment=NSTextAlignmentRight;//靠右显示
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    self.zg_inputLimitLabel.attributedText=attrString;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"layer.borderWidth"]) {
        [self updateLimitCount];
    }
}
-(UILabel *)zg_inputLimitLabel
{
    UILabel *label=objc_getAssociatedObject(self, @selector(zg_inputLimitLabel));
    if (!label) {
        label=[[UILabel alloc]init];
        label.backgroundColor=self.backgroundColor;
        label.textColor=[UIColor lightGrayColor];
        label.textAlignment=NSTextAlignmentRight;
        objc_setAssociatedObject(self, @selector(zg_inputLimitLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLimitCount) name:UITextViewTextDidChangeNotification object:self];
        [self addObserver:self forKeyPath:@"layer.borderwidth" options:NSKeyValueObservingOptionNew context:nil];
        [self configTextView];
    }
    return label;
}






















@end
