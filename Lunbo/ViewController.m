//
//  ViewController.m
//  Lunbo
//
//  Created by RoverLau on 16/4/6.
//  Copyright © 2016年 RoverLau. All rights reserved.
//

#import "ViewController.h"
#import "ActionView.h"
#import "AFNetworking.h"
#import "ScrollModel.h"
#import "MenuModel.h"
#import "UIImageView+WebCache.h"

#define  Scroll_url @"http://192.168.22.108:8080/platform/bannerContentUrl"
#define  Scroll_url2 @"http://192.168.22.108:8080/platform/products"
#define Shop @"http://192.168.22.108:8080/platform/productDetail"

#define LLG_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define LLG_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define NUM 8
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic)  NSMutableArray *dataImgArr,*dataMenuArr;
@property (nonatomic,assign)NSInteger currentTime;
@property UIScrollView *scrollView;
@property UIScrollView *scrollView2;
@property NSInteger page;

@end

@implementation ViewController


-(NSMutableArray *)dataImgArr{
    if (!_dataImgArr) {
        _dataImgArr = [NSMutableArray new];
    }
    return _dataImgArr;
}
-(NSMutableArray *)dataMenuArr{
    if (!_dataMenuArr) {
        _dataMenuArr = [NSMutableArray new];
    }
    return _dataMenuArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self requestData];
    [self requestMenuData];
    //功能
    [self gnMenu];
    //广告
    [self ad];
}


#pragma mark 轮播图
-(void)rollImage{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,LLG_SCREEN_WIDTH,LLG_SCREEN_WIDTH*0.4 )];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(LLG_SCREEN_WIDTH*self.dataImgArr.count, 0);
    for (int i = 0; i<self.dataImgArr.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*LLG_SCREEN_WIDTH, 0, LLG_SCREEN_WIDTH,LLG_SCREEN_WIDTH*0.4)];
        imgView.tag = 10+i;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg:)];
        [imgView addGestureRecognizer:tap];
        
        [_scrollView addSubview:imgView];
        
        ScrollModel *model = self.dataImgArr[i];

        [imgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];

        
    }
    
    
}
#pragma mark  请求网络数据
-(void)requestMenuData{
    AFHTTPRequestOperationManager *am = [AFHTTPRequestOperationManager manager];
    
    [am GET:Scroll_url2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dic in responseObject[@"Content"][@"commodityList"]) {
            MenuModel * model = [MenuModel new];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataMenuArr addObject:model];
            
        }
        for (NSDictionary *dic in responseObject[@"Content"][@"discountommodityList"]) {
            MenuModel * model = [MenuModel new];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataMenuArr addObject:model];
            
        }
        
        [self shop];
        
        
        for (int i = 0; i<self.dataMenuArr.count; i++) {
            MenuModel *model = self.dataMenuArr[i];
            NSLog(@"%@,%@",model.commodityID,model.commodityName);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)requestData{
    AFHTTPRequestOperationManager *am = [AFHTTPRequestOperationManager manager];

    [am GET:Scroll_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (NSDictionary *dic in responseObject[@"Content"][@"adPicList"]) {
            ScrollModel * model = [ScrollModel new];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataImgArr addObject:model];
            
        }
        [self rollImage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 功能菜单
-(void)gnMenu{
    NSArray * imgArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    NSArray *labArr = @[@"京东超市",@"全球购",@"充值中心",@"服装城",@"赚钱抢红包",@"优惠卷",@"领京豆",@"全部",];
    NSInteger heigth ;
    if (NUM <4) {
        heigth = LLG_SCREEN_WIDTH / 4;
    }else{
        heigth = (NUM / 4) * LLG_SCREEN_WIDTH / 4;
    }
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            LLG_SCREEN_WIDTH*0.4, LLG_SCREEN_WIDTH, heigth)];
    [self.view addSubview:view];
//    view.backgroundColor = [UIColor redColor];
    for (int i = 0; i<8 ; i++) {
        UIButton * btn  =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5+i%4*LLG_SCREEN_WIDTH/4, (i/4*LLG_SCREEN_WIDTH/4), LLG_SCREEN_WIDTH/4, LLG_SCREEN_WIDTH/4-20);
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(i%4*LLG_SCREEN_WIDTH/4, (i/4*LLG_SCREEN_WIDTH/4)+LLG_SCREEN_WIDTH/4-20, LLG_SCREEN_WIDTH/4, 20)];
        [btn setBackgroundImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        lable.text = labArr[i];
        [lable setFont:[UIFont systemFontOfSize:12]];
        lable.textAlignment = NSTextAlignmentCenter;
        [view addSubview:btn];
        [view addSubview:lable];
        
        
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(menuClick)];
        [btn addGestureRecognizer:tap];
        
    }
}
#pragma mark 图片点击手势
-(void)clickImg:(UITapGestureRecognizer*)tap{
    switch (tap.view.tag) {
        case 10:
            break;
        case 11:
            break;
        default:
            break;
    }
}
-(void)ex2{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"收货地址" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 300, 70, 30);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)click{
    
}
#pragma mark 功能菜单点击
-(void)menuClick{
    
}

