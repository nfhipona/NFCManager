//
//  NFCReader.h
//  Pods-NFCManager
//
//  Created by Neil Francis Hipona on 1/14/20.
//

#import <Foundation/Foundation.h>
#import "NFCManager.h"

NS_ASSUME_NONNULL_BEGIN

/*!
* @discussion      For reading and displaying tags implement legacy:YES and reader:didDetectNDEFs:messages
*                           delegate. Tag messages contains records.
*                           For reading and writing to tags impelement reader:didDetectTags:tags. legacy:YES will result to old way of reading tags
*                           and will not support newer tags.
*/

@interface NFCReader : NSObject

@property (nonatomic, strong) NSString *alertMessage;
@property (nonatomic) BOOL invalidate;

@property (nonatomic, weak) id<NFCReaderDelegate> delegate;

#pragma mark - Initializer

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initSessionWithDelegate:(id <NFCReaderDelegate>)delegate alertMessage:(NSString *)alertMessage NS_DESIGNATED_INITIALIZER;
- (instancetype)initSessionWithDelegate:(id <NFCReaderDelegate>)delegate invalidateAfterFirstRead:(BOOL)invalidate alertMessage:(NSString *)alertMessage NS_DESIGNATED_INITIALIZER;

#pragma mark - Methods

- (void)begin;
- (void)restart;
- (void)end;

@end

NS_ASSUME_NONNULL_END
