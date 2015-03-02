//
//  ViewController.m
//  Demo
//
//  Created by YDPT2 on 15/1/20.
//  Copyright (c) 2015年 wutongr. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import <CoreText/CoreText.h>
#import "ReflectionView.h"

#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5

#define p(_X, _Y) CGPointMake(_X, _Y)
#define ScreenScale [UIScreen mainScreen].scale

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *glview;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, assign) GLuint framebuffer;
@property (nonatomic, assign) GLuint colorRenderbuffer;
@property (nonatomic, assign) GLint framebufferWidth;
@property (nonatomic, assign) GLint framebufferHeight;
@property (nonatomic, strong) GLKBaseEffect *effect;

@property (nonatomic,strong) NSArray *images;

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test17];
//    [self test16];
//    [self test15];
//    [self test14];
//    [self test13];
//    [self test12];
//    [self test11];
//    [self test10];
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
//    [self test9];
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"耗时%f",end - start);
//    [self test8];
//    [self test7];
//    [self test6];
//    [self test5];
//    [self test4];
//    [self test3];
    
//    [self test2];
//    [self test1];
   
//    int *a = malloc(1);
//    int *b = malloc(1);
//    
//    *a = 4;
//    *b = 3;
//    swap2(a, b);
//    
//    NSLog(@"%d",*a);
    
    

    // Do any additional setup after loading the view, typically from a nib.
}

void swap(int *a, int *b){
    int *temp = malloc(1);
    *temp = *a;
    *a = *b;
    *b = *temp;
}

void swap1(int *a, int *b){
    *a = *a ^ *b;
    *b = *a ^ *b;
    *a = *a ^ *b;
}

void swap2(int *a, int *b){
    *a = *a + *b;
    *b = *a - *b;
    *a = *a - *b;
}

-(void)setUpBuffers{
    //set up frame buffer
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    //set up color render buffer
    glGenRenderbuffers(1, &_colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
    [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_framebufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_framebufferHeight);
    //check success
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

-(void)tearDownBuffers{
    if(_framebuffer){
        glDeleteFramebuffers(1, &_framebuffer);
        _framebuffer = 0;
    }
    if(_colorRenderbuffer){
        glDeleteRenderbuffers(1, &_colorRenderbuffer);
        _colorRenderbuffer = 0;
    }
}

-(void)drawFrame{
    //bind framebuffer & set viewport
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glViewport(0, 0, _framebufferWidth, _framebufferHeight);
    //bind shader program
    [self.effect prepareToDraw];
    //clear the screen
    glClear(GL_COLOR_BUFFER_BIT); glClearColor(0.0, 0.0, 0.0, 1.0);
    //set up vertices
    GLfloat vertices[] = {
        -0.5f, -0.5f, -1.0f, 0.0f, 0.5f, -1.0f, 0.5f, -0.5f, -1.0f,
    };
    //set up colors
    GLfloat colors[] = {
        0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f,
    };
    //draw triangle
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLKVertexAttribColor,4, GL_FLOAT, GL_FALSE, 0, colors);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    //present render buffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)dealloc{
    [self tearDownBuffers];
    [EAGLContext setCurrentContext:nil];
}

-(void)test17{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIView *coverView = [[UIImageView alloc]initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    [UIView animateWithDuration:1.0 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [coverView removeFromSuperview];
    }];
}

-(void)test16{
    self.images = @[[UIImage imageNamed:@"1.png"],
                    [UIImage imageNamed:@"1.png"],
                    [UIImage imageNamed:@"1.png"],
                    [UIImage imageNamed:@"1.png"],
                    [UIImage imageNamed:@"1.png"]];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    
    [self.imageView.layer addAnimation:transition forKey:nil];
    UIImage *currentImage = self.imageView.image;
    
    NSUInteger index = [self.images indexOfObject:currentImage];
    index = (index + 1) % [self.images count];
    self.imageView.image = self.images[index];
}

-(void)test15{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:p(0, 150)];
    [bezierPath addCurveToPoint:p(300, 150) controlPoint1:p(75, 0) controlPoint2:p(225, 300)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    
    [self.containerView.layer addSublayer:pathLayer];
    
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(0, 0, 64, 64);
    colorLayer.position = p(0,150);
    colorLayer.backgroundColor = [UIColor greenColor].CGColor;
    
    [self.containerView.layer addSublayer:colorLayer];
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
    animation1.path = bezierPath.CGPath;
    animation1.rotationMode = kCAAnimationRotateAuto;
    
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (__bridge id)[UIColor redColor].CGColor;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1,animation2];
    groupAnimation.duration = 4.0f;
    
    [colorLayer addAnimation:groupAnimation forKey:nil];
}

