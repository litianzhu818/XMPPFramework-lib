//
//  XMPPChatMessage.m
//  XMPP_Project
//
//  Created by Peter Lee on 14/10/8.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "XMPPChatMessageObject.h"

@implementation XMPPChatMessageObject

#pragma mark -
#pragma mark - Public Methods
-(instancetype)initWithXMPPMessage:(XMPPMessage *)message
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self fromDictionary:dictionary];
    }
    return self;
}

-(instancetype)initWithXMPPMessageCoreDataStorageObject:(XMPPMessageCoreDataStorageObject *)xmppMessageCoreDataStorageObject
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)createMessageID
{
    self.messageID = [self UUIDString];
}

/**
 *  Get the unique string in system
 *
 *  @return The unique string we want
 */
-(NSString *)UUIDString
{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    
    CFRelease(uuidRef);
    
    return (__bridge NSString *)uuidStringRef;
}


-(NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.messageID)
        [dictionary setObject:self.messageID forKey:@"messageID"];
    if (self.fromUser)
        [dictionary setObject:self.fromUser forKey:@"fromUser"];
    if (self.toUser)
        [dictionary setObject:self.toUser forKey:@"toUser"];
    if (self.messageTime)
        [dictionary setObject:self.messageTime forKey:@"messageTime"];
    if (self.xmppSimpleMessageObject)
        [dictionary setObject:self.xmppSimpleMessageObject forKey:@"xmppSimpleMessageObject"];
    
    [dictionary setObject:[NSNumber numberWithBool:self.hasBeenRead] forKey:@"hasBeenRead"];
    [dictionary setObject:[NSNumber numberWithBool:self.isPrivate] forKey:@"isPrivate"];
    [dictionary setObject:[NSNumber numberWithBool:self.isChatRoomMessage] forKey:@"isChatRoomMessage"];
    
    return dictionary;
}

-(void)fromDictionary:(NSMutableDictionary*)message
{
    self.messageID = [message objectForKey:@"messageID"];
    self.fromUser = [message objectForKey:@"fromUser"];
    self.toUser = [message objectForKey:@"toUser"];
    self.messageTime = [message objectForKey:@"sendTime"];
    
    self.xmppSimpleMessageObject = [[XMPPSimpleMessageObject alloc] initWithDictionary:[message objectForKey:@"xmppSimpleMessageObject"] ];
    self.hasBeenRead = [(NSNumber *)[message objectForKey:@"hasBeenRead"] boolValue];
    self.isPrivate = [(NSNumber *)[message objectForKey:@"isPrivate"] boolValue];
    self.isChatRoomMessage = [(NSNumber *)[message objectForKey:@"isChatRoomMessage"] boolValue];
}
#pragma mark -
#pragma mark - Private Methods
-(void)setUpWithXMPPMessageCoreDataStorageObject:(XMPPMessageCoreDataStorageObject *)xmppMessageCoreDataStorageObject
{
    self.messageID = xmppMessageCoreDataStorageObject.messageID;
    self.messageTime = xmppMessageCoreDataStorageObject.messageTime;
    self.sendFromMe = xmppMessageCoreDataStorageObject.sendFromMe;
    self.xmppSimpleMessageObject = xmppMessageCoreDataStorageObject.messageBody;
    self.fromUser = self.sendFromMe ? xmppMessageCoreDataStorageObject.streamBareJidStr:xmppMessageCoreDataStorageObject.bareJidStr;
    self.toUser = self.sendFromMe ? xmppMessageCoreDataStorageObject.bareJidStr:xmppMessageCoreDataStorageObject.streamBareJidStr;
    self.isPrivate = xmppMessageCoreDataStorageObject.isPrivate > 0;
    self.isChatRoomMessage = xmppMessageCoreDataStorageObject.isChatRoomMessage > 0;
    self.hasBeenRead = xmppMessageCoreDataStorageObject.hasBeenRead;
}
#pragma mark -
#pragma mark - NSCopying Methods

#pragma mark -
#pragma mark - NSCoding Methods

@end
