//
//  STSelectProvinceViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/28/15.
//  Copyright © 2015 Jiao Liu. All rights reserved.
//

#import "STSelectProvinceViewController.h"
#import "PinYinForObjc.h"
static NSString * const kSelectProvinceCellIndentifier = @"kSelectProvinceCellIndentifier";
@interface STSelectProvinceViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *indexArr;
    NSMutableArray *dataArr;
    NSMutableArray *totalDataArr;
}
@property(nonatomic,strong) UITableView *selProvinceTableView;
@property(nonatomic,strong) UISearchBar *searchBar;

@property(nonatomic,copy)NSDictionary *dataDict;

@end

@implementation STSelectProvinceViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialUI];
    [self initalData];
    [self loadDataFromServer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)initialUI{
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.title = @"选择省份";
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
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.placeholder = @"输入省份名称或首字母";
    _searchBar.translucent = YES;
    _searchBar.delegate = self;
    _searchBar.keyboardType = UIReturnKeySearch;
    [self.view addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.leading.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    
    _selProvinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + 64, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
    _selProvinceTableView.delegate = self;
    _selProvinceTableView.dataSource = self;
    [self.view addSubview:_selProvinceTableView];
    
    UITapGestureRecognizer *dismissKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    dismissKeyBoard.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:dismissKeyBoard];
    
}
#pragma mark - Data

- (void)initalData{
    
    indexArr = [NSMutableArray array];
    totalDataArr = [NSMutableArray array];
    dataArr = [NSMutableArray array];
    
    if (!self.autoLocationProvinceName) {
        
        [indexArr addObject:@"当前"];
        NSMutableDictionary *locationProvice = [NSMutableDictionary dictionary];
        [locationProvice setObject:@"四川" forKey:@"name"];
        [locationProvice setObject:[NSNumber numberWithInteger:15] forKey:@"id"];
        [dataArr addObject:locationProvice];
        [totalDataArr addObject:dataArr];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:totalDataArr forKey:@"dataArr"];
        [dict setObject:indexArr forKey:@"indexArr"];
        _dataDict = [NSDictionary dictionaryWithDictionary:dict];
        [_selProvinceTableView reloadData];
    }

}

- (void)loadDataFromServer{
    
    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    
    [[STHTTPRequest sharedClient]getPath:STBASEDATA_PROVINCE token:nil parameters:nil showProgressView:self.view showText:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //一个索引数组，一个省份数组。
        
        NSMutableArray *tempDataArr = [NSMutableArray array];
        for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
            [tempDataArr addObject:dict];
        }
        
        indexArr = [NSMutableArray array];
        totalDataArr = [NSMutableArray array];
        dataArr = [NSMutableArray array];
        
        for (NSDictionary *dict in tempDataArr) {
            NSString *PinYinHeader = [[[PinYinForObjc chineseConvertToPinYinHead:[dict objectForKey:@"name"]] substringToIndex:1] uppercaseString];
            if ([indexArr containsObject:PinYinHeader]) {
                continue ;
            }
            
            dataArr = [NSMutableArray array];
            [indexArr addObject:PinYinHeader];
            for (NSDictionary *dict in tempDataArr) {
                NSString *tempPinYinHeader = [[[PinYinForObjc chineseConvertToPinYinHead:[dict objectForKey:@"name"]] substringToIndex:1] uppercaseString];
                if ([tempPinYinHeader isEqualToString:PinYinHeader]) {
                    [dataArr addObject:dict];
                    continue;
                }
            }
            NSArray *sortedArr = [dataArr sortedArrayUsingComparator:^(NSMutableDictionary *obj1,NSMutableDictionary *obj2) {
                NSString *num1 =[obj1 objectForKey:@"name"];
                NSString *num2 =[obj2 objectForKey:@"name"];
                return (NSComparisonResult) [num1 compare:num2 options:(NSNumericSearch)];
            }];
            [totalDataArr addObject:sortedArr];
            
        }
        
        NSArray *sortedIndexArr = [indexArr sortedArrayUsingComparator:^(NSString *obj1,NSString *obj2) {
            
            return (NSComparisonResult) [obj1 compare:obj2 options:(NSNumericSearch)];
        }];
        
        //排好序的数组中加入当前地区
        NSMutableArray *insertCurrentProvince = [NSMutableArray arrayWithArray:totalDataArr];
        NSMutableArray *insertCurrentProvinceIndex = [NSMutableArray arrayWithArray:sortedIndexArr];
        
        [insertCurrentProvinceIndex insertObject:@"当前" atIndex:0];
        
        NSMutableDictionary *locationProvice = [NSMutableDictionary dictionary];
        [locationProvice setObject:@"四川" forKey:@"name"];
        [locationProvice setObject:[NSNumber numberWithInteger:15] forKey:@"id"];
        [insertCurrentProvince insertObject:[NSArray arrayWithObject:locationProvice] atIndex:0];

        [returnDict setObject:insertCurrentProvince forKey:@"dataArr"];
        [returnDict setObject:insertCurrentProvinceIndex forKey:@"indexArr"];
        _dataDict = [NSDictionary dictionaryWithDictionary:returnDict];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.selProvinceTableView reloadData];
        });
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark -LazyLoad

#pragma mark - PrivateMethod

- (void)dismissKeyboard{
    
    [self.view endEditing:YES];
}

#pragma mark - ActionMethod

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[_dataDict objectForKey:@"dataArr"] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_dataDict objectForKey:@"dataArr"] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:kSelectProvinceCellIndentifier];
    if (!normalCell) {
        normalCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kSelectProvinceCellIndentifier];
    }
     normalCell.textLabel.text = [[[[_dataDict objectForKey:@"dataArr"] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"name"];
    return normalCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[_dataDict objectForKey:@"indexArr"] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [_dataDict objectForKey:@"indexArr"];
}

- (NSInteger )tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSLog(@"title--%@,index-%ld",title,index);
    return index;
}

@end
