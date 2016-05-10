//
//  SecondViewController.m
//  JSOCInteractionDemo
//
//  Created by gongcz on 15/10/9.
//  Copyright © 2015年 gongcz. All rights reserved.
//

#import "SecondViewController.h"
#import "JSOCInteraction/JSOCInteraction.h"

@interface SecondViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //网址
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CallOC" ofType:@"html"];
    NSURL* httpUrl = [NSURL fileURLWithPath:path];
    NSURLRequest *httpRequest=[NSURLRequest requestWithURL:httpUrl];
    [_webView loadRequest:httpRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //iOS调用js
    //网页加载完成调用此方法
    [JSOCInteraction JSCallOCWebView:webView methods:@[@"callOC"] callBack:^(NSString *method, NSArray *params) {
        NSLog(@"%@,%@",method,params);
        NSArray *args = params;
        
        __block NSString *paramStr = @"";
        [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@",obj);
            paramStr = [paramStr stringByAppendingFormat:@"参数%ld：%@\n",(long)idx,obj];
        }];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"js call oc successfully !" message:paramStr delegate:nil cancelButtonTitle:@"太帅了！" otherButtonTitles:nil, nil];
        [alert show];
#else
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"js call oc successfully !" message:paramStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"太帅了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
#endif
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
