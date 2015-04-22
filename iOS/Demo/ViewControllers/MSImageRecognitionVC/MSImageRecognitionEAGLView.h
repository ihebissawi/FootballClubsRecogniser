//
//  MSImageRecognitionEAGLView.h
//  FlagRecognition
//
//  Created by Viktor Levschanov on 06.03.14.
//  Copyright (c) 2014 DataArt Solutions, Inc. All rights reserved.
//

#if (!TARGET_IPHONE_SIMULATOR)

#import <UIKit/UIKit.h>

#import <QCAR/UIGLViewProtocol.h>
#import "MSImageRecognitionSession.h"

// EAGLView is a subclass of UIView and conforms to the informal protocol UIGLViewProtocol
@interface MSImageRecognitionEAGLView : UIView <UIGLViewProtocol>{
@private
    // OpenGL ES context
    EAGLContext *_context;
    
    // The OpenGL ES names for the framebuffer and renderbuffers used to render
    // to this view
    GLuint _defaultFramebuffer;
    GLuint _colorRenderbuffer;
    GLuint depthRenderbuffer;
    
    // Shader handles
    GLuint shaderProgramID;
    GLint vertexHandle;
    GLint normalHandle;
    GLint textureCoordHandle;
    GLint mvpMatrixHandle;
    GLint texSampler2DHandle;
    
    BOOL offTargetTrackingEnabled;
    
    MSImageRecognitionSession * vapp;
}

- (id)initWithFrame:(CGRect)frame appSession:(MSImageRecognitionSession *) app;

- (void)finishOpenGLESCommands;
- (void)freeOpenGLESResources;

- (void) setOffTargetTrackingMode:(BOOL) enabled;

@end

#endif