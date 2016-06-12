//
//  STPickerView.h
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/26/15.
//  Copyright © 2015 Jiao Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger ,STPickerViewType) {
    STPickerViewTypeEducation, //学历
    STPickerViewTypeEnterSchoolYear, //入学年份
    STPickerViewTypeGender //性别
};

@protocol STPickerViewDelegate;

@interface STPickerView : NSObject<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,weak) id<STPickerViewDelegate> delegate;
@property (nonatomic,assign) STPickerViewType currentPickerViewType;

+ (instancetype)shardPickerView;

- (instancetype)initDatePickerOfBirthday:(UIView *)superView scrollView:(UIScrollView *)scrollView appear:(void (^)(BOOL isShow))pickerAppear;
- (instancetype)initCommonPickerView:(UIView *)superView scrollView:(UIScrollView *)scrollView  type:(STPickerViewType)type otherArr:(NSArray *)webArr appear:(void (^)(BOOL isShow))pickerAppear;
@end

@protocol STPickerViewDelegate <NSObject>

//common picker
- (void)pickerView:(STPickerView *)pickerView didSelectRow:(NSInteger)row WithSelectedString:(NSString *)selectedStr;

//data picker
- (void)pickerView:(STPickerView *)pickerView didSelectDate:(NSDate *)date;


@end
