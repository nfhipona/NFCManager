//
//  NFCNDEFReader.m
//  Pods-NFCManager
//
//  Created by Neil Francis Hipona on 12/16/19.
//

#import "NFCNDEFReader.h"

@interface NFCNDEFReader() <NFCNDEFReaderSessionDelegate>

@end

@implementation NFCNDEFReader

#pragma mark - NFCNDEFReaderSessionDelegate

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error {
    
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages {

    
}

- (void)readerSession:(NFCNDEFReaderSession *)session didDetectTags:(NSArray<__kindof id<NFCNDEFTag>> *)tags {
    
}

@end
