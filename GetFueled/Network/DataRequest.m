//
//  DataRequest.m
//  GetFueled
//
//  Created by Leonty Deriglazov on 07/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "DataRequest.h"
#import "DataRequest+Internal.h"

@interface DataRequest ()

@property (nonatomic, strong) NSMutableArray *startCallbacks;
@property (nonatomic, strong) NSMutableArray *completionCallbacks;
@property (nonatomic, strong) NSMutableArray *succededCallbacks;
@property (nonatomic, strong) NSMutableArray *beforeCompletionCallbacks;

@end

@implementation DataRequest

- (id)init {
    self = [super init];
    if (self) {
        self.startCallbacks = [NSMutableArray new];
        self.completionCallbacks = [NSMutableArray new];
        self.succededCallbacks = [NSMutableArray new];
        self.beforeCompletionCallbacks = [NSMutableArray new];
    }
    return self;
}

- (BOOL)succeeded {
    return self.completed && !self.error;
}

- (BOOL)failed {
    return self.completed && !!self.error;
}

- (void)started:(DataRequestCallback)callback {
    [self.startCallbacks addObject:callback];
}

- (void)completed:(DataRequestCallback)callback {
    [self.completionCallbacks addObject:callback];
}

- (void)beforeCompleted:(DataRequestCallback)callback {
    [self.beforeCompletionCallbacks addObject:callback];
}

- (void)failed:(DataErrorCallback)callback {
    [self completed:^(DataRequest *request) {
        if (!request.succeeded) {
            callback(request, request.error);
        }
    }];
}

- (void)succeeded:(DataSuccessCallback)callback {
    [self.succededCallbacks addObject:callback];
}

- (void)beforeSucceeded:(DataSuccessCallback)callback {
    [self beforeCompleted:^(DataRequest *request) {
        if (request.succeeded) {
            callback(request, request.result);
        }
    }];
}

@end

@implementation DataRequest (Internal)

- (void)didStart {
    if (self.started)
        return;
    
    _started = YES;
    for (DataRequestCallback callback in self.startCallbacks) {
        callback(self);
    }
    self.startCallbacks = nil;
}

- (void)didSucceed:(id)data {
    if (self.completed)
        return;
    
    self.result = data;
    
    [self didComplete];
}

- (void)didFail:(NSError *)error {
    if (self.completed)
        return;
    
    self.error = error;
    [self didComplete];
}

- (void)didComplete {
    _completed = YES;
    for (DataRequestCallback callback in self.beforeCompletionCallbacks) {
        callback(self);
    }
    
    for (DataSuccessCallback callback in self.succededCallbacks) {
        if (self.succeeded) {
            callback(self, self.result);
        }
    }
    
    for (DataRequestCallback callback in [self.completionCallbacks reverseObjectEnumerator]) {
        callback(self);
    }
    self.completionCallbacks = nil;
}

@end
