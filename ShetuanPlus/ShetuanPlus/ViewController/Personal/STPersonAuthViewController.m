//
//  STPersonAuthViewController.m
//  ShetuanPlus
//
//  Created by DUSTSKY on 10/10/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

#import "STPersonAuthViewController.h"
#import "STInsetTextField.h"

@interface STPersonAuthViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic,strong) UIImageView *authTakePhotoImageView;
@property (nonatomic,strong) UIScrollView *scrollView;
//已认证头像
//@property(nonatomic,strong) UIImageView *authImageView;

@end

@implementation STPersonAuthViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc]initWithFrame:SCREEN_FRAME];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 520);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;

    self.view.backgroundColor = BACKGROUND_COLOR;
    [self setNavBarButtonItem];
    [self initialUI];
    [self initialData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)setNavBarButtonItem{
    
    self.title = @"身份认证";
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
    
}

- (void)initialUI{
    
#warning Test
//    _authType = STUserAuthTypeAlready;
    
    if (_authType) {
        
        //认证布局
        //已认证图像
        UIImageView *authImageView = [[UIImageView alloc]init];
        
        [self.scrollView addSubview:authImageView];
        [authImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.scrollView).offset((SCREEN_WIDTH - 80) / 2);
            make.top.equalTo(self.scrollView).offset(40);
            make.size.mas_equalTo(CGSizeMake(80, 100));
        }];
        authImageView.image = [UIImage imageNamed:@"Personal_Certificatied"];
        
        //已认证信息
        UILabel *authMessage = [[UILabel alloc]init];
        authMessage.text = @"恭喜您，已通过身份认证";
        [self.scrollView addSubview:authMessage];
        authMessage.textColor = [UIColor redColor];
        authMessage.textAlignment = NSTextAlignmentCenter;
        authMessage.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0];
        [authMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(authImageView.mas_bottom);
            make.centerX.equalTo(self.scrollView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 66));
        }];
        
        //姓名
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"  *妮";
        nameLabel.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(authMessage.mas_bottom).offset(20);
            make.leading.equalTo(self.scrollView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        
        //分割线
        UILabel *separtorLine = [[UILabel alloc]init];
        [self.scrollView addSubview:separtorLine];
        [separtorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom);
            make.leading.equalTo(self.scrollView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        }];
        
        //身份证号
        UILabel *identifierLabel = [[UILabel alloc]init];
        identifierLabel.text = @"  20******13";
        identifierLabel.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:identifierLabel];
        [identifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(separtorLine.mas_bottom);
            make.leading.equalTo(self.scrollView);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        return;
    }
    
    //未认证界面布局
    //提示信息
    UILabel *tipMessageLable = [[UILabel alloc]init];
    [self.scrollView addSubview:tipMessageLable];
    [tipMessageLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 60));
    }];
    tipMessageLable.text = @"   通过身份认证，可以开启更多功能。";
    tipMessageLable.font = [UIFont systemFontOfSize:18.0];
    
    //姓名
    STInsetTextField *nameTextField = [[STInsetTextField alloc]init];
    nameTextField.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipMessageLable.mas_bottom);
        make.leading.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    nameTextField.placeholder = @"姓名";
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    //分割线
    UILabel *separtorLine = [[UILabel alloc]init];
    [self.scrollView addSubview:separtorLine];
    [separtorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom);
        make.leading.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    //学号
    STInsetTextField *indentifierLabel = [[STInsetTextField alloc]init];
    indentifierLabel.placeholder = @"学号";
    indentifierLabel.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:indentifierLabel];
    [indentifierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separtorLine.mas_bottom);
        make.leading.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    
    //拍照认证触发
    _authTakePhotoImageView = [[UIImageView alloc]init];
    _authTakePhotoImageView.image = [UIImage imageNamed:@"Person_IDCard"];
    _authTakePhotoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *authTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(authPhotoTapped)];
    [_authTakePhotoImageView addGestureRecognizer:authTap];
    [self.scrollView addSubview:_authTakePhotoImageView];
    [_authTakePhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indentifierLabel.mas_bottom).offset(20);
        make.leading.equalTo(self.scrollView).offset(20);
        make.size.mas_equalTo(CGSizeMake(80, 160));
    }];
    
    UILabel *rightTipMessageLabel = [[UILabel alloc]init];
    rightTipMessageLabel.textColor = [UIColor lightGrayColor];
    rightTipMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    rightTipMessageLabel.numberOfLines = 0;
    rightTipMessageLabel.text = @"请上传您的身份证正面与学生证个人信息页照片\n信息须清晰可见\n我们会严格保护您的隐私";
    [self.scrollView addSubview:rightTipMessageLabel];
    [rightTipMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indentifierLabel.mas_bottom).offset(20);
        make.leading.equalTo(_authTakePhotoImageView.mas_trailing).offset(20);
        make.size.mas_equalTo(CGSizeMake(200, 120));
    }];
    
    //上传照片
    UIButton *uploadImageButton = [[UIButton alloc]init];
    [uploadImageButton addTarget:self
                       action:@selector(uploadAuthMessageClick)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:uploadImageButton];
    [uploadImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightTipMessageLabel.mas_bottom);
        make.leading.equalTo(_authTakePhotoImageView.mas_trailing).offset(20);
        make.size.mas_equalTo(CGSizeMake(180, 40));
    }];
    [uploadImageButton setTitle:@"上传照片" forState:UIControlStateNormal];
    [uploadImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadImageButton setBackgroundColor:[UIColor greenColor]];
    
    //提交审核
    UIButton *commitButton = [[UIButton alloc]init];
    [self.scrollView addSubview:commitButton];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(uploadImageButton.mas_bottom).offset(40);
        make.leading.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    [commitButton setBackgroundColor:APPBULECOLOR];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton setTitle:@"提交审核" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitDataToServer) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Data

- (void)initialData{
    
}

#pragma mark - Handler

- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Method

- (void)commitDataToServer{
    
}
- (void)uploadAuthMessageClick{
    
    [self authPhotoTapped];
    NSLog(@"%s",__func__);
}

- (void)authPhotoTapped
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.scrollView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
            pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickController.allowsEditing = YES;
            pickController.delegate = self;
            [self presentViewController:pickController animated:YES completion:^{

            }];
        }
            break;
        case 1:
        {
            UIImagePickerController *pickController = [[UIImagePickerController alloc] init];
            pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickController.allowsEditing = YES;
            pickController.delegate = self;
            [self presentViewController:pickController animated:YES completion:^{

            }];
        }
            break;

        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!originImage) {
            originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        UIGraphicsBeginImageContext(CGSizeMake(120, 120));
        [originImage drawInRect:CGRectMake(0, 0, 120, 120)];
        _authTakePhotoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
