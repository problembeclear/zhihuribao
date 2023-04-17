//
//  CellViewController.h
//  知乎日报2
//
//  Created by 张思扬 on 2022/11/5.
//

#import <UIKit/UIKit.h>
#import "FMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface CellViewController : UIViewController


@property (strong, nonatomic) NSDictionary* testDictionary;

@property (strong, nonatomic) NSMutableArray* testArray;

@property (strong, nonatomic) NSIndexPath* testIndex;

@property (strong, nonatomic) NSString* stringMutable;

@property (strong, nonatomic) NSMutableArray* arrayToStoreDictionary;

@property (assign) NSInteger page;



@end

NS_ASSUME_NONNULL_END
