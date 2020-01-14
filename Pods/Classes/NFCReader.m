//
//  NFCReader.m
//  Pods-NFCManager
//
//  Created by Neil Francis Hipona on 1/14/20.
//

#import "NFCReader.h"

@implementation NFCReader

#pragma mark - Initializer

- (instancetype)initSessionWithDelegate:(id<NFCReaderDelegate>)delegate alertMessage:(NSString *)alertMessage {
    self = [super init];
    
    if (self) {
        self.alertMessage = alertMessage;
    }
    
    return self;
}

- (instancetype)initSessionWithDelegate:(id <NFCReaderDelegate>)delegate invalidateAfterFirstRead:(BOOL)invalidate alertMessage:(NSString *)alertMessage {
    self = [super init];
    
    if (self) {
        self.invalidate = invalidate;
        self.alertMessage = alertMessage;
    }
    
    return self;
}

#pragma mark - Methods

- (void)begin {
    
}

- (void)restart {
    
}

- (void)end {
    
}


@end
