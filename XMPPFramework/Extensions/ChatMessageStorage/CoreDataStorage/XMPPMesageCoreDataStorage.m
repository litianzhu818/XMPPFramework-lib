//
//  XMPPChatMesageCoreDataStorage.m
//  XMPP_Project
//
//  Created by Peter Lee on 14/9/30.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "XMPPMesageCoreDataStorage.h"
#import "XMPPCoreDataStorageProtected.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "NSNumber+XMPP.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_INFO; // | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

#define AssertPrivateQueue() \
NSAssert(dispatch_get_specific(storageQueueTag), @"Private method: MUST run on storageQueue");

@implementation XMPPMesageCoreDataStorage
static XMPPMesageCoreDataStorage *sharedInstance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[XMPPMesageCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
    });
    
    return sharedInstance;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Setup
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)commonInit
{
    XMPPLogTrace();
    [super commonInit];
    
    // This method is invoked by all public init methods of the superclass
    autoRemovePreviousDatabaseFile = YES;
    autoRecreateDatabaseFile = YES;
    
    //chatRoomPopulationSet = [[NSMutableSet alloc] init];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark -
#pragma mark - XMPPAllMessageStorage Methods
- (BOOL)configureWithParent:(XMPPAllMessage *)aParent queue:(dispatch_queue_t)queue
{
    return [super configureWithParent:aParent queue:queue];
}

- (void)archiveMessage:(XMPPMessage *)message sendFromMe:(BOOL)sendFromMe activeUser:(NSString *)activeUser xmppStream:(XMPPStream *)xmppStream
{
    [self scheduleBlock:^{
        
        NSManagedObjectContext *moc = [self managedObjectContext];
        NSString *myBareJidStr = [[self myJIDForXMPPStream:xmppStream] bare];
        NSString *userJidStr = sendFromMe ? [[message to] bare]:[[message from] bare];
        NSUInteger unReadMessageCount = sendFromMe ? 0:([[[message from] bare] isEqualToString:activeUser] ? 0:1);
        
        NSString *jsonString = [message body];
        //This Dictionary has no from,to,sendFromMe,
        NSMutableDictionary *messageDic = [jsonString objectFromJSONString];
        [messageDic setObject:myBareJidStr forKey:@"streamBareJidStr"];
        [messageDic setObject:userJidStr forKey:@"bareJidStr"];
        [messageDic setObject:[NSNumber numberWithBool:sendFromMe] forKey:@"sendFromMe"];
        //If the unread message count is equal to zero,we will know that this message has been readed
        [messageDic setObject:[NSNumber numberWithBool:(unReadMessageCount < 1)] forKey:@"hasBeenRead"];
        
        
        
    }];
}

@end