-(void)test14{
    CALayer *roseLayer = [CALayer layer];
    roseLayer.frame = CGRectMake(0, 0, 64, 64);
    roseLayer.position = p(150, 150);
    roseLayer.contents = (__bridge id)[UIImage imageNamed:@"flower"].CGImage;
    [self.containerView.layer addSublayer:roseLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 2.0f;
    animation.byValue = @(M_PI *2);
    animation.delegate = self;
    [roseLayer addAnimation:animation forKey:@"rotateAnimation"];
}

-(void)stop{
    CALayer *roseLayer = [CALayer layer];
    [roseLayer removeAnimationForKey:@"rotateAnimation"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"The animation stopped (finished : %@)",flag? @"YES": @"NO");
}

-(void)test13{
    CALayer *roseLayer = [CALayer layer];
    roseLayer.frame = CGRectMake(0, 0, 64, 64);
    roseLayer.position = p(150, 150);
    roseLayer.contents = (__bridge id)[UIImage imageNamed:@"flower"].CGImage;
    [self.containerView.layer addSublayer:roseLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform";
    animation.duration = 2.0;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
    [roseLayer addAnimation:animation forKey:nil];
}


-(void)test12{
    UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
    [bezierPath moveToPoint:p(0, 150)];
    [bezierPath addCurveToPoint:p(300, 150) controlPoint1:p(75, 0) controlPoint2:p(225, 300)];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.containerView.layer addSublayer:pathLayer];
    
    CALayer *roseLayer = [CALayer layer];
    roseLayer.frame = CGRectMake(0, 0, 64, 64);
    roseLayer.position = p(0,150);
    roseLayer.contents = (__bridge id)[UIImage imageNamed:@"flower"].CGImage;
    [self.containerView.layer addSublayer:roseLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0f;
    animation.path = bezierPath.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    [roseLayer addAnimation:animation forKey:nil];
}

-(void)test11{
    //set up context
    self.glContext = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.glContext];
    //set up layer
    self.glLayer = [CAEAGLLayer layer];
    self.glLayer.frame = self.glview.bounds;
    [self.glview.layer addSublayer:self.glLayer];
    self.glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@NO, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    //set up base effect
    self.effect = [[GLKBaseEffect alloc] init];
    //set up buffers
    [self setUpBuffers];
    //draw frame
    [self drawFrame];
}

-(void)test10{
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:emitter];
//    emitter.scale = ScreenScale;
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = p(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    
    CAEmitterCell *cell = [[CAEmitterCell alloc]init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"Sparkle"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2.0;
    emitter.emitterCells = @[cell];
}

-(void)test9{
    CATiledLayer *tileLayer = [CATiledLayer layer];
    tileLayer.frame = CGRectMake(0, 0, 256 * 11, 256 * 6);
    tileLayer.delegate = self;
    tileLayer.contentsScale = ScreenScale;
    [self.scrollview.layer addSublayer:tileLayer];
    
//    self.scrollview.contentSize = tileLayer.frame.size;
    self.scrollview.contentSize = CGSizeMake(tileLayer.frame.size.width / ScreenScale, tileLayer.frame.size.height / ScreenScale);
    [tileLayer setNeedsDisplay];
}

-(void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx{
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width * ScreenScale);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height * ScreenScale);
    
    NSString *imageName = [NSString stringWithFormat:@"cd7cacb5ad_%d_%d",y,x];
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:imageName ofType:@"jpg"];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}


