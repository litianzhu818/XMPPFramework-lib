//
//  XMPPMessage+AdditionMessage.m
//  XMPP_Project
//
//  Created by Peter Lee on 14/10/27.
//  Copyright (c) 2014年 Peter Lee. All rights reserved.
//

#import "XMPPMessage+AdditionMessage.h"

@implementation XMPPMessage (AdditionMessage)

-(NSMutableDictionary *)toDictionary
{
    NSXMLElement *body = [self elementForName:@"body"];
    if (!body)  return nil;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    
    
    return dictionary;
}

@end
