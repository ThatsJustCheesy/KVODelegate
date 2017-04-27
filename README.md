# KVODelegate

A small Objective-C library to make the Cocoa Key-Value Observing interface not suck.

## Features

### `KVOObservationDelegate`

`KVOObservationDelegate` provides a straightforward mechanism for triggering a callback whenever a KVO-compliant property changes state. The owner of an instance of this class registers a block with configurable sets of parameters. This block is then called when one or more registered key paths are updated.

#### Example

	@property KVOObservationDelegate *kvoDelegate;
	
	[...]
	
	- (void)viewDidLoad {
		_kvoDelegate = [KVOObservationDelegate new];
		[self.kvoDelegate startObservingKeyPath:@"representedObject.thing" on:self
			usingNewOldBlock:^(id newValue, id oldValue) {
			NSLog(@"Thing changed from %@ to %@", oldValue, newValue);
		} options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld];
	}
	
	- (void)dealloc {
		[self.kvoDelegate stopObservingAllKeyPaths];
	}

### `KVONotificationDelegate`

`KVONotificationDelegate` makes it easy to register KVO dependent keys correctly. It handles all cases, including any superclass-defined dependent keys, in an eloquent and easy-to-use manner. A class first conforms to the `KVONotificationDelegator` protocol by implementing `+configKVONotifcationDelegate:`, and calling methods on the passed-in object to declare your dependent keys. A macro is then added to the class to automatically handle `+keyPathsForValuesAffectingValueForKey:` messages (NOTE: see note below for how to do this in Swift, without preprocessor macros).

#### Example

	@interface SomeClass <KVONotificationDelegator>
	[...]
	@end
	
	@implementation SomeClass <KVONotificationDelegator>
	
	+ (void)configKVONotificationDelegate:(KVONotificationDelegate *)delegate {
		[delegate key:@"object1" dependsUponKeyPath:@"object2"];
		[delegate key:@"oneFish" dependsUponKeyPath:@"twoFish"];
		[delegate key:@"twoFish" dependsUponKeyPath:@"redFish.blueFish"];
	}
	KVO_DELEGATE_HANDLES_keyPathsForValuesAffectingValueForKey;
	
	@end

### Swift Support

KVODelegate fully supports Swift (version 3). The interfaces have renamed methods to make them more appropriate for a Swift environment. Unit tests are written in both Objective-C and Swift.

**Note for Swift users**: Since there's no C-style preprocessor in Swift, the `KVO_DELEGATE_HANDLES[...]` macro is not available. Luckily, this is pretty easy to implement manually; just stick this code in your class:

	override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
	    return KVONotificationDelegate(forClass: self).keyPathsForValuesAffectingValue(forKey: key)
	}

This achieves exactly the same effect as the Objective-C macro.

## Get It

Clone this repository and build the "KVODelegate Release" scheme in the xcodeproj. It should be automatically moved to ~/Library/Frameworks once complete.

## To-do

- More tests
- Better documentation

Contributions are welcome!

## Tidbits

I was never planning on releasing this framework; I was just so irritated by the regular KVO APIs and all the boilerplate involved that I created this for myself. But hey, sharing is caring!

MIT-licensed; go wild.