-(void)test7{
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    gradientLayer.frame =self.containerView.bounds;
    [self.containerView.layer addSublayer:gradientLayer];
    
//    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
//                             (__bridge id)[UIColor blueColor].CGColor];
    
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor yellowColor].CGColor,
                             (__bridge id)[UIColor greenColor].CGColor];
    
    gradientLayer.locations = @[@0.1,@0.35,@0.5];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
}

-(void)test8{
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.containerView.bounds;
    [self.containerView.layer addSublayer:replicator];
    
    replicator.instanceCount = 10;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicator.instanceTransform = transform;
    
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];
}

-(void)test6{
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500.0;
    self.containerView.layer.sublayerTransform = pt;
    CATransform3D clt = CATransform3DIdentity;
    clt = CATransform3DTranslate(clt, -100, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:clt];
    [self.containerView.layer addSublayer:cube1];
    
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.containerView.layer addSublayer:cube2];
}

-(CALayer *)faceWithTransform:(CATransform3D)transform{
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
    
    face.transform = transform;
    
    return face;
}

-(CALayer *)cubeWithTransform:(CATransform3D)transform{
    CATransformLayer *cube = [CATransformLayer layer];
    
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    CGSize containerSize = self.containerView.bounds.size;
    cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    
    cube.transform = transform;
    return cube;
}


-(void)test5{
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 200, 100)];
    [self.containerView addSubview:labelView];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = labelView.bounds;
    [labelView.layer addSublayer:textLayer];
    
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSString *text = @"Lorem ipsum dolor sit amet, consectetur adipiscing \ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc \ elementum, libero ut porttitor dictum, diam odio congue lacus, vel \ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \ lobortis";
    
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc]initWithString:text];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                              };
    
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName: (__bridge id)fontRef
                };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    CFRelease(fontRef);
    
    textLayer.string = string;
}

-(void)test4{
    
    UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 200, 100)];
    [self.containerView addSubview:labelView];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = labelView.bounds;
    [labelView.layer addSublayer:textLayer];
    
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    UIFont *font = [UIFont systemFontOfSize:15];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    NSString *text = @"Lorem ipsum dolor";
    
    textLayer.string = text;
}

-(void)test3{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:p(175, 100)];
    [path addArcWithCenter:p(150, 100) radius:25 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [path moveToPoint:p(150, 125)];
    [path addLineToPoint:p(150, 175)];
    [path moveToPoint:p(150, 175)];
    [path addLineToPoint:p(125, 225)];
    [path moveToPoint:p(150, 175)];
    [path addLineToPoint:p(175, 225)];
    [path moveToPoint:p(100, 150)];
    [path addLineToPoint:p(200, 150)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    [self.containerView.layer addSublayer:shapeLayer];
}

-(void)test2{
    CGRect rect = CGRectMake(50, 50, 100, 100);
    CGSize size = CGSizeMake(20, 20);
    UIRectCorner cornwes = UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:cornwes cornerRadii:size];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    
    [self.containerView.layer addSublayer:shapeLayer];
}


-(void)test1{
    self.view.backgroundColor = [UIColor grayColor];
    
    //set up the container sublayer transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    self.containerView.layer.sublayerTransform = perspective;
    //add cube face 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    //add cube face 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    //add cube face 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    //add cube face 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    //add cube face 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    //add cube face 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}

-(void)applyLightingToFace:(CALayer *)face{
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}


-(void)addFace:(NSInteger)index withTransform:(CATransform3D)transform{
    UIView *face = self.faces[index];
    face.layer.borderColor = [UIColor blackColor].CGColor;
    face.layer.borderWidth = 2.0f;
    [self.containerView addSubview:face];
    CGSize containSize = self.containerView.bounds.size;
    face.center = CGPointMake(containSize.width / 2.0, containSize.height / 2.0);
    face.layer.transform = transform;
    
    [self applyLightingToFace:face.layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
