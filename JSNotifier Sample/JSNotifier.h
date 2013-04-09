/*
 Copyright 2012 Jonah Siegle
 
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

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

typedef enum {
	JSNotifierShowTypeSuccess = 0,
	JSNotifierShowTypeError = 1
} JSNotifierShowType;

typedef enum {
	JSNotifierShowModeSlide = 0,
	JSNotifierShowModeFade = 1
} JSNotifierShowMode;

typedef enum {
	JSNotifierPositionTop = 0,
	JSNotifierPositionBottom = 1
} JSNotifierPosition;

@interface JSNotifier : UIView{
    
    @protected
    UILabel *_txtLabel;
}

+ (void)showSuccessWithTitle:(NSString*) title mode:(JSNotifierShowMode) mode position:(JSNotifierPosition) position forTime:(float) time;
+ (void)showErrorWithTitle:(NSString*) title mode:(JSNotifierShowMode) mode position:(JSNotifierPosition) position forTime:(float) time;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, unsafe_unretained) JSNotifierPosition position;
@property (nonatomic, unsafe_unretained) JSNotifierShowMode mode;
@property (nonatomic, strong) UIImageView* accessoryView;

@end

