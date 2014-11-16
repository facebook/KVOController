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

/**
 @abstract Block called on key-value change notification.
 @pragm keyPath The key path, relative to object, to the value that has changed.
 @param observer The observer of the change.
 @param object The object changed.
 @param change The change dictionary.
 */
typedef void ( ^FBKVONotificationBlock )( NSString* _KeyPath, id _Observer, id _Object, NSDictionary* _Change );

#pragma mark FBKVOController class
/**
 @abstract FBKVOController makes Key-Value Observing simpler and safer.
 @discussion FBKVOController adds support for handling key-value changes with blocks and custom actions, as well as the NSKeyValueObserving callback. Notification will never message a deallocated observer. Observer removal never throws exceptions, and observers are removed implicitly on controller deallocation. FBKVOController is also thread safe. When used in a concurrent environment, it protects observers from possible resurrection and avoids ensuing crash. By default, the controller maintains a strong reference to objects observed.
 */
@interface FBKVOController : NSObject

/**
 @abstract Creates and returns an initialized KVO controller instance.
 @param observer The object notified on key-value change.
 @return The initialized KVO controller instance.
 */
+ ( instancetype ) controllerWithObserver: ( id )_Observer;

/**
 @abstract The designated initializer.
 @param observer The object notified on key-value change. The specified observer must support weak references.
 @param retainObserved Flag indicating whether observed objects should be retained.
 @return The initialized KVO controller instance.
 @discussion Use retainObserved = NO when a strong reference between controller and observee would create a retain loop. When not retaining observees, special care must be taken to remove observation info prior to observee dealloc.
 */
- ( instancetype ) initWithObserver: ( id )_Observer retainObserved: ( BOOL )_RetainObserved;

/**
 @abstract Convenience initializer.
 @param bserver The object notified on key-value change. The specified observer must support weak references.
 @return The initialized KVO controller instance.
 @discussion By default, KVO controller retains objects observed.
 */
- ( instancetype ) initWithObserver: ( id )_Observer;

/// The observer notified on key-value change. Specified on initialization.
@property ( atomic, weak, readonly ) id observer;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param block The block to execute on notification.
 @discussion On key-value change, the specified block is called. Inorder to avoid retain loops, the block must avoid referencing the KVO controller or an owner thereof. Observing an already observed object key path or nil results in no operation.
 */
- ( void ) observe: ( id )_Object
           keyPath: ( NSString* )_KeyPath
           options: ( NSKeyValueObservingOptions )_Options
             block: ( FBKVONotificationBlock )_Block;
/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param action The observer selector called on key-value change.
 @discussion On key-value change, the observer's action selector is called. The <i>action</i> should have the following signature: 
    <p><code>- ( void ) observedPropertiesChange: ( NSDictionary* )change
                                         keyPath: ( NSString* )keyPath
                                          object: ( id )object
    </code></p>
    <p>Observing nil or observing an already observed object's key path results in no operation. </p>
 */
- ( void ) observe: ( id )_Object
           keyPath: ( NSString* )_KeyPath
           options: ( NSKeyValueObservingOptions )_Options
            action: ( SEL )_Action;
/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param context The context specified.
 @discussion On key-value change, the observer's -observeValueForKeyPath:ofObject:change:context: method is called. Observing an already observed object key path or nil results in no operation.
 */
- ( void ) observe: ( id )_Object
           keyPath: ( NSString* )_KeyPath
           options: ( NSKeyValueObservingOptions )_Options
           context: ( void* )_Context;

/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPaths The key paths to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param block The block to execute on notification.
 @discussion On key-value change, the specified block is called. Inorder to avoid retain loops, the block must avoid referencing the KVO controller or an owner thereof. Observing an already observed object key path or nil results in no operation.
 */
- ( void ) observe: ( id )_Object
          keyPaths: ( NSArray* )_KeyPaths
           options: ( NSKeyValueObservingOptions )_Options
             block: ( FBKVONotificationBlock )_Block;
/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPaths The key paths to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param action The observer selector called on key-value change.
 @discussion On key-value change, the observer's action selector is called. The <i>action</i> should have the following signature: 
    <p><code>- ( void ) observedPropertiesChange: ( NSDictionary* )change
                                         keyPath: ( NSString* )keyPath
                                          object: ( id )object
    </code></p>
    <p>Observing nil or observing an already observed object's key path results in no operation. </p>
 */
- ( void ) observe: ( id )_Object
          keyPaths: ( NSArray* )_KeyPaths
           options: ( NSKeyValueObservingOptions )_Options
            action: ( SEL )_Action;
/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPaths The key paths to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param context The context specified.
 @discussion On key-value change, the observer's -observeValueForKeyPath:ofObject:change:context: method is called. Observing an already observed object key path or nil results in no operation.
 */
- ( void ) observe: ( id )_Object
          keyPaths: ( NSArray* )_KeyPaths
           options: ( NSKeyValueObservingOptions )_Options
           context: ( void* )_Context;

/**
 @abstract Unobserve object key path.
 @param object The object to unobserve.
 @param keyPath The key path to observe.
 @discussion If not observing object key path, or unobserving nil, this method results in no operation.
 */
- ( void ) unobserve: ( id )_Object
             keyPath: ( NSString* )_KeyPath;

/**
 @abstract Unobserve all object key paths.
 @param object The object to unobserve.
 @discussion If not observing object, or unobserving nil, this method results in no operation.
 */
- ( void ) unobserve: ( id )_Object;

/**
 @abstract Unobserve all objects.
 @discussion If not observing any objects, this method results in no operation.
 */
- ( void ) unobserveAll;

@end // FBKVOController class

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