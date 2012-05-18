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

#import "MyButton.h"


@implementation MyButton

- (void)awakeFromNib
{
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
	[self setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
	self.titleLabel.shadowOffset = CGSizeMake(0, 1);
	
	UIImage *img = [UIImage imageNamed:@"buttonImage.png"];
	UIImage *image = [img stretchableImageWithLeftCapWidth:10 topCapHeight:0];
	[self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setEnabled:(BOOL)enabled
{
	[super setEnabled:enabled];
	
	self.alpha = enabled ? 1.0 : 0.5;
}

@end
