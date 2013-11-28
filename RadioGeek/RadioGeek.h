//
//  RadioGeek.h
//  RadioGeek
//
//  Created by Neeku on 11/12/13.
//  Copyright (c) 2013 NeekuShamekhi. All rights reserved.
//

#ifndef RadioGeek_RadioGeek_h
#define RadioGeek_RadioGeek_h

#pragma mark - NIKMasterViewController

//error alert view
#define ALERT_TITLE @"خطا"
#define CANCEL_BUTTON_TITLE @"بسیار خوب"
#define ERROR_MESSAGE @"۴۰۴ - فایل بر روی سرور موجود نیست"
//navigation bar title
#define NAV_BAR_TITLE @"رادیو گیک"

//tableview cell properties
#define TITLE_LABEL_FRAME CGRectMake(5.0, 5.0, 200.0, 10.0)
#define DATE_LABEL_FRAME CGRectMake(5.0, 25.0, 200.0, 10.0)
#define TITLE_LABEL_TAG 1
#define DATE_LABEL_TAG 2

#pragma mark - NIKDetailViewController



#pragma mark - NIKInfoViewController

//info label text in info vc
#define INFO_TEXT @"رادیویی برای کسانی که تکنولوژی براشون فقط تلاش دائمی برای خوندن و حفظ اینکه فلان مدل بهمان چیز فرقش با اون یکی مدل اون یکی کارخونه چیه و تو بازار چنده و شایعه اینکه قراره کی مدل مثلا خفن‌ترش بیاد نیست و ترجیح می‌دن یک پله عمیق تر بشن و تو تقاطع تکنولوژی و جامعه، دغدغه‌های انسانی‌شون رو مطرح کنن. رادیو گیک برای گیک های سرگردان در تقاطع جامعه و تکنولوژی.";

#pragma mark - Persian Fonts 
//Persian font configurations


#define PP_FONT_NORMAL					[UIFont fontWithName:@"XB Roya" size:15]
#define PP_FONT_NORMAL_IPAD             [UIFont fontWithName:@"XB Roya" size:18]
#define PP_FONT_NORMAL_OF(x)			[UIFont fontWithName:@"XB Roya" size:x]
#define PP_FONT_HEADING					[UIFont fontWithName:@"XBRoya-Bold" size:16]
#define PP_FONT_HEADING_IPAD			[UIFont fontWithName:@"XBRoya-Bold" size:19]
#define PP_COLOR_IRRELEVANT_MESRA		[UIColor darkGrayColor]
#define PP_COLOR_SELECTED_SEARCH_RESULT	[UIColor brownColor]
#define PP_COLOR_NOT_FOUND				[UIColor redColor]
#define PP_COLOR_SEARCH_RESULT_POEM_TITLE [UIColor redColor]
#define BiographyFontSize  15

#define TD_ROUNDED_IMAGE_CORNER 12

#pragma mark - iRate
//'Rate-Us on App Store' message configuration

#define RATE_US_MESSAGE @"If you enjoy playing %@, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!"
#define RATE_US_DEFAULT_MESSAGE @"If you enjoy using %@, would you mind taking a moment to rate it? It won’t take more than a minute. Thanks for your support!"
#define CANCEL_BUTTON_LABEL @"No, Thanks"
#define RATE_BUTTON_LABEL @"Rate It Now"
#define REMIND_BUTTON_LABEL @"Remind Me Later"

#endif
