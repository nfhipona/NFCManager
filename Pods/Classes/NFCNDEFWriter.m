//
//  NFCNDEFWriter.m
//  Pods-NFCManager
//
//  Created by Neil Francis Hipona on 1/14/20.
//

#import "NFCNDEFWriter.h"

@interface NFCNDEFWriter() <NFCNDEFReaderSessionDelegate>

@property (nonatomic, strong) NFCNDEFReaderSession *session;

@end

@implementation NFCNDEFWriter

#pragma mark - Initializer

- (instancetype)initSessionWithDelegate:(id<NFCReaderDelegate>)delegate invalidateAfterFirstRead:(BOOL)invalidate alertMessage:(NSString *)alertMessage {
    
    self = [super initSessionWithDelegate:delegate
                 invalidateAfterFirstRead:invalidate
                             alertMessage:alertMessage];

    if (self) {
        self.session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:[NFCManager queue] invalidateAfterFirstRead:invalidate];
        self.session.alertMessage = alertMessage;
    }
    
    return self;
}

#pragma mark - NFCNDEFReaderSessionDelegate

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error {
    
    [self.delegate reader:self didInvalidateWithError:error];
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages {
    
    [self.delegate reader:self didDetectNDEFs:messages];
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCNDEFTag>> *)tags {
    
    if ([self.delegate respondsToSelector:@selector(reader:didDetectTags:)]) {
        [self.delegate reader:self didDetectTags:tags];
    }
}

- (void)readerSessionDidBecomeActive:(NFCNDEFReaderSession *)session {
    
    if ([self.delegate respondsToSelector:@selector(readerDidBecomeActive:)]) {
        [self.delegate readerDidBecomeActive:self];
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
        self.session = [[NFCNDEFReaderSession alloc] initWithDelegate:self
                                                                queue:[NFCManager queue]
                                             invalidateAfterFirstRead:self.invalidate];
        self.session.alertMessage = self.alertMessage;
        [self.session beginSession];
    }
}

- (void)end {
    
    if (self.session) {
        [self.session invalidateSession];
    }
}

- (void)writeMessage:(NFCNDEFMessage *)message toTag:(nonnull id<NFCNDEFTag>)tag connectHandler:(nonnull void (^)(NSError * _Nullable))connectHandler queryHandler:(nonnull void (^)(NFCNDEFStatus, NSUInteger, NSError * _Nullable))queryHandler writeHandler:(nonnull void (^)(NSError * _Nullable))writeHandler {
    
    [self.session connectToTag:tag completionHandler:^(NSError * _Nullable error) {
        
        if (error) {
            connectHandler(error);
        }else{
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
    }];
}

@end
