//
//  JSOCInteraction.m
//  JSOCInteractionDemo
//
//  Created by gongcz on 16/5/10.
//  Copyright © 2016年 gongcz. All rights reserved.
//

#import "JSOCInteraction.h"

//@protocol JSObjectProtocol <JSExport>
////- (NSString *)getVersion;
//@end
//
//@interface JSObject : NSObject <JSObjectProtocol>
//
//- (void)execute:(NSString *)method;
//
//@end
//
//@implementation JSObject
//
//- (void)execute:(NSString *)method
//{
//    NSLog(@"%@",method);
//}
//
////- (NSString *)getVersion
////{
////    return @"1.0.0";
////}
//
//@end

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

@interface JSOCInteraction ()

@property (nonatomic, strong) JSCallBackBlock jcBlock;

@end

@implementation JSOCInteraction


void execute(id self, SEL _cmd)
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return 100;
    if (self) {
        [self handleExecute];
    }
}

+ (void)JSCallClassWebView:(UIWebView *)webView name:(NSString *)name toObject:(id<JSExport>)toObject
{
    JSContext * context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[name] = toObject;
}

+ (void)JSCallOCWebView:(UIWebView *)webView methods:(NSArray<NSString *> *)methods callBack:(JSCallBackBlock)block
{
    JSContext * context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    JSObject *jsObj = [JSObject new];
    [methods enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *arr;
        if ([obj isKindOfClass:[NSString class]]) {
            arr = [obj componentsSeparatedByString:@"."];
        }
        if (arr.count > 1) {
//            IMP imp = imp_implementationWithBlock(^(id obj) {
//                NSLog(@"%@", obj);
//                if (block) {
//                    block(arr[1],nil);
//                }
//                return @"1";
//            });
//            class_addMethod([JSObject class], NSSelectorFromString(arr[1]), imp, "v@:");
//            context[arr[0]] = jsObj;
        }else{
            
            context[obj] = ^() {
                NSArray *args = [JSContext currentArguments];
                if (block) {
                    block(obj,args);
                }
            };
        }
        
    }];
}

- (void)handleExecute
{
    
}

+ (void)OCCallJSWebView:(UIWebView *)webView methods:(NSArray<NSString *> *)methods callBack:(void (^)(BOOL, NSError *))block
{
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [methods enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *alertJS=obj; //准备执行的js代码
        JSValue *value = [context evaluateScript:alertJS];//通过oc方法调用js的alert
        if (value) {
            NSLog(@"%@",value);
        }
        if (block) {
            block(YES,nil);
        }
    }];
}

@end
