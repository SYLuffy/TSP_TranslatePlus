//
//  NSObject+TSPController.h
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TSPController)

/**
 *  获取当前屏幕的viewcontroller
 *
 *  @return 当前屏幕显示的最顶层的vc
 */
- (UIViewController *)tsp_getCurrentUIVC;

/**
 *  从导航栏控制器中获取一个类的实例
 *  @param className 类名
 *
 *  @return 该类的实例
 */
+ (nullable UIViewController *)tsp_getViewControllerFromCurrentStackWithClassName:(Class)className;

/**
 * 从导航栏控制器中获取一个类的实例
 * @param nav 控制器
 * @param className 类名
 *
 * @return 该类的实例
 */
+ (nullable UIViewController *)tsp_getViewControllerFromStack:(UINavigationController *)nav WithClassName:(Class)className;

/**
 *  导航栏控制器中是否存在类
 *  @param className 类型
 *
 *  @return YES 存在
 */
+ (BOOL)tsp_currentStackisContainClass:(Class)className;

/**
 *  导航栏控制器中是否存在类
 *  @param className 类型
 *
 *  @return YES 存在
 */
+ (BOOL)tsp_oneStackisContainClass:(Class)className WithStack:(UINavigationController *)nav;

/**
 *  pop 到指定类名的vc
 *  @param className 类名
 */
+ (void)tsp_popToVCFromCurrentStackTargetVCClass:(Class)className;

/**
 *  导航栏控制器中移除类
 *  @param className 类名
 *
 *  @return YES 成功
 */
+ (BOOL)tsp_cleanFromCurrentStackTargetVCClass:(Class)className;

/**
 *  导航栏控制器中移除类的数组
 *  @param classArray 类名数组
 */
+ (void)tsp_cleanFromCurrentStackTargetVCArrayClass:(NSArray<Class> *)classArray;

/**
 *  移除当前控制器中，指定的类
 *  @param vcToRemove 要移除的类
 */
+ (void)tsp_removeVCFromCurrentStack:(__kindof UIViewController *)vcToRemove;

/**
 *  移除当前控制器中，指定的类,数组
 *  @param vcsToRemove 要移除的类的数组
 */
+ (void)tsp_removeVCsFromCurrentStack:(NSArray <__kindof UIViewController *>*)vcsToRemove;

/**
 *  在当前控制器栈中添加一个vc到index位置
 *  @param vc vc
 *  @param index 要添加到位置
 */
+ (void)tsp_addVCToCurrentStack:( __kindof UIViewController * _Nonnull)vc toIndex:(NSUInteger)index;

/**
 *  在当前控制器栈中添加一个vc到index位置
 *  @param vcs vcs
 *  @param index 要添加到位置
 */
+ (void)tsp_addVCsToCurrentStack:(NSArray <__kindof UIViewController * > * _Nonnull)vcs toIndex:(NSUInteger)index;

/**
 *  保持栈中仅有一个该类
 *  @param vc 类的实例
 *  @param nav 导航栏控制器
 */
+ (void)tsp_keepOnlyVC:(UIViewController *)vc FormStackWithNavigationController:(UINavigationController *)nav;

/**
 *  保持栈中仅有一个该类
 *  @param vc 类的实例
 */
+ (void)tsp_keepOnlyVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
