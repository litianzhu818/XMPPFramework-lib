//
//  XMPPChatRoomCoreDataStorageObject.m
//  XMPP_Project
//
//  Created by Peter Lee on 14/9/25.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "XMPPChatRoomCoreDataStorageObject.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


@interface XMPPChatRoomCoreDataStorageObject ()

@property(nonatomic,strong) NSString *primitiveId;
@property(nonatomic,strong) NSString *primitiveNickName;
@property(nonatomic,strong) NSString *primitiveSubscription;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation XMPPChatRoomCoreDataStorageObject

@dynamic jid, primitiveId;
@dynamic nickName, primitiveNickName;
@dynamic photo;
@dynamic streamBareJidStr;
@dynamic subscription, primitiveSubscription;
@dynamic masterBareJidStr;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - primitive Parameters
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)primitiveId
{
    return jid;
}
- (void)setPrimitiveId:(NSString *)primitiveId
{
    jid = primitiveId;
}

- (NSString *)primitiveNickName
{
    return nickName;
}

- (void)setPrimitiveNickName:(NSString *)primitiveNickName
{
    nickName = primitiveNickName;
}

- (NSString *)primitiveSubscription
{
    return subscription;
}

- (void)setPrimitiveSubscription:(NSString *)primitiveSubscription
{
    subscription = primitiveSubscription;
}

- (NSString *)masterBareJidStr
{
    [self willAccessValueForKey:@"masterBareJidStr"];
    NSString *value = [self primitiveValueForKey:@"masterBareJidStr"];
    [self didAccessValueForKey:@"masterBareJidStr"];
    return value;
}
            
