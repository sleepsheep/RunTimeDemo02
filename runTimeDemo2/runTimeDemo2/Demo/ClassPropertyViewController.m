//
//  ClassPropertyViewController.m
//  runTimeDemo2
//
//  Created by yangL on 16/3/24.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "ClassPropertyViewController.h"
#import <objc/runtime.h>
#import "CustomClass.h"

@interface ClassPropertyViewController ()

@end

@implementation ClassPropertyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _myFloat = 2.34f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self getClassAllMethod];
    
//    [self propertyNameList];
    
//    [self getInstanceVar];
    
    [self setInstanceVar];
    
//    [self getVarType];
    
//    _allobj = [CustomClass new];
//    _allobj.varTest1 = @"test1";
//    _allobj.varTest2 = @"test2";
//    _allobj.varTest3 = @"test3";
//    
//    NSString *var = [self nameOfInstance:@"test2"];
//    NSLog(@"%@", var);// _varTest2
    
}


/*
 1、获取类的所有方法
 Method *class_copyMethodsList(class cls, unsigned int *count)
 参数说明：1、class cls : 方法所在的类 2、unsigned int 方法的总数
 返回值：返回一个 runtime内部定义的一个方法数组
 
 2、获取一个类的所有的属性
 objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)
 参数说明：1、class cls : 属性所在的类  2、unsigned int 属性的数目
 返回值：返回一个Char字符数组
 
 3、获取类的属性变量的值
 Ivar object_getInstanceVariable(id obj, const char *name, void **outValue)
 参数说明：1、id obj : 属性所在的类的对象 2、要获取的变量的名称 3、void * *outValue 外部接收属性值得变量
 返回值：IVar RunTime中用来表示实例变量

 4、设置类的属性变量的值
 Ivar object_setInstanceVariable(id obj, const char *name, void *value)
 参数说明：1、id obj : 待设置的类，属性所在的类 2、const char *name : 待设置的属性的名称 3、void *value : value 数形变量的新值
 返回值：Ivar Runtime中用来表示实例变量（官方解释：A pointer to the Ivar data structure that defines the type and name of the instance variable specified by name. ）
 
 5、判断类的某个属性的类型
 const char * ivar_getTypeEncoding(Ivar var)
 参数说明：1、Ivar var : runtime实例变量的结构体name 、type 、 offset
 
 6、通过属性的值来获取属性的名字
 思路：1、获取一个类的所有的属性 2、遍历这些属性，依次去取这些属性的值 3、判断这些值和传入的属性的值是否相同 4、如果相同就获取Ivar的名字

 */

// 6、通过属性的值来获取属性的名字(反射机制)
- (NSString *)nameOfInstance:(id)instance {
    unsigned int numlvars = 0;
    NSString *key = nil;
    
    Ivar *vars = class_copyIvarList([CustomClass class], &numlvars);//1、获取一个类的所有的属性
    
    for (int i = 0; i < numlvars; i++) {
        Ivar thisVar = vars[i];//2、遍历这些属性，依次去取这些属性的值
        
        const char *type_encoding = ivar_getTypeEncoding(thisVar);
        NSString *type = [NSString stringWithCString:type_encoding encoding:NSUTF8StringEncoding];
        
        if (![type hasPrefix:@"@"]) {//
            continue;
        }
        
        if ((object_getIvar(_allobj, thisVar)) == instance) {//object_getIvar 是获取属性的值//3、判断这些值和传入的属性的值是否相同
            key = [NSString stringWithUTF8String:ivar_getName(thisVar)];//4、如果相同就获取Ivar的名字
            break;
        }
    }
    
    free(vars);
    return key;
}

//5、判断类的某个属性的类型
- (void)getVarType {
    CustomClass *obj = [CustomClass new];
    Ivar var = class_getInstanceVariable(object_getClass(obj), "_varTest1");
    const char *type_encoding = ivar_getTypeEncoding(var);
    NSString *type = [NSString stringWithCString:type_encoding encoding:NSUTF8StringEncoding];
    NSLog(@"%@", type);//@"NSString"
    
}

// 4、设置类的属性变量的值
- (void)setInstanceVar {
    float newValue = 10.0f;
    unsigned int addr = (unsigned int)&newValue;
    object_setInstanceVariable(self, "_myFloat", *(float **)addr);//这里报了个错 不知道如何解 求解
    NSLog(@"%f", _myFloat);

}

// 3、获取类的属性变量的值
- (void)getInstanceVar {
    float myFloatValue;
    object_getInstanceVariable(self, "_myFloat", (void *)&myFloatValue);
    NSLog(@"%f", myFloatValue);//2.340000
}

//2、获取一个类的所有的属性
- (void)propertyNameList {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([UIViewController class], &count);
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        NSLog(@"i = %d methodName = %@", i, name);//打印内容太多 == 运行查看
    }
}

// 1、获取类的所有方法
- (void)getClassAllMethod {
    u_int count;
    Method *methods = class_copyMethodList([UIViewController class], &count);
    
    for (int i = 0; i < count; i++) {
        SEL sel = method_getName(methods[i]);
        NSString *name = [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding];
        NSLog(@"i = %d methodName = %@", i, name);//打印内容太多 == 运行查看
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
