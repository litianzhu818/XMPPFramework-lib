//
//  XMPPUnReadMessageCoreDataStorageObject.h
//  XMPP_Project
//
//  Created by Peter Lee on 14/10/21.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface XMPPUnReadMessageCoreDataStorageObject : NSManagedObject

@property (nonatomic, retain) NSString * bareJidStr;
@property (nonatomic, retain) NSString * streamBareJidStr;
@property (nonatomic, retain) NSNumber * unReadCount;

+ (id)obejctInManagedObjectContext:(NSManagedObjectContext *)moc
                    withUserJIDStr:(NSString *)jidStr
                  streamBareJidStr:(NSString *)streamBareJidStr;

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc
                    withUserJIDstr:(NSString *)jidStr
                unReadMessageCount:(NSUInteger)unReatCount
                  streamBareJidStr:(NSString *)streamBareJidStr;

+ (BOOL)updateOrInsertObjectInManagedObjectContext:(NSManagedObjectContext *)moc
                                    withUserJIDstr:(NSString *)jidStr
                                unReadMessageCount:(NSUInteger)unReadCount
                                  streamBareJidStr:(NSString *)streamBareJidStr;
@end
