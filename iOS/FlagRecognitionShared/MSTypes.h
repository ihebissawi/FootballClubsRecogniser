//
//  MSTypes.h
//  FlagRecognition
//
//  Created by Lexiren on 2/11/14.
//  Copyright (c) 2014 Moodstocks. All rights reserved.
//

#ifndef FlagRecognition_MSTypes_h
#define FlagRecognition_MSTypes_h

typedef void (^MSCompletionBlockWithData)(BOOL success, NSError *error, id data);
typedef void (^MSCompletionBlock)(BOOL success, NSError *error);
typedef void (^MSButtonHandleBlock)(id sender);
typedef void (^MSButtonHandleBlockWithData)(id sender, id data);

static inline void performBlockOnMaintMainThread(void (^block)(void)) {
	if ([NSThread isMainThread]) {
		block();
	}
	else {
		dispatch_sync(dispatch_get_main_queue(), block);
	}
}

static inline void performCompletionBlockWithData(MSCompletionBlockWithData block, BOOL success, NSError *error, id data) {
    if (block) {
        block(success, error, data);
    }
}

static inline void performCompletionBlock(MSCompletionBlock block, BOOL success, NSError *error) {
    if (block) {
        block(success, error);
    }
}

static inline void performButtonHandleBlockWithData(MSButtonHandleBlockWithData block, id sender, id data) {
    if (block) {
        block(sender, data);
    }
}

static inline void performButtonHandleBlock(MSButtonHandleBlock block, id sender) {
    if (block) {
        block(sender);
    }
}


#endif
