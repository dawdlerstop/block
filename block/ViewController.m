//
//  ViewController.m
//  block
//
//  Created by 王维 on 16/1/14.
//  Copyright © 2016年 王维. All rights reserved.
//
/*
 block 代码块，也叫闭包（一个封闭的区域），与C语言函数相似
 block 具有反向传值、会调的功能
 回调：执行完毕之后，返回再去执行（人为控制函数，让函数再执行）
 反向传值：在会掉的时候给他一个值
 
 block 分为声明实现和调用两部分
 步骤：声明->调用->实现
 
 声明：声明有一个block，会执行这一步
 实现：实现block，只要不主动调用，这一步是不会执行的
 调用：当调用的时候，会返回去执行实现的部分
 
 block 可以当做变量使用，也可以当做参数使用
 1、block声明和实现
 2、分析回调、反向传值
 3、当做变量使用
 4、当做参数使用
 5、当做属性使用， 解决block的内存循环引用
 6、让block代替代理
 
 block的公式：
 1、声明实现写在一起的公式：
 返回值类型 (^block名字)(参数列表 参数类型 参数名) = ^(参数列表 参数类型 参数名){
  实现代码
（有返回值就return一个返回值类型的值）
 };
 调用：block名字(参数);
 
 2、声明实现分开写
 （1）声明
 返回值类型 (^block名字)(参数列表);
 （2）实现
 block名子 = ^(参数列表){
 实现的内容（如果有返回值就return）
 }
 （3）调用
 block名字(实参)
 
 ⭐️⭐️⭐️⭐️⭐️不能先调用后实现
 
 
 
 
 回顾：
 block 代码块 闭包
 回调 -> 反向传值
 1、声明 实现 放到一块
 2、声明 实现 分开
 
 1、返回值类型 (^block名字)(参数列表) = ^(参数列表){
 实现代码（如果有返回值return）
 }
 
 2、（1）声明 返回值类型 (^block名字)(参数列表);
 （2）block名字 = ^(参数列表){
 实现代码（如果有返回值return）
 }
 
 __block 使用这个修饰词 修饰的变量  可以在block内部 修改他的值
 __weak 用来修饰  不可以被释放的对象 ->内存的循环引用
 
 */
#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
{
//   1. 有返回值
    NSString *(^nameBlock)(void);
//    2.无返回值
    void(^nameBlock2)(NSString *name);
    
    UILabel *lable;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//   只执行声明部分
    void (^block)(int a) = ^(int a){
//       不调用就不去执行实现部分
        NSLog(@"%d",a);
    };
//    调用block，返回去执行实现部分
    block(1);
    
//    返回值是int类型的block，串一个int类型的参数
    int(^block1)(int a) = ^(int a){
       
        return a;
    };
//    当调用的时候，返回去执行实现部分
    NSLog(@"%d",block1(12345));
    
    
    
    
//    输入一个数字，返回一个数字对应的季节（从1-4）
    NSString *(^seasonBlock)(int a) = ^(int a){
        NSString *season;
        
        switch (a) {
            case 1:
                season = @"春天";
                break;
            case 2:
                season = @"夏天";
                break;
            case 3:
                season = @"秋天";
                break;
            case 4:
                season = @"冬天";
                break;
            default:
                break;
        }
        
        return season ;
    };
    NSLog(@"%@",seasonBlock(1));
    
    
    NSDictionary * (^blockDic)(NSString *name,int age) = ^(NSString *name,int age){
        NSDictionary *dict = @{@"name":name,@"age":@(age)};
        return dict;
 };
    NSLog(@"%@   ",blockDic(@"adf",15));
    
    
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textField];
    
    
//    （2）声明实现分开写
//    声明
//    返回值类型 (^block名字)(参数列表);
//    实现
//    block名子 = ^(参数列表){
//        实现的内容（如果有返回值就return）
//    }
//    调用
//    block名字(实参)
    
//   显示的lable ->调用block之后筛选出来的名字->全局变量去接收（__block）
//    可以在创建lable、button的时候同时声明block 为了防止调用block的时候没有实现
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 200, 100, 40);
    [button setTitle:@"筛选" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    button.tag = 100;
    [button addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    
    lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 300, 100, 100)];
    lable.text = nameBlock();
    lable.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:lable];
    
    nameBlock = ^(void){
        NSArray *nameList = @[@"1",@"12",@"123",@"1234",@"12345",@"123456"];
        

        return nameList[arc4random()%nameList.count];
    };
//    -----无返回值
    __block NSString *nn;
    /*
     __block:修饰词。用来修饰修改block之外变量内容的修饰词，如果不加修饰词，就是不允许修改外部变量的值，就算赋值，得到的值仍是修改之前的值
     __weak:弱引用。用他修饰的变量都是不安全的变量，他会告诉编译器可以释放这个对象
     */
//    __weak用一个临时变量代替真正的lable
    __weak UILabel *weakLable = lable;
    nameBlock2 = ^(NSString *name){
        nn = name;
        NSLog(@"%@",nn);
        weakLable.text = name;
    };
    /*
     修改block外部变量用__block
     修改不是局部变量的值的时候（这时候涉及到对象）使用__weak修饰，把不能销毁的对象用临时对象替换
     */
}

-(void)done:(UIButton *)sender{
     //    调用
    
    
   NSArray *nameList = @[@"1",@"12",@"123",@"1234",@"12345",@"123456"];
    nameBlock2(nameList[arc4random()%nameList.count]);
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    UILabel * (^imageBlock)(int a) = ^(int a){
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(200, 200, 200, 200)];
        lable.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:lable];
        return lable;
    };
    imageBlock((int)textField.text);
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
