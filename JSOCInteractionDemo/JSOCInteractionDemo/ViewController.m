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

@interface ViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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

#pragma mark - event method
- (IBAction)callJsClick:(id)sender {
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS=@"test()"; //准备执行的js代码
    [context evaluateScript:alertJS];//通过oc方法调用js的alert
}


#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页加载完成调用此方法
}

@end
