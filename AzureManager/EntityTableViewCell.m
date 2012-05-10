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

#import "EntityTableViewCell.h"
#import <stdarg.h>
#import "WAQueueMessage.h"
#import "WATableEntity.h"

@interface KeyPair : NSObject {
@private
	NSString* _key;
	NSString* _value;
}

@property (readonly) NSString* key;
@property (readonly) NSString* value;

+ (KeyPair*)keyPairWithKey:(NSString*)key value:(NSString*)value;

@end


@implementation EntityTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		_subviews = [[NSMutableArray alloc] initWithCapacity:20];
    }
    return self;
}

#pragma mark - View Life cycle

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

#pragma mark - Methods

/*- (void)setKeysAndObjects:(NSString*)key, ...
{
	va_list args;
	va_start(args, key);
	
	NSMutableArray* a = [NSMutableArray arrayWithCapacity:10];
	
	while (key) {
		if ([key isKindOfClass:[WATableEntity class]]) {
			WATableEntity *tableEntity = (WATableEntity*)key;
			for (NSString *key in [tableEntity keys]) {
				[a addObject:[KeyPair keyPairWithKey:key value:[tableEntity objectForKey:key]]];
			}
		} else if([key isKindOfClass:[WAQueueMessage class]]) {
			WAQueueMessage *queueMessage = (WAQueueMessage*)key;
			[a addObject:[KeyPair keyPairWithKey:@"Message ID" value:[queueMessage messageId]]];
			[a addObject:[KeyPair keyPairWithKey:@"Insertion Time" value:[queueMessage insertionTime]]];
			[a addObject:[KeyPair keyPairWithKey:@"Expiration Time" value:[queueMessage expirationTime]]];
			[a addObject:[KeyPair keyPairWithKey:@"Pop Receipt" value:[queueMessage popReceipt]]];
			[a addObject:[KeyPair keyPairWithKey:@"Time Next Visible" value:[queueMessage timeNextVisible]]];
            [a addObject:[KeyPair keyPairWithKey:@"Dequeue Count" value:[NSString stringWithFormat:@"%d", [queueMessage dequeueCount]]]];
			[a addObject:[KeyPair keyPairWithKey:@"Message Text" value:[queueMessage messageText]]];
		} else {
			NSString *value = va_arg(args, NSString*);
			[a addObject:[KeyPair keyPairWithKey:key value:value]];
		}
		
		key = va_arg(args, NSString*);
	}
	
	va_end(args);
	
	if(_subviews.count) {
		for(UIView *view in _subviews) {
			[view removeFromSuperview];
		}
		
		[_subviews removeAllObjects];
	}
	
	UIFont *labelFont = [UIFont boldSystemFontOfSize:12];
	UIFont *detailFont = [UIFont systemFontOfSize:14];
	NSInteger labelWidth = 0;
	NSMutableArray *labels = [NSMutableArray arrayWithCapacity:a.count];
	NSMutableArray *details = [NSMutableArray arrayWithCapacity:a.count];
	UILabel *label;
	UILabel *detail;
	UIColor *labelColor = [UIColor colorWithRed:3/15.0 green:6/15.0 blue:9/15.0 alpha:1.0];
	
	for (KeyPair* pair in a) {
		CGSize size = [pair.key sizeWithFont:labelFont forWidth:100 lineBreakMode:UILineBreakModeTailTruncation];
		
		if (size.width > labelWidth) {
			labelWidth = size.width;
		}
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.text = pair.key;
		label.textColor = labelColor;
		label.font = labelFont;
		label.lineBreakMode = UILineBreakModeTailTruncation;
		label.textAlignment = UITextAlignmentRight;
		label.highlightedTextColor = [UIColor whiteColor];
		
		detail = [[UILabel alloc] initWithFrame:CGRectZero];
		detail.text = pair.value;
		detail.textColor = [UIColor blackColor];
		detail.font = detailFont;
		detail.minimumFontSize = 12;
		detail.adjustsFontSizeToFitWidth = YES;
		detail.lineBreakMode = UILineBreakModeTailTruncation;
		detail.highlightedTextColor = [UIColor whiteColor];
		
		[_subviews addObject:label];
		[_subviews addObject:detail];
		[labels addObject:label];
		[details addObject:detail];
		
		[self.contentView addSubview:label];
		[self.contentView addSubview:detail];
	}
	
	NSInteger y = 7;

	int width = (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) ? 275 : 295;
	
	for (int n = 0; n < labels.count; n++) {
		label = [labels objectAtIndex:n];
		detail = [details objectAtIndex:n];
		CGRect rc;

		rc = CGRectMake(10, y, labelWidth, 22);
		label.frame = rc;
		
		rc = CGRectMake(25 + labelWidth, y, width - labelWidth - 50, 22);
		detail.frame = rc;
        
		y += 25;
	}
} */

