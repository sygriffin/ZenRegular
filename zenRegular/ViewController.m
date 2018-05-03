//
//  ViewController.m
//  zenRegular
//
//  Created by SY on 2017/7/24.
//  Copyright © 2017年 中信. All rights reserved.
//
//
//  禅与objc

#import "ViewController.h"



@interface ViewController (){
    
    
}

@property (nonatomic, readwrite, copy) NSString *myValue;

@property (assign, getter=isEditable) BOOL editable;

@property (nonatomic, copy) NSMutableArray *aArray;

@property (nonatomic, strong) NSMutableArray *bArray;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation ViewController

@synthesize myValue = _myValue;

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc]init];
        NSLocale *enLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
        [_dateFormatter setLocale:enLocale];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:ss.SSS"];
    }
    return _dateFormatter;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *cArray = [NSMutableArray array];
    self.aArray = cArray;
    self.bArray = cArray;
    
    NSLog(@"a.class = %@",[self.aArray class]);
    NSLog(@"b.class = %@",[self.bArray class]);
    
    [self.bArray removeAllObjects];
    //aArray崩溃，copy类型，拷贝出的是不可变的NSArray类型
//    [self.aArray removeAllObjects];

    
    /*
     1.if语句要在语句体内执行
     2.除判断nil和BOOL，不要出现youda表达式（即用常量去判断变量是否相等）
     */
    //正常写法
    if (_myValue == nil){}
    //yoda表达式（仅适用于nil和BOOL检查）
    if (nil == _myValue){}
    //引发错误！！！
    if (_myValue = nil){}
    /*
     3.不要嵌套if，多用return减少复杂度（即先判!if情况），方法的重要部分不要嵌套在分支里
     4.将特别复杂的表达式赋予BOOL值，逻辑判断更清楚
     5.三目运算符内不要进行其他赋值等操作，如果判断结果与条件相同，则直接写出:和不同结果即可
     */
    int a = 1;
    int b = 2;
    int result = a>b ? a : b;
    BOOL result1 = a>b ? : a<b;//推荐写法（无需再写出a>b）
    NSLog(@"%d",result);
    NSLog(@"%d",result1);
     /*
     6.尽量检查方法的返回值而不是error的引用，系统API有些在成功的情况下会返回error是内存中的垃圾值
     7.case语句中一段代码要用大括号，用fall-through（OC:移除case的break，下面的case继续执行,Swift:fallthrough关键字）会继续向下执行，当switch对象为enum时default是不必要的，加入新值会警报
     8.推荐使用NS_ENUM
     9.推荐使用长的描述性的方法变量名，尽量不要与系统冲突
     10.常量遵循驼峰法则，并以相关类名为前缀；使用常量代替字符串字面值和数字，方便复用快速修改，减少错误；常量应该声明为static静态常量而不是宏定义；常量应该以extern *类型 const +名字的形式暴露给外部，并在实现文件中给其赋值；注意：只有公有常量才需要添加命名空间作为前缀，尽管.m文件中私有常量的命名可以遵循另外一种模式，你仍旧可以遵循这个规则
     11.方法参数前要有一个描述性关键词，参数间尽量少用或者不用and
     12.字面值：如NSArray、NSNumber、NSDictionary直接初始化（字面值）而不用类方法初始化。如：
      NSArray *arr = @[];
     13.类名：个人称谓+功能名称+继承父类名称
     14.Initializer&dealloc（尽量将init和dealloc放在一块）
     .m文件中的实现顺序
     @synthesize&@dynamic>dealloc>init(指定初始化方法在前，间接初始化方法在后)
      self = [super init];-->防止初始化失败造成的问题
      designated和secondary初始化（指定初始化&便利初始化）
      designated初始化方法有且仅有一个，其余的secondary初始化方法全部都是调用designated初始化方法进行的
      注意：
      1.子类如果有指定初始化函数，那么指定初始化函数实现时必须调用它的直接父类的指定初始化函数。
      2.如果子类有指定初始化函数，那么便利初始化函数必须调用自己的其它初始化函数(包括指定初始化函数以及其他的便利初始化函数)，不能调用super的初始化函数。-->推论：所有的便利初始化函数最终都会调到该类的指定初始化函数。
      3.如果子类提供了指定初始化函数，那么一定要实现所有父类的指定初始化函数。
      总结：便利初始化函数只能调用自己类中的其他初始化方法，指定初始化函数才有资格调用父类的指定初始化函数。
      NS_DESIGNATED_INITIALIZER以此为标识明确指定初始化方法
      4.当initWithCorder:遇到NS_DESIGNATED_INITIALIZER
      如父类没有实现NSCoding协议，那么应该调用父类的指定初始化函数。
      如果父类实现了NSCoding协议，那么子类的 initWithCoder: 的实现中需要调用父类的initWithCoder:方法。
      
      总结：
      便利初始化函数只能调用自己类中的其他初始化方法
      指定初始化函数才有资格调用父类的指定初始化函数
      
      15.关于instancetype：可以进行自动的类型检查（建议全部使用instancetype）
      
      16.类簇class cluster-->苹果对抽象工厂设计模式的称呼
      优势，减少条件语句的判断，利用抽象类（超类）去完成特定的逻辑或者是实例化一个具体例子（例如NSNumber返回不同的类型给子类）
      建立类簇的过程：init方法中加入了isMemberOfClass-->防止子类中重载初始化方法避无限递归
      self = nil移除抽象工厂类实例上的所有引用
      接下来就是判断哪个私有子类将被初始化（必须完全遵循designated和secondary初始化法则）
      
      17.单例
      首先，能使用依赖注入的时候就尽量不要使用单例。（详看策略模式和依赖注入的关系）
      如果一定要用，也要线程安全模式来创建
      static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
      
      });
      单例对象是可以子类化的，但是非常是少见
      单例通常公开一个shareInstance的类方法就足够了，不要暴露出可写的属性
      不要去把单例作为一个对象的容器，在代码或者应用层面上共享，不符合设计规范
      
      18.属性
      1)应该尽可能描述性命名，避免缩写，遵循驼峰法则。
      标准写法：NSString *text
      2)@property会自动生成setter和getter方法，不写@synthesize没关系，若使用则需要在@implementation下直接写出需要承接的变量。
      除了init和dealloc方法，应该总是使用setter、getter方法去访问属性（注：self.语法会调用属性的setter的方法，而_XX语法只是对新的指针变量的赋值）。
      3)init和dealloc
      永远不要在init方法中调用setter和getter方法，应当直接访问实例变量。（防止子类重载其setter或者getter方法导致访问了并未被初始化的对象）一个对象仅仅在init返回的时候才会被认为是完成了初始化的状态。
      dealloc也是相同的-->一个对象在dealloc方法调用过程中会变成不稳定状态。
      注：在init方法中使用setter执行UIApperance代理会出现问题
      4)点语法使用.XXX
      当使用setter、getter方法时尽量使用.语法。应该总是用.语法来访问及设置属性
      清晰区分属性访问和方法调用-->.语法就是用在属性上的，空格+中括号是方法调用上的[XXX xxxxxx]
      5)属性定义
      @property (nonatomic, readwrite, copy)NSString *myValue;
      参数按照：原子性，读写，内存管理顺序书写（因为修改可能性高低是按照内存管理>读写权限>原子操作来的，越靠右侧的越有可能被修改）
      atomic慎用-->这个线程安全锁特别影响性能
      属性可以存储到一个代码块中，为了让他存活到定义的块结束，必须使用copy（block最早在栈中创建，使用copy将block拷贝到堆区里面去）
      为了完成一个共有的getter和一个私有的setter，在interface中声明公开属性为readonly在Extension中重新将属性定义为readwrite
      描述BOOL属性的词是一个形容词的话setter不应该带is前缀但是getter访问器应该带上这个前缀，如：@property (assign, getter=isEditable) BOOL editable;
      @implementation中应该避免使用@synthesize，因为Xcode已经自动添加了
      6)私有属性
      私有属性应该定义在文件类的extension中。不允许在有名字的category中定义私有属性，除非你扩展其他类
      7)可变对象
      任何可以用来用一个可变对象设置的(例如：NSString、NSArray、NSURLRequst)属性的内存管理类型必须是copy的
      这种做法是为了确保防止在不明确的情况下修改被封装好的对象的值
      当修饰可变类型的属性时，如NSMutableArray、NSMutableDictionary、NSMutableString，用strong
      当修饰不可变类型的属性时，如NSArray、NSDictionary、NSString，用copy
      同时应该避免暴露在公开的接口中的可变对象，类的使用者会通过暴露出来的信息改变你的封装结构。可以提供只读属性来返回对象不可变的副本
      8)懒加载
      用于初始化过程中需要消耗大量资源，或者该对象配置一次就要调用很多配置相关的方法而你又不想把他们弄乱，此时需要重写getter方法延迟实例化而不是在init方法里给对象分配内存
      通用写法见dateFormatter。
      关于懒加载的争议
      -->避免getter方法的副作用(除了返回函数值之外，还对主调用函数产生的附加影响，例如全局变量的修改或者参数的修改)
      -->初次访问改变了初始化的消耗，产生了副作用，这会让优化性能和测试变的更加困难
      -->实例化的时机是不确定的，例如你想通过一个方法第一次访问一个属性，之后类的实现被你改掉了，这个get访问器在你原本希望调用时机之前就已经被调用了，这样就出现问题了。尤其是初始化逻辑依赖于类的其他不同状态时。总的来说就是明确的表达出依赖关系防止出错。
      -->这种方式对KVO不是很友好，如果getter方法改变了它的引用，就会触发KVO改变的通知。这就会在调用getter方法时收到一个改变通知，这很奇怪。
      懒加载的最根本作用是需要多次调用这个对象的时候使用，比如某个ui需要多次改变状态，这时候用懒加载。
      
      19.方法
      1)参数断言：你的方法可能要求一些参数满足特定条件，这种情况下最好使用NSParameterAssert()来断言条件是否成立或者抛出异常
      2)私有方法：永远不要在私有方法前加一个_前缀，这个前缀是Apple保留的，这样会有重载Apple私有方法的风险
      
      20.相等性(equality)
      
      
      
      
      
      
      
    
     */


    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
