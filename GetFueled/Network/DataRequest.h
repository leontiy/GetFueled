//
//  DataRequest.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 07/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;
@class DataRequest;

typedef void (^DataRequestCallback)(DataRequest *request);
typedef void (^DataSuccessCallback)(DataRequest *request, id result);
typedef void (^DataErrorCallback)(DataRequest *request, NSError *error);


@interface DataRequest : NSObject

@property(nonatomic) BOOL userInitiated;
@property(nonatomic) NSString *progressMessage;
@property(nonatomic) NSString *errorMessage;

@property(nonatomic, readonly) BOOL started;
@property(nonatomic, readonly) BOOL completed;
@property(nonatomic, readonly) BOOL succeeded;
@property(nonatomic, readonly) BOOL failed;
@property(nonatomic) BOOL failureHandled;

@property(nonatomic, readonly) AFHTTPRequestOperation *operation;

@property(nonatomic, strong) NSError *error;
@property(nonatomic, strong) id result;

- (void)started:(DataRequestCallback)callback;
- (void)completed:(DataRequestCallback)callback;

- (void)failed:(DataErrorCallback)callback;
- (void)succeeded:(DataSuccessCallback)callback;

- (void)beforeCompleted:(DataRequestCallback)callback;
- (void)beforeSucceeded:(DataSuccessCallback)callback;

@end
