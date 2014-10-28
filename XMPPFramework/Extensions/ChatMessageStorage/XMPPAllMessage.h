//
//  XMPPChatMessage.h
//  XMPP_Project
//
//  Created by Peter Lee on 14/9/29.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <XMPPFramework/XMPPFramework.h>

typedef NS_ENUM(NSUInteger, XMPPMessageType){
    XMPPMessageDefaultType = 0,
    XMPPMessageUserRequestType,
    XMPPMessageSystemPushType
};

@protocol XMPPAllMessageStorage;
@protocol XMPPChatMessageDelegate;


@interface XMPPAllMessage : XMPPModule
{
@protected
    
    __strong id <XMPPAllMessageStorage> xmppMessageStorage;
    NSString *activeUser;
    
@private
    
    BOOL clientSideMessageArchivingOnly;
    BOOL receiveUserRequestMessage;
    BOOL receiveSystemPushMessage;
    NSXMLElement *preferences;
}

- (id)initWithMessageStorage:(id <XMPPAllMessageStorage>)storage;
- (id)initWithMessageStorage:(id <XMPPAllMessageStorage>)storage dispatchQueue:(dispatch_queue_t)queue;

- (void)addActiveUser:(NSString *)userBareJidStr Delegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeActiveUserAndDelegate:(id)delegate;

- (void)clearChatHistoryWithUserJid:(XMPPJID *)userJid;
- (void)readAllUnreadMessageWithUserJid:(XMPPJID *)userJid;

@property (readonly, strong) id <XMPPAllMessageStorage> xmppMessageStorage;

@property (readwrite, assign) BOOL clientSideMessageArchivingOnly;
@property (readwrite, assign) BOOL receiveUserRequestMessage;
@property (readwrite, assign) BOOL receiveSystemPushMessage;

@property (nonatomic, strong) NSString *activeUser;

@property (readwrite, copy) NSXMLElement *preferences;

@end


//XMPPChatMessageStorage
@protocol XMPPAllMessageStorage <NSObject>

@required

- (BOOL)configureWithParent:(XMPPAllMessage *)aParent queue:(dispatch_queue_t)queue;
- (void)archiveMessage:(XMPPMessage *)message sendFromMe:(BOOL)sendFromMe activeUser:(NSString *)activeUser xmppStream:(XMPPStream *)stream;
- (void)readAllUnreadMessageWithBareUserJid:(NSString *)bareUserJid xmppStream:(XMPPStream *)xmppStream;
- (void)clearChatHistoryWithBareUserJid:(NSString *)bareUserJid xmppStream:(XMPPStream *)xmppStream;

@optional

-(void)testmethod;

@end


//XMPPChatMessageDelegate
@protocol XMPPAllMessageDelegate <NSObject>

@required

@optional
- (void)xmppAllMessage:(XMPPAllMessage *)xmppAllMessage receiveMessage:(XMPPMessage *)message;

@end

