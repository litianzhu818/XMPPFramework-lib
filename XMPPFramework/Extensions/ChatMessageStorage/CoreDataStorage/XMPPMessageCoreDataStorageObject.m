//
//  XMPPMessageCoreDataStorageObject.m
//  XMPP_Project
//
//  Created by Peter Lee on 14/10/10.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "XMPPMessageCoreDataStorageObject.h"


@implementation XMPPMessageCoreDataStorageObject

@dynamic bareJidStr;
@dynamic hasBeenRead;
@dynamic isChatRoomMessage;
@dynamic isPrivate;
@dynamic messageID;
@dynamic messageBody;
@dynamic messageTime;
@dynamic sendFromMe;
@dynamic streamBareJidStr;
//This the getter and setters
#pragma mark -
#pragma mark - Getters/Setters methods
- (NSString *)bareJidStr
{
    [self willAccessValueForKey:@"bareJidStr"];
    NSString *value = [self primitiveValueForKey:@"bareJidStr"];
    [self didAccessValueForKey:@"bareJidStr"];
    return value;
}
            
- (void)setBareJidStr:(NSString *)value
{
    [self willChangeValueForKey:@"bareJidStr"];
    [self setPrimitiveValue:value forKey:@"bareJidStr"];
    [self didChangeValueForKey:@"bareJidStr"];
}

- (NSNumber *)hasBeenRead
{
    [self willAccessValueForKey:@"hasBeenRead"];
    NSNumber *value = [self primitiveValueForKey:@"hasBeenRead"];
    [self didAccessValueForKey:@"hasBeenRead"];
    return value;
}

- (void)setHasBeenRead:(NSNumber *)value
{
    [self willChangeValueForKey:@"hasBeenRead"];
    [self setPrimitiveValue:value forKey:@"hasBeenRead"];
    [self didChangeValueForKey:@"hasBeenRead"];
}
- (NSNumber *)isChatRoomMessage
{
    [self willAccessValueForKey:@"isChatRoomMessage"];
    NSNumber *value = [self primitiveValueForKey:@"isChatRoomMessage"];
    [self didAccessValueForKey:@"isChatRoomMessage"];
    return value;
}

- (void)setIsChatRoomMessage:(NSNumber *)value
{
    [self willChangeValueForKey:@"isChatRoomMessage"];
    [self setPrimitiveValue:value forKey:@"isChatRoomMessage"];
    [self didChangeValueForKey:@"isChatRoomMessage"];
}
- (NSNumber *)isPrivate
{
    [self willAccessValueForKey:@"isPrivate"];
    NSNumber *value = [self primitiveValueForKey:@"isPrivate"];
    [self didAccessValueForKey:@"isPrivate"];
    return value;
}

- (void)setIsPrivate:(NSNumber *)value
{
    [self willChangeValueForKey:@"isPrivate"];
    [self setPrimitiveValue:value forKey:@"isPrivate"];
    [self didChangeValueForKey:@"isPrivate"];
}
- (XMPPSimpleMessageObject *)messageBody
{
    [self willAccessValueForKey:@"messageBody"];
    XMPPSimpleMessageObject *value = [self primitiveValueForKey:@"messageBody"];
    [self didAccessValueForKey:@"messageBody"];
    return value;
}

- (void)setMessageBody:(XMPPSimpleMessageObject *)value
{
    [self willChangeValueForKey:@"messageBody"];
    [self setPrimitiveValue:value forKey:@"messageBody"];
    [self didChangeValueForKey:@"messageBody"];
}
- (NSNumber *)sendFromMe
{
    [self willAccessValueForKey:@"sendFromMe"];
    NSNumber *value = [self primitiveValueForKey:@"sendFromMe"];
    [self didAccessValueForKey:@"sendFromMe"];
    return value;
}

- (void)setSendFromMe:(NSNumber *)value
{
    [self willChangeValueForKey:@"sendFromMe"];
    [self setPrimitiveValue:value forKey:@"sendFromMe"];
    [self didChangeValueForKey:@"sendFromMe"];
}

- (NSDate *)messageTime
{
    [self willAccessValueForKey:@"messageTime"];
    NSDate *value = [self primitiveValueForKey:@"messageTime"];
    [self didAccessValueForKey:@"messageTime"];
    return value;
}

- (void)setMessageTime:(NSDate *)value
{
    [self willChangeValueForKey:@"messageTime"];
    [self setPrimitiveValue:value forKey:@"messageTime"];
    [self didChangeValueForKey:@"messageTime"];
}

- (NSString *)streamBareJidStr
{
    [self willAccessValueForKey:@"streamBareJidStr"];
    NSString *value = [self primitiveValueForKey:@"streamBareJidStr"];
    [self didAccessValueForKey:@"streamBareJidStr"];
    return value;
}

- (void)setStreamBareJidStr:(NSString *)value
{
    [self willChangeValueForKey:@"streamBareJidStr"];
    [self setPrimitiveValue:value forKey:@"streamBareJidStr"];
    [self didChangeValueForKey:@"streamBareJidStr"];
}

- (NSString *)messageID
{
    [self willAccessValueForKey:@"messageID"];
    NSString *value = [self primitiveValueForKey:@"messageID"];
    [self didAccessValueForKey:@"messageID"];
    return value;
}

- (void)setMessageID:(NSString *)value
{
    [self willChangeValueForKey:@"messageID"];
    [self setPrimitiveValue:value forKey:@"messageID"];
    [self didChangeValueForKey:@"messageID"];
}
#pragma mark -
#pragma mark - Public Methods
+ (id)obejctInManagedObjectContext:(NSManagedObjectContext *)moc
                     withMessageID:(NSString *)messageID
                  streamBareJidStr:(NSString *)streamBareJidStr
{
    if (messageID == nil) return nil;
    if (streamBareJidStr == nil) return nil;
    if (moc == nil) return nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageID == %@ AND streamBareJidStr == %@",
                              messageID, streamBareJidStr];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setIncludesPendingChanges:YES];
    [fetchRequest setFetchLimit:1];
    
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    
    return (XMPPMessageCoreDataStorageObject *)[results lastObject];
}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc
             withMessageDictionary:(NSDictionary *)messageDic
                  streamBareJidStr:(NSString *)streamBareJidStr
{
    NSString *messageID = [messageDic objectForKey:@"messageID"];
    if (messageID == nil) return nil;
    if (streamBareJidStr == nil) return nil;
    if (moc == nil) return nil;
    
    XMPPMessageCoreDataStorageObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"XMPPMessageCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    
    newObject.messageID = messageID;
    newObject.streamBareJidStr = streamBareJidStr;
    newObject.bareJidStr = [messageDic objectForKey:@"bareJidStr"];
    newObject.sendFromMe = [messageDic objectForKey:@"sendFromMe"];
    newObject.messageTime = [messageDic objectForKey:@"messageTime"];
    newObject.hasBeenRead = [messageDic objectForKey:@"hasBeenRead"];
    newObject.isChatRoomMessage = [messageDic objectForKey:@"isChatRoomMessage"];
    newObject.isPrivate = [messageDic objectForKey:@"isPrivate"];
    newObject.messageBody =
    
    return newObject;

}

+ (BOOL)updateOrInsertObjectInManagedObjectContext:(NSManagedObjectContext *)moc
                             withMessageDictionary:(NSDictionary *)messageDic
                                  streamBareJidStr:(NSString *)streamBareJidStr
{
    return nil;
}

#pragma mark -
#pragma mark - Private Methods

@end


