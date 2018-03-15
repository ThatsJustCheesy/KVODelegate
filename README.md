# KVODelegate

A small Objective-C library to make the Cocoa Key-Value Observing interface not suck.

## Features

### `KVOObservationDelegate`

`KVOObservationDelegate` provides a straightforward mechanism for triggering a callback whenever a KVO-compliant property changes state. The owner of an instance of this class registers a block or action selector with configurable sets of parameters. This block or selector is then called when one or more registered key paths are updated.

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

`KVONotificationDelegate` makes it easy to register KVO dependent keys correctly. It handles any and all possible setups, including any superclass-defined dependent keys, correctly and in an eloquent and easy-to-use manner. A class is first made to conform to the `KVONotificationDelegator` protocol by implementing `+configKVONotifcationDelegate:` and calling methods on the passed-in object to declare its dependent keys. `+keyPathsForValuesAffectingValueForKey` is then overrided to call upon a `KVONotificationDelegate`, optionally with a convenience macro.

#### Example

	@interface SomeClass <KVONotificationDelegator>
	[...]
	@end
	
	@implementation SomeClass
	
	+ (void)configKVONotificationDelegate:(KVONotificationDelegate *)delegate {
		[delegate key:@"object1" dependsUponKeyPath:@"object2"];
		[delegate key:@"oneFish" dependsUponKeyPath:@"twoFish"];
		[delegate key:@"twoFish" dependsUponKeyPath:@"redFish.blueFish"];
	}
	KVO_DELEGATE_HANDLES_keyPathsForValuesAffectingValueForKey; // Convenience macro
	
	@end

### Swift Support

KVODelegate fully supports Swift (version 4), although do note that as of Swift 4, a much better KVO observation mechanism exists that takes advantage of new language features. KVODelegate still functions in Swift, but the interfaces leave much to be desired. Major refinements will have to be made to `KVOObservationDelegate` to make it more pleasant to use if it’s ever going to be truly useful in a Swift environment. The current version of this library focuses primarily on Objective-C development, so this has not been done as of March 2018. Nonetheless, `KVONotificationDelegate` is still perfectly fine for Swift use and is still better than the built-in Foundation alternatives, and `KVOObservationDelegate` remains usable for e.g. Objective-C/Swift mix‘n’match.

KVODelegate’s interfaces have Swift-renamed methods to make them more appropriate for use in a Swift environment. Unit tests are written in both Objective-C and Swift, to test the usability and merits of both languages’ respective interfaces.

**Note for Swift users**: Since there's no C-style preprocessor in Swift, the `KVO_DELEGATE_HANDLES[...]` convenience macro is not available. Luckily, it’s pretty easy to implement the same functionality manually; just stick this code in your class:

	override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
	    return KVONotificationDelegate(forClass: self).keyPathsForValuesAffectingValue(forKey: key)
	}

This code achieves exactly the same effect as the Objective-C macro.

## Get It

Clone this repository and build the "KVODelegate Release" scheme in the xcodeproj. It should be automatically moved to ~/Library/Frameworks once complete.

## To-do

- More tests
    - Certain specific features, while I’m confident in them, are formally untested; additionally, as coverage reports show, the multi-key `-start`— methods are completely formally untested, but they, as far as I can tell, work just as well as the single-key versions.
- Better documentation
    - This library has no formal documentation aside from this README, but hopefully the class/method names are self-explanatory enough. Formal documentation would obviously be nice to have, but I feel that with the current state of the library, the work would be unnecessarily much for minimal payload.

Contributions are 100% welcome! Just open an issue/submit a pull request up at the top of the GitHub page.

## Tidbits

I was never planning on releasing this framework; I was just so irritated by the regular KVO APIs and all the boilerplate involved that I created this for myself. But sharing is nice, so why not?

MIT-licensed; go wild.