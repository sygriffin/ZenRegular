//
//  ViewController.m
//  zenRegular
//
//  Created by SY on 2017/7/24.
//  Copyright © 2017年 中信. All rights reserved.
//
//
//  禅与objc

//  code organization is a matter of hygiene(代码组织是卫生问题)

#import "ViewController.h"

//采用Module加快链接、编译速度
//@import UIKit.UIView;

typedef NS_OPTIONS(NSUInteger, UIViewAction) {
    UIViewAction1   = 0,
    UIViewAction2   = 1 << 0,
};

//objc-C++
class MouseListner {
public:
    virtual bool mousePressed(void) = 0;
    virtual bool mouseClicked(void) = 0;
    
};



@interface ViewController (){
    
    
}

@property (nonatomic, readwrite, copy) NSString *myValue;

@property (assign, getter=isEditable) BOOL editable;

@property (nonatomic, copy) NSMutableArray *aArray;

@property (nonatomic, strong) NSMutableArray *bArray;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

//属性的篡改 -- Num由只读到读写
@property (nonatomic,readwrite,copy) NSString *Num;


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
#warning wrong express
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
      并不是简简单单的isEqual
      实现相等时要记住这个约定：同时实现isEqual和hash方法（充分非必要条件：如果两个对象isEqual了那么hash方法返回值唯一但相反hash返回值相等两个对象不一定isEqual）
      (因为很多集合类底层都是hash表数据结构)
      [self.myValue hash] hash方法不能返回一个常量！！！
      返回值会作为对象在hash散列表上的key --> 后果严重，百分百碰撞
      (还是不要自己实现相等性方法比较了)
      
      21.类目category
      声明方法时依然要加上我们的前缀（防止方法覆盖）
      把类打破在更多自我包含的组成部分里
      (一个.h文件中包含多个分类，不同的分类在干不同的事情，不要去违背类的单一功能原则)
      
      22.protocols（协议）--> 抽象接口
      多态与继承 --> 面向协议编程仍然遵循里氏替换原则
      
      23.NSNotification
      定义通知名称的时候同样用extern这种静态字符串而并不是Marco
      
      24.关于代码美化
      不要另起一行写大括号，你愿意是写随你，反正公认很丑
      if (user.name) {
      
      }===>good
      if (user.name)
      {
      
      }===>bad
      
      多参多方法冒号对齐
      
      这种Egyptain风格括号尽量用在代码段内以及所有控制语句中
      非此类括号可以用在：类的实现、方法的实现
      
      可以多使用代码块
      GCC和Clang均包含的特性如果代码块闭合在圆括号内，会返回最后语句的值
      NSURL *url = ({
      
      });
      避免污染其他作用域
      
      25.关于pragama和Clang
      不同功能组的方法
      protocols 的实现
      对父类方法的重写
      
      如果你知道你的代码不会造成错误，方法内去掉Clang警报
      #pragma clang diagnostic push
      #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      
      [myObj performSelector:mySelector withObject:name];
      
      #pragma clang diagnostic pop
      
      忽略没有使用的变量警告#pragma unused (foo)
      - (NSInteger)giveMeFive
      {
      NSString *foo;
      #pragma unused (foo)
      
      return 5;
      }
      注意pragma需要标记到问题代码之下
      
      标明编译器警告与错误
      #warning Dude, don't compare floating point numbers like this!
      #error Whoa, buddy, you need to check for zero here!
      
      26.关于注释
      //单行注释
      以及现在使用的多行注释
      
      一个函数必须有一个字符串文档，除非它符合下面的所有条件：非公开、很短、显而易见
      
      @description。。。头文档仅适用于.h文件
      
      27.block
      关键点：
      block 是在栈上创建的
      block 可以复制到堆上
      Block会捕获栈上的变量(或指针)，将其复制为自己私有的const(变量)。
      (如果在Block中修改Block块外的)栈上的变量和指针，那么这些变量和指针必须用__block关键字申明(译者注：否则就会跟上面的情况一样只是捕获他们的瞬时值)。
      __block 声明的变量和指针在 block 里面是作为显示操作真实值/对象的结构来对待的。
      
      在非 ARC 环境肯定会把它搞得很糟糕，并且野指针会导致 crash。__block 仅仅对 block 内的变量起作用，它只是简单地告诉 block：
      嗨，这个指针或者原始的类型依赖它们在的栈。请用一个栈上的新变量来引用它。我是说，请对它进行双重解引用，不要 retain 它。
      如果在定义之后但是 block 没有被调用前，对象被释放了，那么 block 的执行会导致 crash。 __block 变量不会在 block 中被持有，最后... 指针、引用、解引用以及引用计数变得一团糟。
      
      防止self循环引用
      
      直接使用self -> 只能在 block 不是作为一个 property 的时候使用，否则会导致 retain cycle。
      只使用weakSelf -> 当 block 被声明为一个 property 的时候使用。
      __weak __typeof(self) weakSelf = self;
      [self executeBlock:^(NSData *data, NSError *error) {
      [weakSelf doSomethingWithData:data];
      }];
      先weak后strong -> 和并发执行有关。当涉及异步的服务的时候，block 可以在之后被执行，并且不会发生关于 self 是否存在的问题。
      __weak __typeof(self)weakSelf = self;
      [self executeBlock:^(NSData *data, NSError *error) {
      __strong __typeof(weakSelf) strongSelf = weakSelf;
      if (strongSelf) {
      [strongSelf doSomethingWithData:data];
      [strongSelf doSomethingWithData:data];
      }
      }];
      
      深度理解trivialBlock
      trivial block 是一个不被传送的 block ，它在一个良好定义和控制的作用域里面，weak 修饰只是为了避免循环引用。
      (详见effictive-objc2.0书中有相应见解)
      
      28.关于protocal委托与数据源两种模式
      关于委托，空方法返回的即回调
      当委托者询问代理者一些信息的时候，这就暗示着信息是从代理者流向委托者而非相反的过程。 这(译者注：委托者 ==Data==> 代理者)是概念性的不同，须用另一个新的名字来描述这种模式：数据源模式。
      此处说一下UITableViewDataSource
      - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
      - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
      此时委托者需要从数据源对象拉取数据
      以上两个方法 Apple 混合了展示层和数据层，实际上这不是一个好的设计，但是很少的开发者感到糟糕。而且我们在这里把空返回值和非空返回值的方法都天真地叫做委托方法。
      
      继承重写代理方法的坑
      假设以下情况
      UIViewControllerB < UIViewControllerA < UIViewController
      STEP1 --> UIViewControllerA 遵从 UITableViewDelegate 并且实现了
      - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{}
      
      STEP2 --> 你可能会想要在 UIViewControllerB 中提供一个不同的实现，这个实现可能是这样子的：
      - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
      CGFloat retVal = 0;
      if ([super respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
      retVal = [super tableView:self.tableView heightForRowAtIndexPath:indexPath];
      }
      return retVal + 10.0f;
      }
      但是如果超类(UIViewControllerA)没有实现这个方法呢？此时调用[super respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]方法，将使用 NSObject 的实现，在 self 上下文深入查找并且明确 self 实现了这个方法（因为 UITableViewControllerA 遵从 UITableViewDelegate），但是应用将在下一行发生崩溃，并提示如下错误信息：
      *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[UIViewControllerB tableView:heightForRowAtIndexPath:]: unrecognized selector sent to instance 0x8d82820'
      
      STEP3 --> 这种情况下我们需要来询问特定的类实例是否可以响应对应的 selector。下面的代码提供了一个小技巧：
      - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
      CGFloat retVal = 0;
      if ([[UIViewControllerA class] instancesRespondToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
      retVal = [super tableView:self.tableView heightForRowAtIndexPath:indexPath];
      }
      return retVal + 10.0f;
      }
      
      多重委托
      委托和数据源是对象之间的通讯模式，但是只涉及两个对象：委托者和委托。
      数据源模式强制一对一的关系，当发送者请求信息时有且只能有一个对象来响应。对于代理模式而言这会有些不同，我们有足够的理由要去实现很多代理者等待(唯一委托者的)回调的场景。
      相当于一个代理弱引用调度中心，所有委托的注册和解除都在这里
      
      面向切面编程
      在类的特定方法调用前运行特定的代码
      在类的特定方法调用后运行特定的代码
      增加代码来替代原来的类的方法的实现
      
      稍后会整理到印象笔记
      
      
     */
    
    /** 类似书籍：改善objc的61个建议
     *  NS_OPTION不失为NS_ENUM的另一个选择
     *  *未来需要了解的点--objc-c++混编
     *  关于Tagged Point的概念--/保存更多信息，提升内存访问速度，提高isa指针的处理效率
     *  *未来需要了解的点--内存对齐--内存结构
     *  编译器对NSString是进行过优化的，相同的永远指向同一块内存地址，release是无效的
     *  BOOL避免直接和YES作比较，逻辑运算符也可以有效返回BOOL类型
     *  关于内存 -- 计算机组成原理与操作系统补一波
     *  *内存管理 -- 留到高性能详细研究，现暂时停留在进阶阶段
     *
     *  很多MRC/MRR时代留下的一些奇奇怪怪的东西 -- 知道理解即可，不进行深入研究了
     *
     *  命名规则 = 基本规则 + 开心就好
     *  关于访问限制 -- 针对实例变量关键字，该什么时候用就什么时候用
     *  透彻了解属性 -- 利用扩展可以对属性进行篡改！！！
     *  MRC时代对getter和setter方法的处理在进行读写操作时分别需要注意的细节
     *  虚方法（虚函数）OC里的方法都是虚方法（virtual和@override关键字都省略了）通过正式协议@protocol就实现了纯虚函数的功能
     *  关于super，打算补充基类的实现行为就要调用super，替换基类实现行为则不需要调用
     *  *详细调查视图生命周期，initWithFrame:与initWithCoder:
     *  KVC&KVO注意事项 -- 间接访问类属性要使用valueForKeyPath -- 按层深度去寻找
     *  *KVC-实现原理isa-swizzling -- 引申：什么是isa-swizzling，runtime相关内容深入
     *  KVO -- NSKeyValueObserving非正式协议 -- 注册观察者记得要解除注册，否则会导致内存泄漏 -- 设计模式：观察者模式
     *  关于NSCopying
     *  使用Protocol来实现匿名对象的提供 -- 引申：iOS内实现接口编程
     *  当.m过于庞大的时候可以使用Catagory
     *  适当使用内省 -- 内省（Introspection）-- 高效的使用NSObject的内省方法
     *  1.确定对象在类层次中的位置class、superclass 2.检查对象类的从属关系isKindOfClass（接收者是否为给定类或其继承类的实例）、isMemberOfClass（接收者是否为指定类实例）
        3.方法实现和协议遵循respondsToSelector、conformsToProtocol 4.对象的比较hash（NSObject中的isEqual默认检查方法只能简单检查指针是否相等）、isEqual (isEqual判断相等，必然有相同的hash值)
        （三部曲：先比较指针，再比较类，最后强制类型检查）
     *  尽可能使用不可变对象而非可变对象（可变的开销更大，不确定的情况下用不可变对象处理）
     *  OC不支持多继承 -- 两个类或者对象巧妙融合（复合）-- 实现方法：说的很复杂，其实就是多个不同的子类继承自同一个父类
     *  使用extension来隐藏实现细节（还记得readonly -> readwrite吗）
     *  注意block的循环引用（weak-strong self dance）
     *  类别的使用（注意方法避免重名冲突）
     *  ARC，现在已经是ARC了，MRC就看看吧
     *  unsafe_unretained 有悬挂指针的危险（参考assign）（weak嘿嘿一笑）
     *  KVC/KVO作为一个面试点单独去整理（在effective objc2.0里还会出现吧，详细整理）
     *  浅复制适用于指针而深复制适用于数据
     *
     *
     *  
     *
     *
     */

    ///以下两个均为空指针
    NSString *ptr = nil;
    NSString *ptr1 = NULL;
    int *ptr2 = NULL;
    if(ptr2) {
        //非空指针
    } else {
        //空指针
    }
    
    NSNumber *number1 = @1;
    SYLog(@"%p",number1);
    
    id str = @"12122";
    SYLog(@"%@",[str class]);
    
    
    
    self.name = @"2";
    _name = @"2";
    
    NSString *aName = _name;
    NSString *bName = self.name;
    
    SYLog(@"%@,%@",aName,bName);
    
    NSString *ts = @"1111";
    NSString *qs = [ts copy];
    NSMutableString *rs = [ts mutableCopy];
    SYLog(@"%p",ts);
    SYLog(@"%p",qs);
    SYLog(@"%p",rs);
    SYLog(@"%p",&ts);
    SYLog(@"%p",&qs);
    SYLog(@"%p",&rs);
    
    

    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)setName:(NSString *)name {
    _name = name;
}

- (NSString *)name {
    return _name;
}

//- (BOOL)resolveInstanceMethod:(SEL) sel {
//    return [super resolveInstanceMethod:sel];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
