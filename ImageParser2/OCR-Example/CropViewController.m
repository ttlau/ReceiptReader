//
//  CropViewController.m
//  OCR-Example
//
//  Created by Tianyi Zhang on 02/08/2014.
//  Copyright (c) 2014 Christopher Constable. All rights reserved.
//

#import "CropViewController.h"
#import "BJImageCropper.h"

@interface CropViewController ()

@end

@implementation CropViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cropPhotoWasTapped:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    BJImageCropper *imageCropper = [[BJImageCropper alloc] initWithImage: self.selectedImage];
    imagePickerController.delegate = self;
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:nil];
}



@end
