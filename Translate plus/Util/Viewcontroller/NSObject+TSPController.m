//
//  NSObject+TSPController.m
//  Translate plus
//
//  Created by shen on 2024/4/18.
//

#import "NSObject+TSPController.h"

@implementation NSObject (TSPController)

- (UIViewController *)tsp_getCurrentUIVC {
    return [self tsp_getCurrentVC];
}

- (UIViewController *)tsp_getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [self tsp_getCurrentVCFrom:[rootVC presentedViewController]];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self tsp_getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self tsp_getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

- (UIViewController *)tsp_getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self tsp_getCurrentVCFrom:rootViewController];

    return currentVC;
}

+ (nullable UIViewController *)tsp_getViewControllerFromCurrentStackWithClassName:(Class)className {
    return [self tsp_getViewControllerFromStack:[self tsp_getCurrentAvailableNavController] WithClassName:className];
}

+ (nullable UINavigationController *)tsp_getCurrentAvailableNavController {
    UIViewController *currentVC = [self tsp_getCurrentVC];
    if (currentVC) {
        return currentVC.navigationController;
    }
    return nil;
}

+ (nullable UIViewController *)tsp_getViewControllerFromStack:(UINavigationController *)nav WithClassName:(Class)className {
    NSArray *vcs = nav.viewControllers;
    UIViewController *tempVC = nil;
    for (id vc in vcs) {
        if ([vc isMemberOfClass:className]) {
            tempVC = vc;
            break;
        }
    }
    return tempVC;
}

+ (BOOL)tsp_currentStackisContainClass:(Class)className {
    return [self tsp_oneStackisContainClass:className WithStack:[self tsp_getCurrentAvailableNavController]];
}

+ (BOOL)tsp_oneStackisContainClass:(Class)className WithStack:(UINavigationController *)nav {
    BOOL flag = NO;
    NSArray *vcs = nav.viewControllers;
    for (id vc in vcs) {
        if ([vc isMemberOfClass:className]) {
            flag = YES;
            break;
        }
    }
    return flag;
}

+ (void)tsp_popToVCFromCurrentStackTargetVCClass:(Class)className {
    UIViewController *vc = [self tsp_getViewControllerFromCurrentStackWithClassName:className];
    if (vc) {
        [vc.navigationController popToViewController:vc animated:YES];
    }
}

+ (BOOL)tsp_cleanFromCurrentStackTargetVCClass:(Class)className {
    UIViewController *tempVC = [self tsp_getViewControllerFromCurrentStackWithClassName:className];
    if (tempVC) {
        [self tsp_removeVCFromCurrentStack:tempVC];
        return YES;
    }
    return NO;
}

+ (void)tsp_cleanFromCurrentStackTargetVCArrayClass:(NSArray<Class> *)classArray {
    NSMutableArray *tempVCS = [NSMutableArray new];
    UIViewController *currentVC = [self tsp_getCurrentVC];
    NSMutableArray *vcs = currentVC.navigationController.viewControllers.mutableCopy;
    for (Class className in classArray) {
        for (UIViewController *containVC in vcs) {
            if ([containVC isMemberOfClass:className]) {
                if (![tempVCS containsObject:containVC]) {
                    [tempVCS addObject:containVC];
                }
            }
        }
    }
    [vcs removeObjectsInArray:tempVCS];
    [currentVC.navigationController setViewControllers:vcs.copy];
}

+ (void)tsp_removeVCFromCurrentStack:(__kindof UIViewController *)vcToRemove {
    UINavigationController *nav = [self tsp_getCurrentAvailableNavController];
    NSMutableArray *vcs = nav.viewControllers.mutableCopy;
    [vcs enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == vcToRemove) {
            [vcs removeObject:obj];
        }
    }];
    nav.viewControllers = vcs;
}

+ (void)tsp_removeVCsFromCurrentStack:(NSArray <__kindof UIViewController *>*)vcsToRemove {
    UIViewController *vc = [vcsToRemove lastObject];
    NSMutableArray *vcs = vc.navigationController.viewControllers.mutableCopy;
    NSMutableArray *tempVcsToRemove = [NSMutableArray new];
    for (id vcToRemove in vcsToRemove) {
        for (UIViewController *tempVC in vcs) {
            if ([vcToRemove isEqual:tempVC]) {
                [tempVcsToRemove addObject:tempVC];
                break;
            }
        }
    }
    [vcs removeObjectsInArray:tempVcsToRemove];
    [vc.navigationController setViewControllers:vcs];
}

+ (void)tsp_addVCToCurrentStack:( __kindof UIViewController * _Nonnull)vc toIndex:(NSUInteger)index {
    [self tsp_addVCsToCurrentStack:@[vc] toIndex:index];
}

+ (void)tsp_addVCsToCurrentStack:(NSArray <__kindof UIViewController * > * _Nonnull)vcs toIndex:(NSUInteger)index {
    UIViewController *currentVC = [self tsp_getCurrentVC];
    NSMutableArray *array = currentVC.navigationController.viewControllers.mutableCopy;
    if (index >= array.count) {
        [array addObjectsFromArray:vcs];
    } else {
        [array insertObjects:vcs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, vcs.count)]];
    }
    [currentVC.navigationController setViewControllers:array];
}

+ (void)tsp_keepOnlyVC:(UIViewController *)vc FormStackWithNavigationController:(UINavigationController *)nav {
    NSMutableArray *tempVCS = [NSMutableArray new];
    NSMutableArray *vcs = nav.navigationController.viewControllers.mutableCopy;
    for (UIViewController *tempVC in vcs) {
        // 得到当前控制器中所有的vc
        if ([tempVC isMemberOfClass:[vc class]]) {
            [tempVCS addObject:tempVC];
        }
    }
    // 保留最后一个
    [tempVCS removeLastObject];
    [vcs removeObjectsInArray:tempVCS];
    [nav setViewControllers:vcs];
}

+ (void)tsp_keepOnlyVC:(UIViewController *)vc {
     [self tsp_keepOnlyVC:vc FormStackWithNavigationController:[self tsp_getCurrentAvailableNavController]];
}


@end
