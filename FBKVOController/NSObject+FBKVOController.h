///:
/*****************************************************************************
 **                                                                         **
 **                               .======.                                  **
 **                               | INRI |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                      .========'      '========.                         **
 **                      |   _      xxxx      _   |                         **
 **                      |  /_;-.__ / _\  _.-;_\  |                         **
 **                      |     `-._`'`_/'`.-'     |                         **
 **                      '========.`\   /`========'                         **
 **                               | |  / |                                  **
 **                               |/-.(  |                                  **
 **                               |\_._\ |                                  **
 **                               | \ \`;|                                  **
 **                               |  > |/|                                  **
 **                               | / // |                                  **
 **                               | |//  |                                  **
 **                               | \(\  |                                  **
 **                               |  ``  |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                               |      |                                  **
 **                   \\    _  _\\| \//  |//_   _ \// _                     **
 **                  ^ `^`^ ^`` `^ ^` ``^^`  `^^` `^ `^                     **
 **                                                                         **
 **                  Created by Facebook Inc. Originally                    **
 **               https://github.com/facebook/KVOController                 **
 **               Copyright (c) 2014-present, Facebook, Inc.                **
 **                         ALL RIGHTS RESERVED.                            **
 **                                                                         **
 **              Forked, Changed and Republished by Tong Guo                **
 **                 https://github.com/TongG/KVOController                  **
 **                      Copyright (c) 2014 Tong G.                         **
 **                         ALL RIGHTS RESERVED.                            **
 **                                                                         **
 ****************************************************************************/

#import <Foundation/Foundation.h>
#import "FBKVOController.h"

@interface NSObject ( FBKVOController )

/**
 @abstract Lazy-loaded FBKVOController for use with any object
 @return FBKVOController associated with this object, creating one if necessary
 @discussion This makes it convenient to simply create and forget a FBKVOController, and when this object gets dealloc'd, so will the associated controller and the observation info.
 */
@property ( nonatomic, strong ) FBKVOController* KVOController;
@property ( nonatomic, strong ) FBKVOController* KVOControllerNonRetaining;

@end

//////////////////////////////////////////////////////////////////////////////

/*****************************************************************************
 **                                                                         **
 **      _________                                      _______             **
 **     |___   ___|                                   / ______ \            **
 **         | |     _______   _______   _______      | /      |_|           **
 **         | |    ||     || ||     || ||     ||     | |    _ __            **
 **         | |    ||     || ||     || ||     ||     | |   |__  \           **
 **         | |    ||     || ||     || ||     ||     | \_ _ __| |  _        **
 **         |_|    ||_____|| ||     || ||_____||      \________/  |_|       **
 **                                           ||                            **
 **                                    ||_____||                            **
 **                                                                         **
 ****************************************************************************/
///:~