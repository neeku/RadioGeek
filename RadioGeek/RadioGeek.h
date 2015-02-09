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

//error alert view
#define DELETE_CONFIRMATION_ALERT_TITLE @"هشدار!"
#define DELETE_CANCEL_BUTTON_TITLE @"نه"
#define OTHER_BUTTON_TITLE @"بله"
#define DELETE_WARNING_MESSAGE @"آیا از حدف فایل دانلود شده مطمئنید؟"


#pragma mark - NIKInfoViewController

//info label text in info vc
#define INFO_TEXT @"رادیو گیک، رادیوییست از گیک خوشحال و خندون، جادی، برای گیک‌ها و رادیویی شاد برای همه هکرها!\nرادیویی برای کسانی که تکنولوژی براشون فقط تلاش دائمی برای خوندن و حفظ اینکه فلان مدل بهمان چیز فرقش با اون یکی مدل اون یکی کارخونه چیه و تو بازار چنده و شایعه اینکه قراره کی مدل مثلا خفن‌ترش بیاد نیست و ترجیح می‌دن یک پله عمیق‌تر بشن و تو تقاطع تکنولوژی و جامعه، دغدغه‌های انسانیشون رو مطرح کنن. رادیو گیک برای گیک‌های سرگردان در تقاطع جامعه و تکنولوژی.";
#define EMAIL @"mailto:neeku@shamekhi.net?subject=رادیو گیک"
#define CONTACT_BUTTON_TITLE @"ارسال نظرات"
#define SHARE_BUTTON_TITLE @"پیشنهاد رادیوگیک به دوستان"
#define RATE_BUTTON_TITLE @"امتیازدهی در App Store"
#define RETURN_BUTTON_TITLE @"بازگشت"
#define COPYRIGHT_TEXT @"©\u00a02015 Tauris Ltd.\nwww.taur.is"
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

#define RATE_US_TITLE_MESSAGE @"اگر از %@ لذت می‌برید، لطفاً به آن امتیاز دهید!"
#define RATE_US_DEFAULT_MESSAGE @""
#define CANCEL_BUTTON_LABEL @"نه، متشکرم"
#define RATE_BUTTON_LABEL @"بله، حتماً"
#define REMIND_BUTTON_LABEL @"بعداً"



#endif
