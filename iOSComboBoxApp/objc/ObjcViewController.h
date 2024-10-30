//
//  ObjcViewController.h
//  iOSComboBoxApp
//
//  Created by Robert Andrzejczyk on 25/10/2024.
//

#import <UIKit/UIKit.h>
#import <iOSComboBox/iOSComboBox-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcViewController : UIViewController <iOSComboBoxDataSource, iOSComboBoxDelegate, UITextFieldDelegate>

@end

NS_ASSUME_NONNULL_END
