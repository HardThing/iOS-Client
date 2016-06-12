//
//  STSelectSchoolViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 9/2/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STSelectSchoolViewController.h"
#import "STSelectProvinceViewController.h"
#import "STUserLocation.h"
#import "PinYinForObjc.h"
NSString *const kSelectSchoolCellIndentifier = @"kSelectSchoolCellIndentifier";

@interface STSelectSchoolViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,STUserLocationDelegate>
{
    STUserLocation *location;
    NSMutableArray *detachHeader;
    BOOL isRequesting;
}
@property(nonatomic,strong) UITableView *selSchoolTableView;
@property(nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,copy) NSMutableArray *schoolArr;

@end

@implementation STSelectSchoolViewController

#pragma mark - LifeCycle

- (instancetype)initWithPassSchoolNameBlock:(STSelectSchoolNmae)block{
    
    if(self = [super init]){
        
        self.passSchoolName = block;
        
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initialUI];
    [self initalData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)initialUI{
    
    UITapGestureRecognizer *dismissKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    dismissKeyBoard.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:dismissKeyBoard];
    
    //定位
    location = [STUserLocation sharedLocation];
    location.delegate = self;
//    [self loadDataFromServer:15];
    
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.title = @"选择学校";
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:APPBULECOLOR forState:UIControlStateNormal];
    [backBtn setTitleColor:APPBULECOLOR forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem.tintColor = APPBULECOLOR;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
    NSString *rightItemStr = @"选择省份";
    if ([STUserManager getCurrentProvince]) {
        rightItemStr = [STUserManager getCurrentProvince];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightItemStr style:UIBarButtonItemStylePlain target:self action:@selector(manualSelectProvinceAction)];
    self.navigationItem.rightBarButtonItem.tintColor = APPBULECOLOR;
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.placeholder = @"输入学校名称或首字母";
    _searchBar.translucent = YES;
    _searchBar.delegate = self;
    _searchBar.keyboardType = UIReturnKeySearch;
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.leading.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    
    _selSchoolTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
    _selSchoolTableView.delegate = self;
    _selSchoolTableView.dataSource = self;
    [self.view addSubview:_selSchoolTableView];
    
}
#pragma mark - Data

- (void)initalData{
    
   
}

- (void)loadDataFromServer:(NSInteger)provinceId ProvinceName:(NSString *)provinceName{
    
    if (isRequesting) {
        return ;
    }
    if([provinceName isEqualToString:[STUserManager getCurrentProvince]] && _schoolArr){
        return ;
    }
    
    isRequesting = YES;
    [[STHTTPRequest sharedClient] getPath:STBASEDATA_PROVINCE_SCHOOL(provinceId) token:nil parameters:nil showProgressView:nil showText:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *tempAllData = [NSMutableArray array];
        NSMutableArray *tempAllDict = [NSMutableArray array];
        for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
            [tempAllData addObject:[dict objectForKey:@"name"]];
            [tempAllDict addObject:dict];
        }
        
        //引入变量检测是否已包含头
        _schoolArr = [NSMutableArray array];
        detachHeader = [NSMutableArray array];
        for (NSDictionary *school in tempAllDict) {
            NSMutableDictionary *groupDict = [NSMutableDictionary dictionary];
            
            NSString *tempPinYinHeader = [[[PinYinForObjc chineseConvertToPinYinHead:[school objectForKey:@"name"]] substringToIndex:1] uppercaseString];
            
            if ([detachHeader containsObject:tempPinYinHeader]) {
                continue;
            }
            [detachHeader addObject:tempPinYinHeader];
            NSMutableArray *pinYinArr = [NSMutableArray array];
            
            [groupDict setObject:tempPinYinHeader forKey:@"key"];
            for (NSDictionary *schoolDict in tempAllDict) {
                if ([tempPinYinHeader isEqualToString:[[[PinYinForObjc chineseConvertToPinYinHead:[schoolDict objectForKey:@"name"]] substringToIndex:1] uppercaseString]]) {
                    [pinYinArr addObject:schoolDict];
                }
                continue;
            }
            [groupDict setObject:pinYinArr forKey:@"data"];
            [_schoolArr addObject:groupDict];
            
            
        }
        
        // 排序
        NSArray *sortedArr = [_schoolArr sortedArrayUsingComparator:^(NSMutableDictionary *obj1,NSMutableDictionary *obj2) {
            NSString *num1 =[obj1 objectForKey:@"key"];
            NSString *num2 =[obj2 objectForKey:@"key"];
            return (NSComparisonResult) [num1 compare:num2 options:(NSNumericSearch)];
        }];
        _schoolArr = [NSMutableArray arrayWithArray:sortedArr];
        
        NSArray *indexArr = [detachHeader sortedArrayUsingComparator:^(NSString *obj1,NSString *obj2) {
            
            return (NSComparisonResult) [obj1 compare:obj2 options:(NSNumericSearch)];
        }];
        detachHeader = [NSMutableArray arrayWithArray:indexArr];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_selSchoolTableView reloadData];
            isRequesting = NO;
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - PrivateMethod

- (void)dismissKeyboard{
    
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - ActionMethod

- (void)backAction{
    
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)manualSelectProvinceAction{

    STSelectProvinceViewController *selectProvinceVC = [[STSelectProvinceViewController alloc]init];
    [self.navigationController pushViewController:selectProvinceVC animated:YES];
    
    
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.passSchoolName([[[[_schoolArr objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"name"]);
    [self backAction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _schoolArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_schoolArr objectAtIndex:section] objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:kSelectSchoolCellIndentifier];
    if (!normalCell) {
        normalCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSelectSchoolCellIndentifier];
    }
    normalCell.textLabel.text = [[[[_schoolArr objectAtIndex:indexPath.section] objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    return normalCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_schoolArr objectAtIndex:section] objectForKey:@"key"];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
   
    return detachHeader;
}

- (NSInteger )tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{

    return index;
}

#pragma mark - STUserLocationDelegate

- (void)autoLoationCity:(NSString *)currentCity{
    
    if (!currentCity) {
        return;
    }
    [self refreshNavgationRightItem:currentCity];

    if ( [[STUserManager getCurrentProvince] isEqualToString:currentCity]) {
        //加载已存储省份
        [self loadDataFromServer:1 ProvinceName:[STUserManager getCurrentProvince]];
        return ;
    }
    
    //先设置测试省份为四川 接口中id 为15
    [self loadDataFromServer:15 ProvinceName:currentCity];
    
    
}
#pragma mark - UISearchBar

#pragma mark - RefreshUI

- (void)refreshNavgationRightItem:(NSString *)currentCity{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:currentCity style:UIBarButtonItemStylePlain target:self action:@selector(manualSelectProvinceAction)];
    self.navigationItem.rightBarButtonItem.tintColor = APPBULECOLOR;
}

@end
