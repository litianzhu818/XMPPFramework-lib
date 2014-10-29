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
/**
 *  Init with the storage
 *
 *  @param storage The storage
 *
 *  @return The new created object
 */
- (id)initWithMessageStorage:(id <XMPPAllMessageStorage>)storage;
/**
 *  Init with the storage and the queue
 *
 *  @param storage The storage
 *  @param queue   The action queue
 *
 *  @return The Created object
 */
- (id)initWithMessageStorage:(id <XMPPAllMessageStorage>)storage dispatchQueue:(dispatch_queue_t)queue;
/**
 *  ADD the active chat user Who is chatting with
 *
 *  @param userBareJidStr The active user base jid string
 *  @param delegate       The delegate
 *  @param delegateQueue  The dekegate queue
 */
- (void)addActiveUser:(NSString *)userBareJidStr Delegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
/**
 *  remove the active user when we close the chat with the active user
 *
 *  @param delegate The delegate
 */
- (void)removeActiveUserAndDelegate:(id)delegate;
/**
 *  Clear the Given user's chat history
 *
 *  @param userJid user JID
 */
- (void)clearChatHistoryWithUserJid:(XMPPJID *)userJid;
/**
 *  read all the unread message,aftering this action,this user will has no unread message
 *
 *  @param userJid user bare jid string
 */
- (void)readAllUnreadMessageWithUserJid:(XMPPJID *)userJid;
/**
 *  read a message with its messageID
 *
 *  @param messageID The given messageID
 */
- (void)readMessageWithMessageID:(NSString *)messageID;

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
- (void)readMessageWithMessageID:(NSString *)messageID xmppStream:(XMPPStream *)xmppStream;

@optional

-(void)testmethod;

@end


//XMPPChatMessageDelegate
@protocol XMPPAllMessageDelegate <NSObject>

@required

@optional
- (void)xmppAllMessage:(XMPPAllMessage *)xmppAllMessage receiveMessage:(XMPPMessage *)message;

@end

