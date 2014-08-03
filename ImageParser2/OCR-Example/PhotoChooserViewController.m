//
//  ViewController.m
//  OCR-Example
//
//  Created by Christopher Constable on 5/10/13.
//  Copyright (c) 2013 Christopher Constable. All rights reserved.
//

#import "PhotoChooserViewController.h"
#import "ResultsViewController.h"
#import "BJImageCropper/BJImageCropper/BJImageCropper.h"

#define SHOW_PREVIEW NO
#ifndef CGWidth
#define CGWidth(rect)                   rect.size.width
#endif

#ifndef CGHeight
#define CGHeight(rect)                  rect.size.height
#endif

#ifndef CGOriginX
#define CGOriginX(rect)                 rect.origin.x
#endif

#ifndef CGOriginY
#define CGOriginY(rect)                 rect.origin.y
#endif

@interface PhotoChooserViewController ()
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImageView *preview;
@property (nonatomic, strong) IBOutlet UILabel *boundsText;
@property (nonatomic, strong) BJImageCropper *cropView;
@end

@implementation PhotoChooserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Show process button
    if (self.selectedImage) {
        UIBarButtonItem *processButton = [[UIBarButtonItem alloc] initWithTitle:@"Process"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(processWasPressed:)];
        UIBarButtonItem *cropButton = [[UIBarButtonItem alloc] initWithTitle:@"Crop"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(cropPhotoWasTapped:)];
        [self.navigationItem setRightBarButtonItem:processButton animated:YES];
        [self.navigationItem setLeftBarButtonItem:cropButton animated:YES];
        [self.selectedImageView setImage:self.selectedImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cropPhotoWasTapped:(id)sender{
    _cropView = [[BJImageCropper alloc] initWithImage:self.selectedImage andMaxSize:CGSizeMake (1024, 600)];
    
    
    [self.view addSubview:_cropView];
    _cropView.center = self.view.center;
    _cropView.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    _cropView.imageView.layer.shadowRadius = 3.0f;
    _cropView.imageView.layer.shadowOpacity = 0.8f;
    _cropView.imageView.layer.shadowOffset = CGSizeMake(1, 1);
    
    [_cropView addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];
    
    if (SHOW_PREVIEW) {
        self.preview = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,_cropView.crop.size.width * 0.1, _cropView.crop.size.height * 0.1)];
        self.preview.image = [_cropView getCroppedImage];
        self.preview.clipsToBounds = YES;
        self.preview.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.preview.layer.borderWidth = 2.0;
        [self.view addSubview:self.preview];
    }

                                            
}

- (void)updateDisplay {
    self.boundsText.text = [NSString stringWithFormat:@"(%f, %f) (%f, %f)", CGOriginX(_cropView.crop), CGOriginY(_cropView.crop), CGWidth(_cropView.crop), CGHeight(_cropView.crop)];
    
    if (SHOW_PREVIEW) {
        self.preview.image = [_cropView getCroppedImage];
        self.preview.frame = CGRectMake(10,10,_cropView.crop.size.width * 0.1, _cropView.crop.size.height * 0.1);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:_cropView] && [keyPath isEqualToString:@"crop"]) {
        [self updateDisplay];
    }
}

-(UIImage *)getPhoto{
    return [_cropView getCroppedImage];
}

- (void)processWasPressed:(id)sender
{
    ResultsViewController *resultsVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"Results"];
    
    // Create loading view.
    resultsVC.loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
    resultsVC.loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [resultsVC.view addSubview:resultsVC.loadingView];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
    [resultsVC.loadingView addSubview:activityView];
    activityView.center = resultsVC.loadingView.center;
    [activityView startAnimating];
    
    resultsVC.selectedImage = [_cropView getCroppedImage];
    [resultsVC.selectedImageView setImage:[_cropView getCroppedImage]];
    
    // Push
    [self.navigationController pushViewController:resultsVC animated:YES];
    
}

- (IBAction)choosePhotoWasTapped:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
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
