/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "WAQueueMessageParser.h"
#import "WAQueueMessage.h"
#import "WAXMLHelper.h"

@implementation WAQueueMessageParser

+ (NSArray *)loadQueueMessages:(xmlDocPtr)doc {
    
    if (doc == nil) 
    { 
		return nil; 
	}
	
    NSMutableArray *queueMessages = [NSMutableArray arrayWithCapacity:30];
    
    [WAXMLHelper performXPath:@"/QueueMessagesList/QueueMessage" 
                 onDocument:doc 
                      block:^(xmlNodePtr node) {
        NSString *messageId = [WAXMLHelper getElementValue:node name:@"MessageId"];
        NSString *insertionTime = [WAXMLHelper getElementValue:node name:@"InsertionTime"];
        NSString *expirationTime = [WAXMLHelper getElementValue:node name:@"ExpirationTime"];
        NSString *popReceipt = [WAXMLHelper getElementValue:node name:@"PopReceipt"];
        NSString *timeNextVisible = [WAXMLHelper getElementValue:node name:@"TimeNextVisible"];
        NSString *messageText = [WAXMLHelper getElementValue:node name:@"MessageText"];
        NSString *dequeuCount = [WAXMLHelper getElementValue:node name:@"DequeueCount"];
         
        WAQueueMessage *queueMessage = [[WAQueueMessage alloc] initQueueMessageWithMessageId:messageId insertionTime:insertionTime expirationTime:expirationTime popReceipt:popReceipt timeNextVisible:timeNextVisible messageText:messageText dequeueCount:[dequeuCount integerValue]];
        [queueMessages addObject:queueMessage];
    }];
    
    return [queueMessages copy];
}

@end
