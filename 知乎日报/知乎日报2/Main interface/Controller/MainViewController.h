//
//  ViewController.h
//  知乎日报
//
//  Created by 张思扬 on 2022/10/12.
//

#import <UIKit/UIKit.h>
#import "MainView.h"

@interface MainViewController : UIViewController
<
pushToSetting,
NSCopying

>


- (void) pushControllerToSetting;

- (void) LayoutMainView;

@end

