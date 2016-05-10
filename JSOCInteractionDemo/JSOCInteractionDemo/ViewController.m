//
//  ViewController.m
//  JSOCInteractionDemo
//
//  Created by gongcz on 15/10/9.
//  Copyright © 2015年 gongcz. All rights reserved.
//

#import "ViewController.h"
// framework
#import <JavaScriptCore/JavaScriptCore.h>

//首先创建一个实现了JSExport协议的协议
@protocol TestJSObjectProtocol <JSExport>

//此处我们测试几种参数的情况
- (NSString *)getVersion;

@end

@interface MyApplication : NSObject <TestJSObjectProtocol>

@end

@implementation MyApplication

- (NSString *)getVersion
{
    return @"1.0.0";
}

@end

@interface ViewController () <UIWebViewDelegate>


@property (nonatomic, strong) JSContext *context;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) MyApplication *mApplication;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mApplication = [[MyApplication alloc] init];
    //网址
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CallJS" ofType:@"html"];
    NSURL* httpUrl = [NSURL fileURLWithPath:path];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [_webView loadRequest:httpRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getVersion
{
    return @"1.0.0";
}

#pragma mark - event method
- (IBAction)callJsClick:(id)sender {
    
    NSString *alertJS=@"test()"; //准备执行的js代码
    [_context evaluateScript:alertJS];//通过oc方法调用js的alert
}


#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页加载完成调用此方法
    if (!_context) {
        //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
        _context=[_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        MyApplication *mApplication = [MyApplication new];
        _context[@"mApplication"] = mApplication;
    }
}

@end
