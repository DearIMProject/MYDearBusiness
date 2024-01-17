//
//  MYMessage+MYConvert.m
//  DearIMProject
//
//  Created by APPLE on 2023/11/23.
//

#import "MYMessage+MYConvert.h"

@implementation MYMessage (MYConvert)

+ (MYMessage *)convertFromMessage:(MYDataMessage *)dbMessage {
    MYMessage *aMessage = [[MYMessage alloc] init];
    aMessage.msgId = dbMessage.msgId;
    aMessage.fromId = dbMessage.fromId;
    aMessage.fromEntity = dbMessage.fromEntity;
    aMessage.toId = dbMessage.toId;
    aMessage.toEntity = dbMessage.toEntity;
    aMessage.content = dbMessage.content;
    aMessage.messageType = dbMessage.messageType;
    aMessage.timestamp = dbMessage.timestamp;
    aMessage.sendStatus = dbMessage.sendStatus;
    aMessage.readList = [dbMessage.readList componentsSeparatedByString:@","];
    return aMessage;
}

+ (MYDataMessage *)dbConvertFromMessage:(MYMessage *)message {
    MYDataMessage *dbMessage = [[MYDataMessage alloc] init];
    dbMessage.msgId = message.msgId;
    dbMessage.fromId = message.fromId;
    dbMessage.fromEntity = message.fromEntity;
    dbMessage.toId = message.toId;
    dbMessage.toEntity = message.toEntity;
    dbMessage.content = message.content;
    dbMessage.messageType = message.messageType;
    dbMessage.timestamp = message.timestamp;
    dbMessage.sendStatus = message.sendStatus;
    return dbMessage;
}

@end
