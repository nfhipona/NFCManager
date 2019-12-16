//
//  NFCReader.m
//  Pods-NFCManager
//
//  Created by Neil Francis Hipona on 12/16/19.
//

#import "NFCReader.h"

@interface NFCReader() <NFCReaderSessionDelegate>

@end

@implementation NFCReader

#pragma mark - NFCReaderSessionDelegate

- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error {
    
}

- (void)readerSessionDidBecomeActive:(NFCReaderSession *)session {
    
}
    
@end
