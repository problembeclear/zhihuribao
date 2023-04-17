//
//  ScrollViewController.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollViewController : UIViewController

@property (strong, nonatomic) NSDictionary* dictFromMainViewController;

@property (assign) NSInteger page;



@end

NS_ASSUME_NONNULL_END
