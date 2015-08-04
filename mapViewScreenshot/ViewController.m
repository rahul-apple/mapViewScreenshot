//
//  ViewController.m
//  mapViewScreenshot
//
//  Created by LordGanesh on 04/08/15.
//  Copyright (c) 2015 LordGanesh. All rights reserved.
//

#import "ViewController.h"

#import "ImageViewController.h"
@interface ViewController (){
    UIImageView *image;
    IBOutlet UIImageView *shot;
}

- (IBAction)take:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView =[[MKMapView alloc]init];
   // self.mapView.mapType=MKMapTypeStandard;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)take:(id)sender {
  image =  [self rp_screenshotImageViewWithCroppingRect:CGRectMake(0, 20, 200, 200)];
//    [self performSegueWithIdentifier:@"imageView" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier]isEqualToString:@"imageView"]) {
        ImageViewController *imag =(ImageViewController *)[segue destinationViewController];
        imag.imageView.image=image.image;
    }
}
/**
 Takes a screenshot of a UIView at a specific point and size, as denoted by
 the provided croppingRect parameter. Returns a UIImageView of this cropped
 region.
 
 CREDIT: This is based on @escrafford's answer at http://stackoverflow.com/a/15304222/535054
 */
- (UIImageView *)rp_screenshotImageViewWithCroppingRect:(CGRect)croppingRect {
    // For dealing with Retina displays as well as non-Retina, we need to check
    // the scale factor, if it is available. Note that we use the size of teh cropping Rect
    // passed in, and not the size of the view we are taking a screenshot of.
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(croppingRect.size, YES, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(croppingRect.size);
    }
    
    // Create a graphics context and translate it the view we want to crop so
    // that even in grabbing (0,0), that origin point now represents the actual
    // cropping origin desired:
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -croppingRect.origin.x, -croppingRect.origin.y);
    [self.view.layer renderInContext:ctx];
    
    // Retrieve a UIImage from the current image context:
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the image in a UIImageView:
    shot.image =snapshotImage;
    return [[UIImageView alloc] initWithImage:snapshotImage];
}
@end
