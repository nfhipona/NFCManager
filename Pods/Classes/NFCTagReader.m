//
//  NFCTagReader.m
//  Pods-NFCManager
//
//  Created by Neil Francis Hipona on 12/16/19.
//

#import "NFCTagReader.h"

@interface NFCTagReader() <NFCTagReaderSessionDelegate>

@property (nonatomic, strong) NFCTagReaderSession *session;

@end

@implementation NFCTagReader

#pragma mark - Initializer

- (instancetype)initSessionWithDelegate:(id<NFCReaderDelegate>)delegate alertMessage:(NSString *)alertMessage {
    
    self = [super initSessionWithDelegate:delegate
                             alertMessage:alertMessage];
    
    if (self) {
        
        NFCPollingOption option = NFCPollingISO14443 | NFCPollingISO15693 | NFCPollingISO18092;
        self.session = [[NFCTagReaderSession alloc] initWithPollingOption:option
                                                                 delegate:self
                                                                    queue:[NFCManager queue]];
        self.session.alertMessage = alertMessage;
    }
    
    return self;
}

#pragma mark - NFCTagReaderSessionDelegate

- (void)tagReaderSession:(NFCTagReaderSession *)session didInvalidateWithError:(NSError *)error {
    
    [self.delegate reader:self didInvalidateWithError:error];
}

- (void)tagReaderSessionDidBecomeActive:(NFCTagReaderSession *)session {
    
    if ([self.delegate respondsToSelector:@selector(readerDidBecomeActive:)]) {
        [self.delegate readerDidBecomeActive:self];
    }
}

- (void)tagReaderSession:(NFCTagReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCTag>> *)tags {
    
    if ([self.delegate respondsToSelector:@selector(reader:didDetectTags:)]) {
        [self.delegate reader:self didDetectTags:tags];
    }
}

#pragma mark - Methods

- (void)begin {
    
    if (self.session) {
        [self.session beginSession];
    }
}

- (void)restart {
    
    if (self.session) {
        [self.session restartPolling];
    }else{
        // create and start immediately
        NFCPollingOption option = NFCPollingISO14443 | NFCPollingISO15693 | NFCPollingISO18092;
        self.session = [[NFCTagReaderSession alloc] initWithPollingOption:option
                                                                 delegate:self
                                                                    queue:[NFCManager queue]];
        self.session.alertMessage = self.alertMessage;
        [self.session beginSession];
    }
}

- (void)end {
    
    if (self.session) {
        [self.session invalidateSession];
    }
}

- (void)writeMessage:(NFCNDEFMessage *)message toTag:(nonnull id<NFCTag>)tag connectHandler:(nonnull void (^)(NSError * _Nullable))connectHandler writeHandler:(nonnull void (^)(NFCNDEFStatus, NSUInteger, NSError * _Nullable))writeHandler {
    
    [self.session connectToTag:tag completionHandler:^(NSError * _Nullable error) {
        if (error) {
            connectHandler(error);
        }else{
            switch (tag.type) {
                case NFCTagTypeISO15693: {
                    [self queryTag:[tag asNFCISO15693Tag] andWriteMessage:message queryHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError * _Nullable error) {
                        
                    } writeHandler:^(NSError * _Nullable error) {
                        
                    }];
                } break;
                    
                case NFCTagTypeFeliCa: {
                    [self queryTag:[tag asNFCFeliCaTag] andWriteMessage:message queryHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError * _Nullable error) {
                        
                    } writeHandler:^(NSError * _Nullable error) {
                        
                    }];
                } break;
                    
                case NFCTagTypeISO7816Compatible: {
                    [self queryTag:[tag asNFCISO7816Tag] andWriteMessage:message queryHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError * _Nullable error) {
                        
                    } writeHandler:^(NSError * _Nullable error) {
                        
                    }];
                } break;
                    
                case NFCTagTypeMiFare: {
                    [self queryTag:[tag asNFCMiFareTag] andWriteMessage:message queryHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError * _Nullable error) {
                        
                    } writeHandler:^(NSError * _Nullable error) {
                        
                    }];
                } break;
                    
                default: break;
            }
        }
    }];
}

- (void)queryTag:(id <NFCNDEFTag>)tag andWriteMessage:(NFCNDEFMessage *)message queryHandler:(nonnull void(^)(NFCNDEFStatus status, NSUInteger capacity, NSError *_Nullable error))queryHandler writeHandler:(nonnull void(^)(NSError *_Nullable error))writeHandler{
    
    [tag queryNDEFStatusWithCompletionHandler:^(NFCNDEFStatus status, NSUInteger capacity, NSError * _Nullable error) {
        
        if (status == NFCNDEFStatusReadWrite && !error) {
            [tag writeNDEF:message completionHandler:^(NSError * _Nullable error) {
                writeHandler(error);
            }];
        }else{
            queryHandler(status, capacity, error);
        }
    }];
}

@end