- (void)setMasterBareJidStr:(NSString *)value
{
    [self willChangeValueForKey:@"masterBareJidStr"];
    [self setPrimitiveValue:value forKey:@"masterBareJidStr"];
    [self didChangeValueForKey:@"masterBareJidStr"];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - public Parameters
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//MARK:在这里这个jid不依赖其他成员参数，可以不用这个getter方法
- (NSString *)jid
{
    // Create and cache the jid on demand
    
    [self willAccessValueForKey:@"jid"];
    NSString *tmp = [self primitiveId];
    [self didAccessValueForKey:@"jid"];
    
    //!!!!:notice here
    //MARK:这里如果有关联需要注意关联，否则可以不要该步
    //假如jid是根据jidStr而生成的，那么这里可以
    //if (tmp == nil) {
    //    tmp = [XMPPJID jidWithString:[self jidStr]];
    //   [self setPrimitiveId:tmp];
    //}
    return tmp;
}

- (void)setJid:(NSString *)Jid
{
    [self willChangeValueForKey:@"jid"];
    [self setPrimitiveId:Jid];
    [self didChangeValueForKey:@"jid"];
    
    // If the jidStr changes, the jid becomes invalid.A
    //MARK:这里需要注意， 关联的其它值，例如A是根据jid操作而来的，
    //那么应该[self setPrimitiveA:nil];
    //[self setPrimitiveId:nil];
}
- (void)setNickeName:(NSString *)NickeName
{
    [self willChangeValueForKey:@"nickName"];
    [self setPrimitiveNickName:NickeName];
    [self didChangeValueForKey:@"nickName"];
    
    // If the jidStr changes, the jid becomes invalid.
    //[self setPrimitiveNickName:nil];
}

-(NSString *)nickeName
{
    // Create and cache the section on demand
    [self willAccessValueForKey:@"nickeName"];
    NSString *tmp = [self primitiveNickName];
    [self didAccessValueForKey:@"nickeName"];
    
    // section uses zero, so to distinguish unset values, use NSNotFound
    if (tmp == nil) {
        [self setPrimitiveNickName:tmp];
    }
    return tmp;
}

- (NSString *)subscription
{
    // Create and cache the section on demand
    [self willAccessValueForKey:@"subscription"];
    NSString *tmp = [self primitiveSubscription];
    [self didAccessValueForKey:@"subscription"];
    
    // section uses zero, so to distinguish unset values, use NSNotFound
    if (tmp == nil) {
        [self setPrimitiveSubscription:tmp];
    }
    return tmp;
}

- (void)setSubscription:(NSString *)Subscription
{
    [self willChangeValueForKey:@"subscription"];
    [self setPrimitiveSubscription:Subscription];
    [self didChangeValueForKey:@"subscription"];
    
    // If the jidStr changes, the jid becomes invalid.
    //[self setPrimitiveSubscription:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Creation & Updates
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc
                            withID:(NSString *)id
                  streamBareJidStr:(NSString *)streamBareJidStr
{
    if (id == nil){
        NSLog(@"XMPPChatRoomCoreDataStorageObject: invalid jid (nil)");
        return nil;
    }
    
    XMPPChatRoomCoreDataStorageObject *chatRoom;
    chatRoom = [NSEntityDescription insertNewObjectForEntityForName:@"XMPPChatRoomCoreDataStorageObject"
                                            inManagedObjectContext:moc];
    
    chatRoom.streamBareJidStr = streamBareJidStr;
    chatRoom.jid = id;
    chatRoom.nickName = nil;
    chatRoom.subscription = nil;
    chatRoom.photo = nil;
    chatRoom.masterBareJidStr = nil;
    
    return chatRoom;
}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc
                  withNSDictionary:(NSDictionary *)Dic
                  streamBareJidStr:(NSString *)streamBareJidStr
{
    NSString *jid = [Dic objectForKey:@"jid"];
    
    if (jid == nil){
        NSLog(@"XMPPChatRoomCoreDataStorageObject: invalid Dic (missing or invalid jid): %@", Dic.description);
        return nil;
    }
    
    XMPPChatRoomCoreDataStorageObject *chatRoom;
    chatRoom = [NSEntityDescription insertNewObjectForEntityForName:@"XMPPChatRoomCoreDataStorageObject"
                                             inManagedObjectContext:moc];
    
    chatRoom.streamBareJidStr = streamBareJidStr;
    
    [chatRoom updateWithDictionary:Dic];

    return chatRoom;

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Delete method
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (BOOL)deleteInManagedObjectContext:(NSManagedObjectContext *)moc
                  withNSDictionary:(NSDictionary *)Dic
                  streamBareJidStr:(NSString *)streamBareJidStr
{
    NSString *jid = [Dic objectForKey:@"jid"];
    return [self deleteInManagedObjectContext:moc
                                       withID:jid
                             streamBareJidStr:streamBareJidStr];
}

+ (BOOL)deleteInManagedObjectContext:(NSManagedObjectContext *)moc
                              withID:(NSString *)id
streamBareJidStr:(NSString *)streamBareJidStr
{
    if (id == nil) return NO;
    if (moc == nil) return NO;
    
    XMPPChatRoomCoreDataStorageObject *deleteObject = [XMPPChatRoomCoreDataStorageObject objectInManagedObjectContext:moc withID:id streamBareJidStr:streamBareJidStr];
    if (deleteObject){
        
        [moc deleteObject:deleteObject];
        return YES;
    }
    
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark  Update methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (BOOL)updateInManagedObjectContext:(NSManagedObjectContext *)moc
                    withNSDictionary:(NSDictionary *)Dic
                    streamBareJidStr:(NSString *)streamBareJidStr
{
    NSString *id = [Dic objectForKey:@"jid"];
    
    if (id == nil) return NO;
    if (moc == nil) return NO;
    
    NSError *error = nil;
    
    XMPPChatRoomCoreDataStorageObject *updateObject = [XMPPChatRoomCoreDataStorageObject objectInManagedObjectContext:moc
                                                                                                               withID:id
                                                                                                     streamBareJidStr:streamBareJidStr];
    //if we find the object we will update for,we update it with the new obejct
    if (updateObject){
        
        [updateObject updateWithDictionary:Dic];
        return YES;
    }
    return NO;
}


+ (BOOL)updateOrInsertObjectInManagedObjectContext:(NSManagedObjectContext *)moc
                                  withNSDictionary:(NSDictionary *)Dic
                                  streamBareJidStr:(NSString *)streamBareJidStr
{
    NSString *id = [Dic objectForKey:@"jid"];
    
    if (id == nil) return NO;
    if (moc == nil) return NO;
    
    NSError *error = nil;
    
    XMPPChatRoomCoreDataStorageObject *updateObject = [XMPPChatRoomCoreDataStorageObject objectInManagedObjectContext:moc
                                                                                                               withID:id
                                                                                                     streamBareJidStr:streamBareJidStr];
    //if the object we find alreadly in the coredata system ,we should update it
    if (updateObject){
        
        [updateObject updateWithDictionary:Dic];
        
        return YES;
        
    }else{//if not find the object in the CoreData system ,we should insert the new object to it
        //FIXME:There is a bug meybe here
        updateObject = [XMPPChatRoomCoreDataStorageObject insertInManagedObjectContext:moc
                                                                      withNSDictionary:Dic
                                                                      streamBareJidStr:streamBareJidStr];
        //[moc insertObject:updateObject];
        return YES;
    }
    
    return NO;
}


- (void)updateWithDictionary:(NSDictionary *)Dic
{
    NSString *jidStr = [Dic objectForKey:@"jid"];
    NSString *nickNameStr = [Dic objectForKey:@"nickname"];
    NSString *subscriptionStr = [Dic objectForKey:@"subscription"];
    NSString *masterBareJidStr = [Dic objectForKey:@"masterBareJidStr"];
    if (jidStr == nil){
        NSLog(@"XMPPUserCoreDataStorageObject: invalid Dic (missing or invalid jid): %@", Dic.description);
        return;
    }
    
    self.jid = jidStr;
    self.nickName = nickNameStr;
    self.subscription = subscriptionStr;
    self.masterBareJidStr = masterBareJidStr;
    //TODO:这里需要处理photo属性
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Check methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)fetchObjectInManagedObjectContext:(NSManagedObjectContext *)moc
                                 withID:(NSString *)id
                       streamBareJidStr:(NSString *)streamBareJidStr
{
    return [XMPPChatRoomCoreDataStorageObject objectInManagedObjectContext:moc
                                                                    withID:id
                                                          streamBareJidStr:streamBareJidStr];
}


+ (XMPPChatRoomCoreDataStorageObject *)objectInManagedObjectContext:(NSManagedObjectContext *)moc
                                                       withID:(NSString *)id
                                             streamBareJidStr:(NSString *)streamBareJidStr
{
    if (id == nil) return nil;
    if (moc == nil) return nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPChatRoomCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    
    NSPredicate *predicate;
    if (streamBareJidStr == nil)
        predicate = [NSPredicate predicateWithFormat:@"jid == %@", id];
    else
        predicate = [NSPredicate predicateWithFormat:@"jid == %@ AND streamBareJidStr == %@",
                     id, streamBareJidStr];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setIncludesPendingChanges:YES];
    [fetchRequest setFetchLimit:1];
    
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    
    return (XMPPChatRoomCoreDataStorageObject *)[results lastObject];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Comparisons
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Returns the result of invoking compareByName:options: with no options.
 **/
- (NSComparisonResult)compareByName:(XMPPChatRoomCoreDataStorageObject *)another
{
    return [self compareByName:another options:0];
}

/**
 * This method compares the two users according to their display name.
 *
 * Options for the search — you can combine any of the following using a C bitwise OR operator:
 * NSCaseInsensitiveSearch, NSLiteralSearch, NSNumericSearch.
 * See "String Programming Guide for Cocoa" for details on these options.
 **/
- (NSComparisonResult)compareByName:(XMPPChatRoomCoreDataStorageObject *)another options:(NSStringCompareOptions)mask
{
    NSString *myName = [self nickName];
    NSString *theirName = [another nickName];
    
    return [myName compare:theirName options:mask];
}

/**
 * Returns the result of invoking compareByAvailabilityName:options: with no options.
 **/
- (NSComparisonResult)compareByID:(XMPPChatRoomCoreDataStorageObject *)another
{
    return [self compareByID:another options:0];
}

/**
 * This method compares the two users according to availability first, and then display name.
 * Thus available users come before unavailable users.
 * If both users are available, or both users are not available,
 * this method follows the same functionality as the compareByName:options: as documented above.
 **/
- (NSComparisonResult)compareByID:(XMPPChatRoomCoreDataStorageObject *)another
                                        options:(NSStringCompareOptions)mask
{
    NSString *myID = [self jid];
    NSString *theirID = [another jid];
    
    return [myID compare:theirID options:mask];}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark KVO compliance methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//+ (NSSet *)keyPathsForValuesAffectingJid {
//    // If the jidStr changes, the jid may change as well.
//    return [NSSet setWithObject:@"jidStr"];
//}
//
//+ (NSSet *)keyPathsForValuesAffectingIsOnline {
//    return [NSSet setWithObject:@"primaryResource"];
//}
//
//+ (NSSet *)keyPathsForValuesAffectingSection {
//    // If the value of sectionNum changes, the section may change as well.
//    return [NSSet setWithObject:@"sectionNum"];
//}
//
//+ (NSSet *)keyPathsForValuesAffectingSectionName {
//    // If the value of displayName changes, the sectionName may change as well.
//    return [NSSet setWithObject:@"displayName"];
//}
//
//+ (NSSet *)keyPathsForValuesAffectingAllResources {
//    return [NSSet setWithObject:@"resources"];
//}

@end
