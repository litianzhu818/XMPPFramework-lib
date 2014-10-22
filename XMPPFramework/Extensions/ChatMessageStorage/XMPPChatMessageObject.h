//
//  XMPPChatMessage.h
//  XMPP_Project
//
//  Created by Peter Lee on 14/10/8.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessage.h"
#import "XMPPSimpleMessageObject.h"
#import "XMPPMessageCoreDataStorageObject.h"

typedef NS_ENUM(NSUInteger, XMPPChatMessageType){
    XMPPChatMessageTextType = 0,
    XMPPChatMessageVoiceType,
    XMPPChatMessageVideoType,
    XMPPChatMessageImageType,
    XMPPChatMessagePositionType,
    XMPPChatMessageControlType,
    XMPPChatMessageMediaRequestType
};


@interface XMPPChatMessageObject : NSObject<NSCopying,NSCoding>

@property (strong, nonatomic) NSString                          *messageID;       //message ID,used to find the appointed message
@property (strong, nonatomic) NSString                          *fromUser;        //The user id of Who send the message
@property (strong, nonatomic) NSString                          *toUser;          //The user id of who the message will been send to
@property (strong, nonatomic) NSData                            *messageTime;        //The message send time
@property (assign, nonatomic) BOOL                              isPrivate;        //The mark to  distinguish the message whether is a private message
@property (assign, nonatomic) BOOL                              hasBeenRead;      //The mark to  distinguish whether the message has been read
@property (assign, nonatomic) BOOL                              isChatRoomMessage; //Mark value 4,Wether is a chat room chat
@property (assign, nonatomic) BOOL                              sendFromMe;       //Whether the message is send from myself
@property (strong, nonatomic) XMPPSimpleMessageObject           *xmppSimpleMessageObject;
/**z
 *  Init method
 *
 *  @param dictionary The information dictionary
 *
 *  @return The message object
 */
-(instancetype)initWithDictionary:(NSMutableDictionary *)dictionary;
-(instancetype)initWithXMPPMessage:(XMPPMessage *)message;
-(instancetype)initWithXMPPMessageCoreDataStorageObject:(XMPPMessageCoreDataStorageObject *)xmppMessageCoreDataStorageObject;
/**
 *  Create the message id,we must do this before send this message
 */
-(void)createMessageID;
/**
 *  Transform the Message object into a Dictionary Object
 *
 *  @return A message dictionary
 */
-(NSMutableDictionary *)toDictionary;
/**
 *  Get the message object from the Dictionary which contains the whole info of the message
 *
 *  @param message The message object
 */
-(void)fromDictionary:(NSMutableDictionary*)message;

@end