- (void)setKeysAndObjects:(NSString*)key, ...
{
	va_list args;
	va_start(args, key);
	
	NSMutableArray* a = [NSMutableArray arrayWithCapacity:10];
	
    int propertyCount = 0;
    
	while (key) {
		if ([key isKindOfClass:[WATableEntity class]]) {
			WATableEntity *tableEntity = (WATableEntity*)key;
			for (NSString *key in [tableEntity keys]) {
				propertyCount++;
			}
		} else if([key isKindOfClass:[WAQueueMessage class]]) {
			WAQueueMessage *queueMessage = (WAQueueMessage*)key;
			[a addObject:[KeyPair keyPairWithKey:@"Message ID" value:[queueMessage messageId]]];
			[a addObject:[KeyPair keyPairWithKey:@"Insertion Time" value:[queueMessage insertionTime]]];
			[a addObject:[KeyPair keyPairWithKey:@"Expiration Time" value:[queueMessage expirationTime]]];
			[a addObject:[KeyPair keyPairWithKey:@"Pop Receipt" value:[queueMessage popReceipt]]];
			[a addObject:[KeyPair keyPairWithKey:@"Time Next Visible" value:[queueMessage timeNextVisible]]];
            [a addObject:[KeyPair keyPairWithKey:@"Dequeue Count" value:[NSString stringWithFormat:@"%d", [queueMessage dequeueCount]]]];
			[a addObject:[KeyPair keyPairWithKey:@"Message Text" value:[queueMessage messageText]]];
		} else {
			NSString *value = va_arg(args, NSString*);
			[a addObject:[KeyPair keyPairWithKey:key value:value]];
		}
		
		key = va_arg(args, NSString*);
	}
	
	va_end(args);
	
	if(_subviews.count) {
		for(UIView *view in _subviews) {
			[view removeFromSuperview];
		}
		
		[_subviews removeAllObjects];
	}
	
    [a addObject:[KeyPair keyPairWithKey:@"# Properties" value:[NSString stringWithFormat:@"%i", propertyCount]]];
    
	UIFont *labelFont = [UIFont boldSystemFontOfSize:12];
	UIFont *detailFont = [UIFont systemFontOfSize:14];
	NSInteger labelWidth = 0;
	NSMutableArray *labels = [NSMutableArray arrayWithCapacity:a.count];
	NSMutableArray *details = [NSMutableArray arrayWithCapacity:a.count];
	UILabel *label;
	UILabel *detail;
	UIColor *labelColor = [UIColor colorWithRed:3/15.0 green:6/15.0 blue:9/15.0 alpha:1.0];
    
	for (int i=0; i<[a count]; i++) {
        KeyPair *pair = [a objectAtIndex:i];
		CGSize size = [pair.key sizeWithFont:labelFont forWidth:100 lineBreakMode:UILineBreakModeTailTruncation];
		
		if (size.width > labelWidth) {
			labelWidth = size.width;
		}
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = pair.key;
		label.textColor = labelColor;
		label.font = labelFont;
		label.lineBreakMode = UILineBreakModeTailTruncation;
		label.textAlignment = UITextAlignmentRight;
		label.highlightedTextColor = [UIColor whiteColor];
		
		detail = [[UILabel alloc] initWithFrame:CGRectZero];
        detail.text = pair.value;
		detail.textColor = [UIColor blackColor];
		detail.font = detailFont;
		detail.minimumFontSize = 12;
		detail.adjustsFontSizeToFitWidth = YES;
		detail.lineBreakMode = UILineBreakModeTailTruncation;
		detail.highlightedTextColor = [UIColor whiteColor];
		
		[_subviews addObject:label];
		[_subviews addObject:detail];
		[labels addObject:label];
		[details addObject:detail];
		
		[self.contentView addSubview:label];
		[self.contentView addSubview:detail];
	}
	
	NSInteger y = 7;
    
	int width = (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) ? 275 : 295;
	
	for (int n = 0; n < labels.count; n++) {
		label = [labels objectAtIndex:n];
		detail = [details objectAtIndex:n];
		CGRect rc;
        
		rc = CGRectMake(10, y, labelWidth, 22);
		label.frame = rc;
		
		rc = CGRectMake(25 + labelWidth, y, width - labelWidth - 50, 22);
		detail.frame = rc;
        
		y += 25;
	}
}

@end

@implementation KeyPair
					   
@synthesize key = _key;
@synthesize value = _value;

- (id)initWithKey:(NSString*)key value:(NSString*)value
{
	if ((self = [super init])) {
		_key = [key copy];
		_value = [value copy];
	}
	
	return self;
}

+ (KeyPair*)keyPairWithKey:(NSString*)key value:(NSString*)value
{
	return [[self alloc] initWithKey:key value:value];
}

@end