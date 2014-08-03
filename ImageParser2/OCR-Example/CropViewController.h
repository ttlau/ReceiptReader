//
//  CropViewController.h
//  OCR-Example
//
//  Created by Tianyi Zhang on 02/08/2014.
//  Copyright (c) 2014 Christopher Constable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
- (IBAction)cropPhotoWasTapped:(id)sender;

@end