#pragma mark AD
-(void)ad{
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, LLG_SCREEN_WIDTH*0.9, LLG_SCREEN_WIDTH, 40)];
    sc.contentSize = CGSizeMake(LLG_SCREEN_WIDTH, 0);
    [self.view addSubview:sc];
    sc.showsHorizontalScrollIndicator = NO;
    sc.pagingEnabled = YES;
    for (int i = 0; i<1; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LLG_SCREEN_WIDTH, 40)];
        imgView.image = [UIImage imageNamed:@"9"];
        [sc addSubview:imgView];
    }
}




#pragma mark Activities
-(void)Activities{


}


-(void)shop{
    NSInteger cout = 0;
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, LLG_SCREEN_WIDTH+30, LLG_SCREEN_WIDTH, 20)];
    [self.view addSubview:v];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 20)];
    lab.textColor = [UIColor redColor];
    lab .text = @"秒杀";
    [v addSubview:lab];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, LLG_SCREEN_WIDTH-100, 20)];
    lab2.font = [UIFont systemFontOfSize:12];
    lab2.text = [NSString stringWithFormat:@"%ld:%ld:%ld",self.currentTime/3600,self.currentTime/60,self.currentTime%3600];
    [v addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(LLG_SCREEN_WIDTH-150, 0, 150, 20)];
    lab3.text = @"京东好快货闹元宵";
    [v addSubview:lab3];
    
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, LLG_SCREEN_WIDTH+50, LLG_SCREEN_WIDTH, LLG_SCREEN_WIDTH*0.6)];
    sc.contentSize = CGSizeMake(LLG_SCREEN_WIDTH, 0);
    sc.pagingEnabled = YES;
    sc.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sc];
    for (int i = 0; i<3; i++) {
        NSArray  *acArr = [[NSBundle mainBundle] loadNibNamed:@"ActionView" owner:nil options:nil];
        ActionView *ac = [acArr objectAtIndex:0];
        ac.frame = CGRectMake(i*LLG_SCREEN_WIDTH/3, 0, LLG_SCREEN_WIDTH/3, 100);
        MenuModel *model = self.dataMenuArr[cout];
        [ac.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
        ac.Price.text = [NSString stringWithFormat:@"￥ %@",model.presentPrice];
        ac.oldPrice.text = [NSString stringWithFormat:@"￥ %@",model.originalPrice];
        cout++;
        [sc addSubview:ac];
//        ac.backgroundColor = [UIColor orangeColor];
    }
    
}

/*
#pragma mark 轮播2
-(void)rollImage2{
    _scrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 520,LLG_SCREEN_WIDTH,LLG_SCREEN_WIDTH*0.4 )];
    _scrollView2.delegate = self;
    _scrollView2.showsHorizontalScrollIndicator = NO;
    _scrollView2.pagingEnabled = YES;
    _scrollView2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_scrollView2];
    _scrollView2.contentSize = CGSizeMake(LLG_SCREEN_WIDTH*self.dataMenuArr.count, 0);
    for (int i = 0; i<self.dataMenuArr.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(i*LLG_SCREEN_WIDTH, 0, LLG_SCREEN_WIDTH,LLG_SCREEN_WIDTH*0.4)];
        imgView.tag = 100+i;
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImg:)];
        [imgView addGestureRecognizer:tap];
        
        [_scrollView2 addSubview:imgView];
        

                MenuModel *model2 = self.dataMenuArr[i];
        
    
                  [imgView sd_setImageWithURL:[NSURL URLWithString:model2.imgUrl]];
        
    }
    
    
}
*/
@end
