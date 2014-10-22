//
//  SimpleMessage.m
//  XMPP_Project
//
//  Created by Peter Lee on 14/10/8.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "XMPPSimpleMessageObject.h"

@implementation XMPPSimpleMessageObject

-(instancetype)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self fromDictionary:dictionary];
    }
    return self;
}

-(NSMutableDictionary *)toDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.messageText)
        [dictionary setObject:self.messageText forKey:@"messageText"];
    
    if (self.filePath)
        [dictionary setObject:self.filePath forKey:@"filePath"];
    
    if (self.longitude)
        [dictionary setObject:self.longitude forKey:@"longitude"];
    if (self.latitude)
        [dictionary setObject:self.latitude forKey:@"latitude"];
    if (self.fileName)
        [dictionary setObject:self.fileName forKey:@"fileName"];
    if (self.fileData)
        [dictionary setObject:[self.fileData base64Encoding] forKey:@"fileData"];
    if (self.chatRoomUserJid)
        [dictionary setObject:self.chatRoomUserJid forKey:@"chatRoomUserJid"];
    
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.messageType] forKey:@"messageType"];
    [dictionary setObject:[NSNumber numberWithDouble:self.timeLength] forKey:@"timeLength"];
    [dictionary setObject:[NSNumber numberWithFloat:self.aspectRatio] forKey:@"aspectRatio"];
    [dictionary setObject:[NSNumber numberWithBool:self.messageTag] forKey:@"messageTag"];
    
    return dictionary;
}

-(void)fromDictionary:(NSMutableDictionary *)message
{
    self.messageText = [message objectForKey:@"messageText"];
    self.filePath = [message objectForKey:@"filePath"];
    self.messageType = [(NSNumber *)[message objectForKey:@"messageType"] unsignedIntegerValue];
    self.timeLength = [(NSNumber *)[message objectForKey:@"timeLength"] doubleValue];
    self.longitude = [message objectForKey:@"longitude"];
    self.latitude = [message objectForKey:@"latitude"];
    self.fileName = [message objectForKey:@"fileName"];
    self.chatRoomUserJid = [message objectForKey:@"chatRoomUserJid"];
#warning initWithBase64Encoding only used in the system version more than 7.0
    if ([message objectForKey:@"fileData"])
        self.fileData = [[NSData alloc] initWithBase64Encoding:[message objectForKey:@"fileData"]];
    
    self.aspectRatio = [(NSNumber *)[message objectForKey:@"aspectRatio"] floatValue];
    self.messageTag = [(NSNumber *)[message objectForKey:@"messageTag"] boolValue];
}


@end
