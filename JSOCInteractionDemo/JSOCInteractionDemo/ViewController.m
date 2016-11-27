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
#import "JSOCInteraction/JSOCInteraction.h"

// ================= separator line⬇️ ====================
//@protocol JSObjectProtocol <JSExport>
//- (NSString *)getVersion; // 这里的函数可根据JS内的调用函数去定义，如果函数多个可在这里添加
//@end
//
//@interface JSObject : NSObject <JSObjectProtocol>
//
////- (void)addSel:
//
//@end
//
//@implementation JSObject
//- (NSString *)getVersion{return @"1.0.0";}
//@end
// ================= separator line⬆️ ====================

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) JSContext *context;

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

- (NSString *)getVersion
{
    return @"1.0.0";
}

#pragma mark - event method
- (IBAction)callJsClick:(id)sender {
    
    NSString *alertJS=@"test()"; //准备执行的js代码
    
    [JSOCInteraction OCCallJSWebView:_webView methods:@[alertJS] callBack:^(BOOL success, NSError *error) {
//        return @"sdfsd"; // 这里有警告。。。
    }];
}


#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //网页加载完成调用此方法
//    [JSOCInteraction JSCallClassWebView:webView name:@"mApplication" toObject:[JSObject new]];
    
    [JSOCInteraction JSCallOCWebView:webView name:@"mApplication" method:@"getVersion" needReturnValue:YES callBack:^id(NSArray *params) {
        return @"1.0";
    }];
}

@end
