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

#import "WABlobParser.h"
#import "WABlob.h"
#import "WAXMLHelper.h"

@implementation WABlobParser

+ (NSArray *)loadBlobs:(xmlDocPtr)doc container:(WABlobContainer *)container
{
    if (doc == nil) { 
		return nil; 
	}
    
	NSMutableArray *blobs = [NSMutableArray arrayWithCapacity:30];
    
    [WAXMLHelper performXPath:@"/EnumerationResults/Blobs/Blob" 
                 onDocument:doc 
                      block:^(xmlNodePtr node) {
        NSString *name = [WAXMLHelper getElementValue:node name:@"Name"];
        NSString *url = [WAXMLHelper getElementValue:node name:@"Url"];
        __block NSString *blockType = nil;
        __block NSString *cacheControl = nil;
        __block NSString *contentEncoding = nil;
        __block NSString *contentLanguage = nil;
        __block NSString *contentLength = nil;
        __block NSString *contentMD5 = nil;
        __block NSString *contentType = nil;
        __block NSString *eTag = nil;
        __block NSString *lastModified = nil;
        __block NSString *leaseStatus = nil;
        __block NSString *sequenceNumber = nil;
         
        [WAXMLHelper performXPath:@"Properties" 
                            onNode:node 
                             block:^(xmlNodePtr node) {
            blockType = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyBlobType];
            cacheControl = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyCacheControl];
            contentEncoding = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentEncoding];
            contentLanguage = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentLanguage];
            contentLength = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentLength];
            contentMD5 = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentMD5];
            contentType = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentType];
            eTag = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyEtag]; 
            lastModified = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyLastModified];
            leaseStatus = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyLeaseStatus];
            sequenceNumber = [WAXMLHelper getElementValue:node name:WABlobPropertyKeySequenceNumber];
        }];
         
        WABlob *blob = [[WABlob alloc] initBlobWithName:name URL:url container:container 
                                              properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          blockType, WABlobPropertyKeyBlobType, 
                                                          cacheControl, WABlobPropertyKeyCacheControl,
                                                          contentEncoding, WABlobPropertyKeyContentEncoding,
                                                          contentLanguage, WABlobPropertyKeyContentLanguage,
                                                          contentLength, WABlobPropertyKeyContentLength,
                                                          contentMD5, WABlobPropertyKeyContentMD5,
                                                          contentType, WABlobPropertyKeyContentType,
                                                          eTag, WABlobPropertyKeyEtag,
                                                          lastModified, WABlobPropertyKeyLastModified,
                                                          leaseStatus, WABlobPropertyKeyLeaseStatus,
                                                          sequenceNumber, WABlobPropertyKeySequenceNumber,
                                                          nil]];         
        [blobs addObject:blob];
    }];
	
	return [blobs copy];
}

+ (NSArray *)loadBlobsForProxy:(xmlDocPtr)doc container:(WABlobContainer*)container
{
    if (doc == nil) { 
		return nil; 
	}
    
	NSMutableArray *blobs = [NSMutableArray arrayWithCapacity:30];
    
    [WAXMLHelper performXPath:@"/*/*/*" 
                 onDocument:doc 
                      block:^(xmlNodePtr node) {
        NSString *name = [WAXMLHelper getElementValue:node name:@"Name"];
        NSString *url = [WAXMLHelper getElementValue:node name:@"Url"];
        __block NSString *blockType = nil;
        __block NSString *cacheControl = nil;
        __block NSString *contentEncoding = nil;
        __block NSString *contentLanguage = nil;
        __block NSString *contentLength = nil;
        __block NSString *contentMD5 = nil;
        __block NSString *contentType = nil;
        __block NSString *eTag = nil;
        __block NSString *lastModified = nil;
        __block NSString *leaseStatus = nil;
        __block NSString *sequenceNumber = nil;
        
        [WAXMLHelper performXPath:@"_default:Properties" 
                           onNode:node 
                            block:^(xmlNodePtr node) {
            blockType = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyBlobType];
            cacheControl = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyCacheControl];
            contentEncoding = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentEncoding];
            contentLanguage = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentLanguage];
            contentLength = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentLength];
            contentMD5 = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentMD5];
            contentType = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyContentType];
            eTag = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyEtag]; 
            lastModified = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyLastModified];
            leaseStatus = [WAXMLHelper getElementValue:node name:WABlobPropertyKeyLeaseStatus];
            sequenceNumber = [WAXMLHelper getElementValue:node name:WABlobPropertyKeySequenceNumber];
        }];

        WABlob *blob = [[WABlob alloc] initBlobWithName:name URL:url container:container 
                                             properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         blockType, WABlobPropertyKeyBlobType, 
                                                         cacheControl, WABlobPropertyKeyCacheControl,
                                                         contentEncoding, WABlobPropertyKeyContentEncoding,
                                                         contentLanguage, WABlobPropertyKeyContentLanguage,
                                                         contentLength, WABlobPropertyKeyContentLength,
                                                         contentMD5, WABlobPropertyKeyContentMD5,
                                                         contentType, WABlobPropertyKeyContentType,
                                                         eTag, WABlobPropertyKeyEtag,
                                                         lastModified, WABlobPropertyKeyLastModified,
                                                         leaseStatus, WABlobPropertyKeyLeaseStatus,
                                                         sequenceNumber, WABlobPropertyKeySequenceNumber,
                                                         nil]];
        [blobs addObject:blob];
    }];
	
	return [blobs copy];
}

@end
