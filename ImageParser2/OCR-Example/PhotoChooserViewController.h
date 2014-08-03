//
//  ViewController.h
//  OCR-Example
//
//  Created by Christopher Constable on 5/10/13.
//  Copyright (c) 2013 Christopher Constable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoChooserViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
- (IBAction)choosePhotoWasTapped:(id)sender;

@end
