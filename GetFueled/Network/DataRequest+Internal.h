//
//  DataRequest+Internal.h
//  GetFueled
//
//  Created by Leonty Deriglazov on 07/09/2014.
//  Copyright (c) 2014 Leonty Deriglazov. All rights reserved.
//

#import "DataRequest.h"

@interface DataRequest (Internal)

- (void)didStart;
- (void)didSucceed:(id)data;
- (void)didFail:(NSError *)error;
- (void)didComplete;

@end
