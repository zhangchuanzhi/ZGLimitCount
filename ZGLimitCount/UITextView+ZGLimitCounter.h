//
//  UITextView+ZGLimitCounter.h
//  ZGLimitCount
//
//  Created by offcn_zcz32036 on 2017/6/13.
//  Copyright © 2017年 offcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (ZGLimitCounter)
/**限制字数*/
@property(nonatomic,assign)NSInteger zg_limitCount;
/**右边距*/
@property(nonatomic,assign)CGFloat zg_labMargin;
/**高度*/
@property(nonatomic,assign)CGFloat zg_labHeight;
/**统计限制字数*/
@property(nonatomic,readonly)UILabel *zg_inputLimitLabel;
@end
