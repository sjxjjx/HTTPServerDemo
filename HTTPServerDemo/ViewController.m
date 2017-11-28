//
//  ViewController.m
//  HTTPServerDemo
//
//  Created by shapp on 2017/8/22.
//  Copyright © 2017年 shapp. All rights reserved.
//

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"
#import "SJXCSMIPHelper.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    HTTPServer * httpServer;
}

/* showIpLabel */
@property (nonatomic, weak) UILabel *showIpLabel;
/* fileTableView */
@property (nonatomic, weak) UITableView *fileTableView;
/* fileArray */
@property (nonatomic, strong) NSMutableArray *fileArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFile) name:@"processEpilogueData" object:nil];
    
    // 获取文件存储位置
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"filePath : %@", filePath);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    // webPath是server搜寻HTML等文件的路径
    NSString *webPath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"webPath : %@", webPath);
    [httpServer setDocumentRoot:webPath];
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    NSError *err;
    if ([httpServer start:&err]) {
        
        self.showIpLabel.hidden = NO;
        NSString *ipString = [NSString stringWithFormat:@"请在网页输入这个地址  http://%@:%zd/", [SJXCSMIPHelper deviceIPAdress], [httpServer listeningPort]];
        self.showIpLabel.text = ipString;
        NSLog(@"ipString : %@", ipString);
        
    }else{
        NSLog(@"%@",err);
    }
    
}

- (void)showFile {
    self.showIpLabel.hidden = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSLog(@"地址：%@", documentsPath);
        
        self.fileArray = [NSMutableArray arrayWithArray:[fileManager contentsOfDirectoryAtPath:documentsPath error:nil]];
        [self.fileTableView reloadData];
    });
    
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.fileArray[indexPath.row];
    return cell;
}


#pragma mark - <Other>
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [httpServer stop];
    httpServer = nil;
}

#pragma mark - <懒加载>
- (UILabel *)showIpLabel {
    if (!_showIpLabel) {
        UILabel *lb = [[UILabel alloc] init];
        
        lb.bounds = CGRectMake(0, 0, Screen_W, 200);
        lb.center = CGPointMake(Screen_W * 0.5, Screen_H * 0.5);
        lb.textColor = [UIColor darkGrayColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:13.0];
        lb.numberOfLines = 0;
        
        [self.view addSubview:lb];
        _showIpLabel = lb;
    }
    return _showIpLabel;
}
- (UITableView *)fileTableView {
    if (!_fileTableView) {
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H) style:UITableViewStylePlain];
        
        // 设置代理
        tv.delegate = self;
        // 设置数据源
        tv.dataSource = self;
        // 清除表格底部多余的cell
        tv.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [self.view addSubview:tv];
        _fileTableView = tv;
    }
    return _fileTableView;
}
- (NSMutableArray<NSString *> *)fileArray {
    if (!_fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

@end
