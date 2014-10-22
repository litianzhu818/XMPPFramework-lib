//
//  XMPPChatMessage.m
//  XMPP_Project
//
//  Created by Peter Lee on 14/9/29.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//
#import "XMPPAllMessage.h"
#import "XMPPFramework.h"
#import "XMPPLogging.h"
#import "NSNumber+XMPP.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

// Log levels: off, error, warn, info, verbose
// Log flags: trace
#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN; // | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

#define XMLNS_XMPP_ARCHIVE @"urn:xmpp:archive"

@implementation XMPPAllMessage

- (id)init
{
    // This will cause a crash - it's designed to.
    // Only the init methods listed in XMPPMessageArchiving.h are supported.
    
    return [self initWithMessageStorage:nil dispatchQueue:NULL];
}

- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
    // This will cause a crash - it's designed to.
    // Only the init methods listed in XMPPMessageArchiving.h are supported.
    
    return [self initWithMessageStorage:nil dispatchQueue:queue];
}

- (id)initWithMessageStorage:(id <XMPPAllMessageStorage>)storage
{
    return [self initWithMessageStorage:storage dispatchQueue:NULL];
}

- (id)initWithMessageStorage:(id <XMPPAllMessageStorage>)storage dispatchQueue:(dispatch_queue_t)queue
{
    NSParameterAssert(storage != nil);
    
    if ((self = [super initWithDispatchQueue:queue])){
        if ([storage configureWithParent:self queue:moduleQueue]){
            xmppMessageStorage = storage;
        }else{
            XMPPLogError(@"%@: %@ - Unable to configure storage!", THIS_FILE, THIS_METHOD);
        }
        
        //setting the dafault data
        receiveSystemPushMessage = YES;
        receiveUserRequestMessage = YES;
        clientSideMessageArchivingOnly = YES;
        
        activeUser = nil;
        
        NSXMLElement *_default = [NSXMLElement elementWithName:@"default"];
        [_default addAttributeWithName:@"expire" stringValue:@"604800"];
        [_default addAttributeWithName:@"save" stringValue:@"body"];
        
        NSXMLElement *pref = [NSXMLElement elementWithName:@"pref" xmlns:XMLNS_XMPP_ARCHIVE];
        [pref addChild:_default];
        
        preferences = pref;
    }
    return self;
}

- (BOOL)activate:(XMPPStream *)aXmppStream
{
    XMPPLogTrace();
    
    if ([super activate:aXmppStream])
    {
        XMPPLogVerbose(@"%@: Activated", THIS_FILE);
        
        // Reserved for future potential use
        
        return YES;
    }
    
    return NO;
}

- (void)deactivate
{
    XMPPLogTrace();
    
    // Reserved for future potential use
    
    [super deactivate];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Properties' getters and setters
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id <XMPPAllMessageStorage>)xmppMessageStorage
{
    // Note: The xmppMessageStorage variable is read-only (set in the init method)
    
    return xmppMessageStorage;
}

- (BOOL)clientSideMessageArchivingOnly
{
    __block BOOL result = NO;
    
    dispatch_block_t block = ^{
        result = clientSideMessageArchivingOnly;
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_sync(moduleQueue, block);
    
    return result;
}

- (void)setClientSideMessageArchivingOnly:(BOOL)flag
{
    dispatch_block_t block = ^{
        clientSideMessageArchivingOnly = flag;
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}

- (BOOL)receiveUserRequestMessage
{
    __block BOOL result = NO;
    
    dispatch_block_t block = ^{
        result = receiveUserRequestMessage;
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_sync(moduleQueue, block);
    
    return result;
}

- (void)setReceiveUserRequestMessage:(BOOL)flag
{
    dispatch_block_t block = ^{
        receiveUserRequestMessage = flag;
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}

- (BOOL)receiveSystemPushMessage
{
    __block BOOL result = NO;
    
    dispatch_block_t block = ^{
        result = receiveSystemPushMessage;
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_sync(moduleQueue, block);
    
    return result;
}

- (void)setReceiveSystemPushMessage:(BOOL)flag
{
    dispatch_block_t block = ^{
        receiveSystemPushMessage = flag;
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}

- (NSString *)activeUser
{
    __block NSString *result = nil;
    
    dispatch_block_t block = ^{
        
        result = [activeUser copy];
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_sync(moduleQueue, block);
    
    return result;
}

- (void)setActiveUser:(NSString *)userBareJidStr
{
    dispatch_block_t block = ^{
        activeUser = [userBareJidStr copy];
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}


- (NSXMLElement *)preferences
{
    __block NSXMLElement *result = nil;
    
    dispatch_block_t block = ^{
        
        result = [preferences copy];
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_sync(moduleQueue, block);
    
    return result;
}

- (void)setPreferences:(NSXMLElement *)newPreferences
{
    dispatch_block_t block = ^{ @autoreleasepool {
        
        // Update cached value
        
        preferences = [newPreferences copy];
        
        // Update storage
        
        if ([xmppMessageStorage respondsToSelector:@selector(setPreferences:forUser:)])
        {
            XMPPJID *myBareJid = [[xmppStream myJID] bareJID];
            //???:Here
            //[xmppMessageStorage setPreferences:preferences forUser:myBareJid];
        }
        
        // 
        // 
        //  - Send new pref to server (if changed)
    }};
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - comment method
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addActiveUser:(NSString *)userBareJidStr Delegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    // Asynchronous operation (if outside xmppQueue)
    
    dispatch_block_t block = ^{
        [multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
        [self setActiveUser:userBareJidStr];
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}

- (void)removeActiveUserAndDelegate:(id)delegate
{
    [self setActiveUser:nil];
    [self removeDelegate:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark operate the message
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveMessageActionWithXMPPStream:(XMPPStream *)sender message:(XMPPMessage *)message sendFromMe:(BOOL)sendFromMe
{
    if (!dispatch_get_specific(moduleQueueTag)) return;
    
    if ([message isChatMessageWithBody]) {
        //save the message
        [xmppMessageStorage archiveMessage:message sendFromMe:sendFromMe activeUser:[self activeUser] xmppStream:sender];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPLogTrace();
    
    if (clientSideMessageArchivingOnly) return;
    
    // Fetch most recent preferences
    
    if ([xmppMessageStorage respondsToSelector:@selector(preferencesForUser:)])
    {
        XMPPJID *myBareJid = [[xmppStream myJID] bareJID];
        
        //preferences = [xmppMessageStorage preferencesForUser:myBareJid];
    }
    
    // Request archiving preferences from server
    //
    // <iq type='get'>
    //   <pref xmlns='urn:xmpp:archive'/>
    // </iq>
    
    NSXMLElement *pref = [NSXMLElement elementWithName:@"pref" xmlns:XMLNS_XMPP_ARCHIVE];
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:nil elementID:nil child:pref];
    
    [sender sendElement:iq];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    //operate the IQ here
    //Your coding ...
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    XMPPLogTrace();
    // Asynchronous operation (if outside xmppQueue)
    
    dispatch_block_t block = ^{
        
        if ([message isChatMessage]) {
            //save the message
            [self saveMessageActionWithXMPPStream:sender message:message sendFromMe:YES];
        }

    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    XMPPLogTrace();
    
    dispatch_block_t block = ^{
        
        if ([message isChatMessage]) {
            //save the message
            [self saveMessageActionWithXMPPStream:sender message:message sendFromMe:NO];
            [multicastDelegate xmppAllMessage:self receiveMessage:message];
        }
    };
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
}

@end
