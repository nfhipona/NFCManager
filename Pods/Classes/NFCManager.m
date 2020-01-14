//
//  NFCManager.m
//  Pods-NFCManager
//
//  Created by Neil Francis Hipona on 12/16/19.
//

#import "NFCManager.h"
#import "NFCNDEFReader.h"
#import "NFCNDEFWriter.h"
#import "NFCTagReader.h"

@interface NFCManager()

@property (nonatomic, strong) NFCReader *reader;

@end

@implementation NFCManager

#pragma mark - Shared manager

+ (NFCManager *)manager {
    
    static NFCManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NFCManager alloc] init];
    });
    
    return manager;
}

+ (dispatch_queue_t)queue {
    
    static dispatch_queue_t q = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        q = dispatch_queue_create("com.NFCManager.queue", 0);
    });
    
    return q;
}

#pragma mark - Class Helper

+ (BOOL)isAvailable {
    
    return [NFCReaderSession readingAvailable];
}

#pragma mark - Initializers

- (void)newReaderSessionWithDelegate:(id<NFCReaderDelegate>)delegate invalidateAfterFirstRead:(BOOL)invalidate alertMessage:(NSString *)alertMessage {
    
    self.reader = [[NFCNDEFReader alloc] initSessionWithDelegate:delegate
                                        invalidateAfterFirstRead:invalidate
                                                    alertMessage:alertMessage];
}

- (void)newWriterSessionWithDelegate:(id<NFCReaderDelegate>)delegate isLegacy:(BOOL)legacy invalidateAfterFirstRead:(BOOL)invalidate alertMessage:(NSString *)alertMessage {
 
    if (legacy) {
        self.reader = [[NFCNDEFWriter alloc] initSessionWithDelegate:delegate
                                            invalidateAfterFirstRead:invalidate
                                                        alertMessage:alertMessage];
    }else{
        self.reader = [[NFCTagReader alloc] initSessionWithDelegate:delegate
                                                       alertMessage:alertMessage];
    }
}

#pragma mark - Helper

- (void)begin {
    
    if (self.reader) {
        [self.reader begin];
    }
}

- (void)restart {
    
    if (self.reader) {
        [self.reader restart];
    }
}

- (void)end {
    
    if (self.reader) {
        [self.reader end];
    }
}

- (BOOL)canWrite {
    
    if ([self.reader isKindOfClass:[NFCNDEFWriter class]]) {
        return YES;
    }
    else if ([self.reader isKindOfClass:[NFCTagReader class]]) {
        return YES;
    }
    
    return NO;
}

- (NFCNDEFPayload *)createPayloadWithFormat:(NFCTypeNameFormat)format type:(NSString *)type indetifier:(NSString *)identifier message:(NSString *)payload {
    
    NSData *typeData = [type dataUsingEncoding:kCFStringEncodingUTF8];
    NSData *identifierData = [identifier dataUsingEncoding:kCFStringEncodingUTF8];
    NSData *payloadData = [payload dataUsingEncoding:kCFStringEncodingUTF8];
    
    NFCNDEFPayload *nfcPayload = [[NFCNDEFPayload alloc] initWithFormat:format
                                                          type:typeData
                                                    identifier:identifierData
                                                       payload:payloadData];
    
    return nfcPayload;
}

- (NFCNDEFMessage *)messageWithPayloads:(NSArray <NFCNDEFPayload *>*)payloads {
    
    NFCNDEFMessage *message = [[NFCNDEFMessage alloc] initWithNDEFRecords:payloads];
    
    return message;
}

- (void)writeMessage:(NFCNDEFMessage *)message toTag:(id<NFCNDEFTag>)tag {
    
    
}

- (NSString *)parseNFCError:(NSError *)error {
    
    switch (error.code) {
        case NFCReaderSessionInvalidationErrorFirstNDEFTagRead: {
            if (self.isDebug) NSLog(@"NFCManager error: NFCReaderSessionInvalidationErrorFirstNDEFTagRead");
        
            return ErrorFirstNDEFTagRead;
        } break;
            
        case NFCReaderSessionInvalidationErrorUserCanceled: {
            if (self.isDebug) NSLog(@"NFCManager error: NFCReaderSessionInvalidationErrorUserCanceled");
          
            return ErrorUserCanceled;
        } break;
            
        case NFCReaderSessionInvalidationErrorSessionTimeout: {
            if (self.isDebug) NSLog(@"NFCManager error: NFCReaderSessionInvalidationErrorSessionTimeout");
            
            return ErrorSessionTimeout;
        } break;
            
        case NFCReaderSessionInvalidationErrorSystemIsBusy: {
            if (self.isDebug) NSLog(@"NFCManager error: NFCReaderSessionInvalidationErrorSystemIsBusy");
            
            return ErrorSystemIsBusy;
        } break;
            
        case NFCReaderSessionInvalidationErrorSessionTerminatedUnexpectedly: {
            if (self.isDebug) NSLog(@"NFCManager error: NFCReaderSessionInvalidationErrorSessionTerminatedUnexpectedly");
            
            return ErrorSessionTerminatedUnexpectedly;
        } break;
            
        default: { // NFCReaderErrorUnsupportedFeature
            if (self.isDebug) NSLog(@"NFCManager error: NFCReaderErrorUnsupportedFeature");
            
            return ErrorUnsupportedFeature;
        } break;
    }
}


@end
