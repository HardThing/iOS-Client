//
//  STPickerView.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/26/15.
//  Copyright © 2015 Jiao Liu. All rights reserved.
//

#import "STPickerView.h"

@interface STPickerView()

@property(nonatomic,strong)UIPickerView *commonPickerView;
@property(nonatomic,strong)UIDatePicker *birthdayPickerView;
@property(nonatomic,strong)UIView *containerDatePickerView;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,copy)NSArray *commonPickerViewData;
@property(nonatomic,strong)UIScrollView *superView;
//@property(nonatomic,assign)STPickerViewType type;

@end
@implementation STPickerView

+ (instancetype)shardPickerView{
    
    static STPickerView *sharedPickerView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPickerView = [[STPickerView alloc] init];
    });
    return sharedPickerView;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - CommonPickerView

// webArr 网络上请求得来的学校，专业相关数据。
- (instancetype)initCommonPickerView:(UIView *)superView scrollView:(UIScrollView *)scrollView type:(STPickerViewType)type otherArr:(NSArray *)webArr appear:(void (^)(BOOL isShow))pickerAppear{
    
    self.superView = scrollView;
    
    if (_containerDatePickerView){
        [_containerDatePickerView removeFromSuperview];
        _containerDatePickerView = nil;
        pickerAppear(NO);
    }
    if (_maskView) {
        [_maskView removeFromSuperview];
        _maskView = nil;
        pickerAppear(NO);
    }
    _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.backgroundColor = [UIColor lightGrayColor];
    _maskView.alpha = 0.6;
    [superView addSubview:_maskView];
    self.currentPickerViewType = type;

    switch (type) {
        case STPickerViewTypeEducation:
        {
            self.commonPickerViewData = @[@"专科",@"本科",@"研究生",@"博士"];
            
        }
            break;
        case STPickerViewTypeEnterSchoolYear:
        {
            NSMutableArray *yearArr = [NSMutableArray array];
            for (NSInteger i = 1970; i <= 2015; i++) {
                [yearArr addObject:[NSString stringWithFormat:@"%ld",i]];
            }
            
            self.commonPickerViewData = [NSArray arrayWithArray:yearArr];
            
        }
            break;
        case STPickerViewTypeGender:
        {
            self.commonPickerViewData = @[@"女",@"男"];
        }
            
            break;
        default:
            break;
    }
    
    _containerDatePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250 + 250,SCREEN_WIDTH, 250)];
    _containerDatePickerView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:_containerDatePickerView];
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 35)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelButton setTitleColor:APPBULECOLOR forState:UIControlStateNormal];
    [_containerDatePickerView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 35)];
    [sureButton setTitle:@"请选择，数据将自动同步" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [sureButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_containerDatePickerView addSubview:sureButton];
    [sureButton addTarget:self action:@selector(ensureSelectCommon) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:APPBULECOLOR forState:UIControlStateNormal];
    [_containerDatePickerView addSubview:sureButton];
    
    self.commonPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 215)];
    [_containerDatePickerView addSubview:self.commonPickerView];
    self.commonPickerView.delegate = self;
    self.commonPickerView.dataSource = self;
    self.commonPickerView.backgroundColor = [UIColor whiteColor];
    [self.commonPickerView selectRow:[self.commonPickerViewData count] -1 inComponent:0 animated:NO];
    CGRect frame = _containerDatePickerView.frame;
    frame.origin.y -= 250;
    [UIView animateWithDuration:0.3 animations:^{
        _containerDatePickerView.frame = frame;
    }];
    pickerAppear(YES);
    return self;
}

- (void)ensureSelectCommon{
    
}

#pragma mark - DatePickerView

