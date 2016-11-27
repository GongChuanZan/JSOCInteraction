//
//  JSOCInteraction.m
//  JSOCInteractionDemo
//
//  Created by gongcz on 16/5/10.
//  Copyright © 2016年 gongcz. All rights reserved.
//

#import "JSOCInteraction.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif

//@protocol JSObjectProtocol <JSExport>
//- (NSString *)getVersion;
//@end

@interface JSObject : NSObject
@property (nonatomic) BOOL needReturnValue;
@property (nonatomic, strong) JSClassCallBackBlock block;
- (void)addMethod:(NSString *)methodStr;
@end

@implementation JSObject

- (void)dealloc
{
    NSLog(@"JSObject dealloc...");
}

- (void)addMethod:(NSString *)methodStr
{
    NSArray *arr = [methodStr componentsSeparatedByString:@":"];
    Protocol *protocal = [self objc_allocateProtocol:[[arr.firstObject uppercaseString] UTF8String]];//@protocol(JSObjectProtocol);
    SEL sel = [self sel_registerName:methodStr.UTF8String];//NSSelectorFromString(methodStr);
    // 给protocal添加方法
    NSString *typeStr = self.needReturnValue? @"@@:": @"V@:";
    NSUInteger num = arr.count-1;
    for (int i = 0; i < num; i++) {
        typeStr = [typeStr stringByAppendingString:@"*"];
    }
    const char *types = typeStr.UTF8String;
    [self protocol_addMethodDescription:protocal sel:sel types:types isRequiredMethod:NO isInstanceMethod:YES];
    [self class_addProtocol:self.class protocol:protocal]; // 添加协议
    
    
    [self class_addMethod:self.class selector:sel imp:nil types:types];
    Method method = class_getInstanceMethod(self.class, sel);//class_getClassMethod(self.class, sel);
    [self method_setImplementation:method];
    
    [self objc_registerProtocol:protocal];
    
    // 获取列表
    [self class_copyMethodList:self.class];
    [self protocol_copyMethodDescriptionList:protocal isRequiredMethod:NO isInstanceMethod:YES];
    [self class_copyProtocolList:self.class];
    [self protocol_copyProtocolList:protocal];
}

- (SEL)sel_registerName:(const char *)name {
    SEL sel = sel_registerName(name);
    return sel;
}

- (void)class_addMethod:(Class)class selector:(SEL)selector imp:(IMP)imp types:(const char *)types {
    if (class_addMethod(class,selector,class_getMethodImplementation(class, selector),types)) {
        NSLog(@"%sadd method success",__func__);
    }else{
        NSLog(@"%sadd method fail",__func__);
    }
}

- (void)method_setImplementation:(Method)method {
    IMP imp = imp_implementationWithBlock(^(id self,id value){
        NSLog(@"%s action",__func__);
        id val;
        if (_block) {
            val = _block(value);
        }
        return val;
    });
    method_setImplementation(method,imp);
}

- (void)objc_registerProtocol:(Protocol *)protocol {
    if (protocol) {
        objc_registerProtocol(protocol);
    }
    
}

- (BOOL)class_conformsToProtocol:(Class)class protocol:(Protocol *)protocol {
    if (class_conformsToProtocol(class, protocol)) {
        return YES;
    }else{
        return NO;
    }
}

- (void)class_addProtocol:(Class)class protocol:(Protocol *)protocol {
    if ([self class_conformsToProtocol:class protocol:protocol]) {
        return;
    }
    if (class_addProtocol(class, protocol)) {
        NSLog(@"%sadd protocol success",__func__);
    }else{
        NSLog(@"%sadd protocol fail",__func__);
    }
}

- (Protocol *)objc_allocateProtocol:(const char *)name {
    if (![self class_conformsToProtocol:self.class protocol:NSProtocolFromString([NSString stringWithUTF8String:name])]) {
        Protocol *protocol = objc_allocateProtocol(name);
        Protocol *export = @protocol(JSExport);
        [self objc_registerProtocol:export];
        [self protocol_addProtocol:protocol addition:export];
//        NSLog(@"%s creat protocol named %@",__func__,NSProtocolFromString([NSString stringWithUTF8String:name]));
        return protocol;
    }
    return nil;
}

- (void)protocol_addProtocol:(Protocol*)protocol addition:(Protocol*)addition {
    protocol_addProtocol(protocol, addition);
}

- (void)protocol_addMethodDescription:(Protocol *)protocol sel:(SEL)sel types:(const char *)types isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod{
    protocol_addMethodDescription(protocol, sel, types, isRequiredMethod, isInstanceMethod);
}

- (void)class_copyMethodList:(Class)class {
    unsigned int count;
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSLog(@"%s%s",__func__,sel_getName(method_getName(method)));
    }
}

- (struct objc_method_description *)protocol_copyMethodDescriptionList:(Protocol *)protocol isRequiredMethod:(BOOL)isRequiredMethod isInstanceMethod:(BOOL)isInstanceMethod{
    unsigned int outCount;
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &outCount);
    for (int i = 0; i < outCount; i++) {
        struct objc_method_description method = methodList[i];
        NSLog(@"%s %@",__func__,NSStringFromSelector(method.name));
    }
    return methodList;
}

- (void)class_copyProtocolList:(Class)class {
//    unsigned int count;
//    // 这里必须加unsafe unretained修饰
//    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(class, &count);
//    for (unsigned int i = 0; i < count; i++) {
//        Protocol *protocol = protocolList[i];
//        NSLog(@"%s%s",__func__,[self protocol_getName:protocol]);
//    }
}

- (__unsafe_unretained Protocol **)protocol_copyProtocolList:(Protocol *)protocol {
    unsigned int outCount;
    __unsafe_unretained  Protocol **protocolList = protocol_copyProtocolList(protocol,&outCount);
    for (int i = 0; i < outCount; i++) {
        Protocol *protocol = protocolList[i];
        NSLog(@"%s %s",__func__,protocol_getName(protocol));
    }
    return protocolList;
}

- (const char *)protocol_getName:(Protocol *)protocol {
    const char *name = protocol_getName(protocol);
    return name;
}

@end


@interface JSOCInteraction ()

@property (nonatomic, strong) JSCallBackBlock jcBlock;

@end

@implementation JSOCInteraction

+ (void)JSCallClassWebView:(UIWebView *)webView name:(NSString *)name toObject:(id<JSExport>)toObject
{
    JSContext * context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[name] = toObject;
}

+ (void)JSCallOCWebView:(UIWebView *)webView name:(NSString *)name method:(NSString *)method needReturnValue:(BOOL)needReturnValue callBack:(JSClassCallBackBlock)block
{
    JSContext * context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSObject *toObject = [JSObject new];
    toObject.needReturnValue = needReturnValue;
    toObject.block = block;
    [toObject addMethod:method];
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(obj,args);
                    });
                }
            };
        }
        
    }];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES,nil);
            });
        }
    }];
}

@end
