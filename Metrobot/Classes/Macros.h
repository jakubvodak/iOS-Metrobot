//
//  Macros.h
//  Metrobot
//
//  Created by Jakub Vodak on 6/29/14.
//  Copyright (c) 2014 uLikeIT. All rights reserved.
//

////////////////////////////////////////////////////////////////
// Colors

#define RGBA_R(c) ((((c)>>16) & 0xff) * 1.f/255.f)
#define RGBA_G(c) ((((c)>> 8) & 0xff) * 1.f/255.f)
#define RGBA_B(c) ((((c)>> 0) & 0xff) * 1.f/255.f)
#define RGBA_A(c) ((((c)>>24) & 0xff) * 1.f/255.f)

#define UIColorWithARGB(c)	[UIColor colorWithRed:RGBA_R(c) green:RGBA_G(c) blue:RGBA_B(c) alpha:RGBA_A(c)]
#define UIColorWithRGB(c)	[UIColor colorWithRed:RGBA_R(c) green:RGBA_G(c) blue:RGBA_B(c) alpha:1.0]
#define UIColorWithRGBValues(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define UIColorWithRGBAValues(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]

////////////////////////////////////////////////////////////////
// BlockSelf

#define DEFINE_WEAK_SELF       __weak __typeof__(self) weakSelf = self
#define DEFINE_VIEW_WIDTH      CGFloat w = self.view.bounds.size.width;
#define DEFINE_VIEW_HEIGHT      CGFloat h = self.view.bounds.size.height;

#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
