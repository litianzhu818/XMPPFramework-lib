//
//  SimpleMessage.h
//  XMPP_Project
//
//  Created by Peter Lee on 14/10/8.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPPSimpleMessageObject : NSObject<NSCopying,NSCoding>

@property (assign, nonatomic) NSUInteger  messageType;      //The message type

//Text message
@property (strong, nonatomic) NSString    *messageText;     //The text type message's text body

//Photo,voice,video,file message
@property (strong, nonatomic) NSString    *filePath;        //The file patch in the message
@property (strong, nonatomic) NSString    *fileName;        //The name of the file in message
@property (strong, nonatomic) NSData      *fileData;        //The data of the file in the message
@property (assign, nonatomic) NSTimeInterval timeLength;    //The time length of the Voice or Video file

@property (assign, nonatomic) BOOL        messageTag;       //A Mark value

//This parameter value only can been used when set the parameter "isChatRoomMessage = YES"
@property (strong, nonatomic) NSString    *chatRoomUserJid;  //The jid string of the user in the Chat room message，we can know who send this chat room message during a room chatting

//位置消息
@property (strong, nonatomic) NSString    *longitude;       //longitude
@property (strong, nonatomic) NSString    *latitude;        //latitude

@property (assign, nonatomic) CGFloat     aspectRatio;      //image width/height

-(instancetype)initWithDictionary:(NSMutableDictionary *)dictionary;
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
