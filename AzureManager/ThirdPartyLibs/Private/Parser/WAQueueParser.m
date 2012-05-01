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

#import "WAQueueParser.h"
#import "WAXMLHelper.h"
#import "WAQueue.h"

@implementation WAQueueParser

+ (NSArray *)loadQueues:(xmlDocPtr)doc 
{
    if (doc == nil) { 
		return nil; 
	}
	
    NSMutableArray *queues = [NSMutableArray arrayWithCapacity:30];
    
    [WAXMLHelper performXPath:@"/EnumerationResults/Queues/Queue" 
                 onDocument:doc 
                      block:^(xmlNodePtr node) {
        NSString *name = [WAXMLHelper getElementValue:node name:@"Name"];
        NSString *url = [WAXMLHelper getElementValue:node name:@"Url"];
         
        WAQueue *queue = [[WAQueue alloc] initQueueWithName:name URL:url];
        [queues addObject:queue];
    }];
    
    return [queues copy];
}

@end
