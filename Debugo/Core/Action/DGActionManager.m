//
//  DGActionManager.m
//  Debugo-Example-ObjectiveC
//
//  Created by ripper on 2019/5/31.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "DGActionManager.h"

@implementation DGActionManager

static DGActionManager *_instance;
+ (instancetype)shared {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

#pragma mark - getter
- (DGOrderedDictionary<NSString *,DGAction *> *)anonymousActionDic {
    if (!_anonymousActionDic) {
        _anonymousActionDic = [DGOrderedDictionary dictionary];
        _anonymousActionDic.moveToLastWhenUpdateValue = YES;
    }
    return _anonymousActionDic;
}

- (NSMutableDictionary<NSString *,DGOrderedDictionary<NSString *,DGAction *> *> *)usersActionsDic {
    if (!_usersActionsDic) {
        _usersActionsDic = [NSMutableDictionary dictionary];
    }
    return _usersActionsDic;
}

#pragma mark -
- (void)addActionForUser:(NSString *)user withTitle:(NSString *)title autoClose:(BOOL)autoClose handler:(DGActionHandlerBlock)handler {
    DGAction *action = [DGAction actionWithTitle:title autoClose:autoClose handler:handler];
    if (!action.isValid) {
        NSAssert(0, @"DGAction : titile 和 handler 不能为空!");
        return;
    }
    
    if (user.length) {
        action.user = user;
        DGOrderedDictionary <NSString *, DGAction *>*actionDic = [self.usersActionsDic objectForKey:user];
        if (!actionDic) {
            actionDic = [DGOrderedDictionary dictionary];
            actionDic.moveToLastWhenUpdateValue = YES;
            [self.usersActionsDic setObject:actionDic forKey:user];
        }
        [actionDic setObject:action forKey:action.title];
    }else {
        [self.anonymousActionDic setObject:action forKey:action.title];
    }
}

@end
