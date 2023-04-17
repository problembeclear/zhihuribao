//
//  settingViewController.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/2.
//

#import <UIKit/UIKit.h>
#import "settingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface settingViewController : UIViewController <popReturn>

- (void) popToMainView;

@end

NS_ASSUME_NONNULL_END