- (instancetype)initDatePickerOfBirthday:(UIView *)superView scrollView:(UIScrollView *)scrollView appear:(void (^)(BOOL isShow))pickerAppear{
    self.superView = scrollView;
    // Autolayout 需要一个父视图，实现不了，用frame
    if (_containerDatePickerView){
        [_containerDatePickerView removeFromSuperview];
        _containerDatePickerView = nil;
        pickerAppear(NO);
    }
    
    if (_maskView) {
        [_maskView removeFromSuperview];
        _maskView = nil;
        pickerAppear(NO);
    }
    
    _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.backgroundColor = [UIColor lightGrayColor];
    _maskView.alpha = 0.6;
    [superView addSubview:_maskView];
    _containerDatePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250 + 250,SCREEN_WIDTH, 250)];
    [superView addSubview:_containerDatePickerView];
    _containerDatePickerView.backgroundColor = [UIColor whiteColor];
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 35)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:APPBULECOLOR forState:UIControlStateNormal];
    [_containerDatePickerView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, 35)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:APPBULECOLOR forState:UIControlStateNormal];
    [_containerDatePickerView addSubview:sureButton];
    [sureButton addTarget:self action:@selector(ensureSelectDate) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_containerDatePickerView addSubview:sureButton];
    
    self.birthdayPickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 215)];
    [_containerDatePickerView addSubview:self.birthdayPickerView];
    self.birthdayPickerView.datePickerMode = UIDatePickerModeDate;
    self.birthdayPickerView.backgroundColor = [UIColor whiteColor];
    self.birthdayPickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self.birthdayPickerView addTarget:self action:@selector(updateDatePicker) forControlEvents:UIControlEventValueChanged];

    CGRect frame = _containerDatePickerView.frame;
    frame.origin.y -= 250;
    [UIView animateWithDuration:0.3 animations:^{
        _containerDatePickerView.frame = frame;
    }];
    pickerAppear(YES);
    return self;
}

- (void)ensureSelectDate{
    
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectDate:)]) {
        [self.delegate pickerView:self didSelectDate:self.birthdayPickerView.date];
    }
    [self dismissPickerView];
}

#pragma mark - PrivateMethod

- (void)dismissPickerView{
    if (_containerDatePickerView) {
        CGRect frame = _containerDatePickerView.frame;
        frame.origin.y += 260;
        [UIView animateWithDuration:0.8 animations:^{
            _containerDatePickerView.frame = frame;
        }];
        [_containerDatePickerView removeFromSuperview];
    }
    if (_maskView) {
        [_maskView removeFromSuperview];
        _maskView = nil;
    }
    [self.superView setContentOffset:CGPointZero animated:YES];
}

- (void)updateDatePicker{

    if ([_birthdayPickerView.date compare:[NSDate date]] == NSOrderedDescending) {
        [_birthdayPickerView setDate:[NSDate date]];
    }
}
#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow: WithSelectedString:)]) {
        [self.delegate pickerView:self didSelectRow:row WithSelectedString:[self.commonPickerViewData objectAtIndex:row]];
    }
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (self.currentPickerViewType) {
        case STPickerViewTypeEducation:
        {
            return self.commonPickerViewData.count;
        }
        case STPickerViewTypeEnterSchoolYear:
        {
            return self.commonPickerViewData.count;
        }
        case STPickerViewTypeGender:
        {
            return self.commonPickerViewData.count;
        }
            
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    switch (self.currentPickerViewType) {
        case STPickerViewTypeEducation:
        {
            return 1;
        }
        case STPickerViewTypeEnterSchoolYear:
        {
            return 1;
        }
        case STPickerViewTypeGender:
        {
            return 1;
        }
        default:
            break;
    }
}

- (NSString* )pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (self.currentPickerViewType) {
            
        case STPickerViewTypeEducation:
        {
            return [self.commonPickerViewData objectAtIndex:row];
        }
        case STPickerViewTypeEnterSchoolYear:
        {
            return [self.commonPickerViewData objectAtIndex:row];
        }
        case STPickerViewTypeGender:
        {
            return [self.commonPickerViewData objectAtIndex:row];
        }
        default:
            break;
    }
    return nil;
}

@end
