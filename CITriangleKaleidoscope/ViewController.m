//
//  ViewController.m
//  CITriangleKaleidoscope
//
//  Created by Naoto Yoshioka on 2013/12/16.
//  Copyright (c) 2013年 Naoto Yoshioka. All rights reserved.
//

#import "ViewController.h"

@interface MySlider : UISlider
@property (nonatomic) NSString *attributeKey;

@end

@implementation MySlider
{
    UILabel *valueLabel;
}

- (void)setupWithAttributes:(NSDictionary*)attributes forKey:(NSString*)attrKey
{
    NSDictionary *attr = attributes[attrKey];
    self.minimumValue = [attr[kCIAttributeSliderMin] floatValue];
    self.maximumValue = [attr[kCIAttributeSliderMax] floatValue];
    self.value = [attr[kCIAttributeDefault] floatValue];
    self.attributeKey = attrKey;
}

- (void)setupValueLabel
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, h/2)];
    [self addSubview:valueLabel];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupValueLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupValueLabel];
    }
    return self;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    valueLabel.text = [NSString stringWithFormat:@"%g", value];
    return result;
}

@end

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MySlider *sizeSlider;
@property (weak, nonatomic) IBOutlet MySlider *rotationSlider;
@property (weak, nonatomic) IBOutlet MySlider *decaySlider;

@end

@implementation ViewController
{
    CIFilter *filter;
    CGRect imageRect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    filter = [CIFilter filterWithName:@"CITriangleKaleidoscope"];

    [self.sizeSlider     setupWithAttributes:filter.attributes forKey:@"inputSize"];
    [self.rotationSlider setupWithAttributes:filter.attributes forKey:@"inputRotation"];
    [self.decaySlider    setupWithAttributes:filter.attributes forKey:@"inputDecay"];
    
    [filter setValue:[CIImage imageWithCGImage:self.imageView.image.CGImage] forKey:kCIInputImageKey];

    CGSize size = self.imageView.image.size;
    [filter setValue:[CIVector vectorWithX:size.width/2 Y:size.height/2] forKey:@"inputPoint"];

    imageRect = CGRectMake(0, 0, size.width, size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderValueChanged:(MySlider *)sender {
    
    [filter setValue:@(sender.value) forKey:sender.attributeKey];

    CIImage *result = filter.outputImage;
    if (result) {
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:result fromRect:imageRect];
        self.imageView.image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
    } else {
        NSLog(@"warning: nil result");
    }
}

@end
