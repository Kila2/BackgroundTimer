//
//  LLBKTimeCounter.m
//  BackgroundTimer
//
//  Created by Kila on 2017/9/8.
//  Copyright © 2017年 Kila. All rights reserved.
//

#import "LLBKTimeCounter.h"
#define kLLBKTimeCounterData @"kLLBKTimeCounterData"
typedef void (^CTPTaskBlock)(NSTimer *timer);
static BOOL isFirstBecomeActive = YES;

@interface LLBKTimeCounter ()
@property (nonatomic,assign,getter=timeSpace) NSTimeInterval timeSpace;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy)   NSString *identifier;
@property (nonatomic,copy)   CTPTaskBlock block;
@property (nonatomic,strong) NSMutableArray<NSDictionary *> *jsonParams;
@property (nonatomic,strong) NSDictionary *findedTask;
@end

@implementation LLBKTimeCounter

+ (LLBKTimeCounter *)timeCounter {
    LLBKTimeCounter *timeCounter = [[LLBKTimeCounter alloc] init];
    return timeCounter;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        [self initProperty];
        self.identifier = identifier;
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startTimer:(NSTimeInterval)remaintime  block:(void (^)(NSTimer *timer))block {
    NSDate *now = [NSDate date];
    if (self.timer!=nil&&[self.timer isValid]){
        NSLog(@"Timer is still running this code is invalid");
        return;
    }
    self.block = block;
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.remaintime--;
        if (weakSelf.remaintime <= 0) {
            [weakSelf.timer invalidate];
            weakSelf.timer = nil;
            NSLog(@"Timer is stop");
        }
        else {
            weakSelf.block(self.timer);
        }
    }];
    
    BOOL exist = [self existIdentifierInDB];
    if (exist) {
        NSTimeInterval startTime = [[self.findedTask objectForKey:@"startTime"] doubleValue];
        NSTimeInterval nowTime = [now timeIntervalSinceReferenceDate];
        NSTimeInterval totalTime = [[self.findedTask objectForKey:@"totalTime"] doubleValue];
        self.remaintime =  totalTime - (nowTime - startTime);
    }
    else {
        self.remaintime = remaintime;
        [self addTask:@([now timeIntervalSinceReferenceDate])
            totalTime:@(remaintime)
           identifier:self.identifier];
    }
}

- (void)initProperty {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kLLBKTimeCounterData];
    if (array == nil) {
        self.jsonParams = [NSMutableArray array];
    }
    else {
        self.jsonParams = [NSMutableArray arrayWithArray:array];
    }
}

- (void)didEnterBackground {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didBecomeActive {
    if(!isFirstBecomeActive&&self.remaintime>=0) {
        [self startTimer:self.remaintime - self.timeSpace block:self.block];
    }
    isFirstBecomeActive = NO;
}

- (BOOL)existIdentifierInDB{
    for (NSDictionary *task in self.jsonParams) {
        NSString * identifier = [task objectForKey:@"identifier"];
        if ([identifier isEqualToString:self.identifier]) {
            self.findedTask = task;
            return YES;
        }
    }
    return NO;
}

- (void)addTask:(NSNumber *)startTime totalTime:(NSNumber *)totalTime identifier:(NSString *)identifier {
    NSDictionary *task = @{@"startTime":startTime,
                           @"totalTime":totalTime,
                           @"identifier":identifier};
    [self.jsonParams addObject:task];
    [[NSUserDefaults standardUserDefaults] setObject:self.jsonParams forKey:kLLBKTimeCounterData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
