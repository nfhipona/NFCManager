//
//  NFCNDEFWriter.h
//  Pods-NFCManager
//
//  Created by Neil Francis Hipona on 1/14/20.
//

#import <Foundation/Foundation.h>
#import "NFCReader.h"

NS_ASSUME_NONNULL_BEGIN

@interface NFCNDEFWriter : NFCReader

- (void)writeMessage:(NFCNDEFMessage *)message toTag:(nonnull id<NFCNDEFTag>)tag connectHandler:(nonnull void(^)(NSError *_Nullable error))connectHandler queryHandler:(nonnull void(^)(NFCNDEFStatus status, NSUInteger capacity, NSError *_Nullable error))queryHandler writeHandler:(nonnull void(^)(NSError *_Nullable error))writeHandler;

@end

NS_ASSUME_NONNULL_END
