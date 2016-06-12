/**
 CoreDataStack - CoreData made easy
 
 c.f. https://github.com/adamgit/CoreDataStack for docs + support
 
 The most important method here is:
 
 coreDataStackWithModelName:
 
 (this creates a new instance, pointing to the CoreData MOM/MOMD file that was generated by Xcode)
 
 --------------- Important note ---------------
 
 NB: Apple in many places uses an NSString argument; you should never use a string argument! That makes unsafe code, and it reveals a major bug in Apple's
 Xcode refactoring (Xcode "refactor rename" WILL CORRUPT your project, in all known versions of Xcode, if you use it on a CoreData class).
 
 Its bad practice. There's good reason for allowing String arguments (it enables CoreData to work with classes that it doesn't actually have the class file)
 but that's a very rare case for most projects. I have never seen it on a live project (although I could construct a theoretical project which needed it).
 
 This class is *compatible* with Apple's approach (you can always access the NSManagedObjectContext directly, and use Apple's NSString-based methods *if you
 need to*), but it discourages you from using them.
 
 As a bonus, when using this class, XCode autocomplete works again (Apple disabled autocomplete for CoreData classes back in XCode 4.0, and still hasn't
 added it back again).
 */
#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

#define kNotificationDestroyAllNSFetchedResultsControllers @"DestroyAllNSFetchedResultsControllers"
typedef enum CDSStoreType
{
    CDSStoreTypeUnknown,
    CDSStoreTypeXML,
    CDSStoreTypeSQL,
    CDSStoreTypeBinary,
    CDSStoreTypeInMemory
} CDSStoreType;

@interface STCoreDataStack : NSObject
{
    NSManagedObjectModel* _mom;
    NSManagedObjectContext* _moc;
    NSPersistentStoreCoordinator* _psc;
}

/** Apple's CoreData officially does not support Multi-Threading. If you force it to run single-threaded
 (which is non-trivial and requires NOT using some of the official multi-threading features of iOS!),
 but make a mistake ... instead of failing, it silently corrupts your datastores while running!
 
 So, until Apple fixes their thread-unsafe code - or introduces proper assertions / error-handling to
 guard against it - most projects need an "emergency failsafe" to stop your app from "accidentally"
 accessing the thread-unsafe code.
 
 What we do:
 
 The first thread that uses a stack is THE ONLY thread we allow to access the stack ("uses" and "access" here mean: "reads the .managedObjectContext
 property")
 
 OFFICIALLY from Apple docs: it is not just "writes" to objects that are dangerous, but also "reads":
 
 http://developer.apple.com/library/ios/#documentation/cocoa/conceptual/coredata/Articles/cdConcurrency.html#//apple_ref/doc/uid/TP40003385-SW1
 
 "Core Data does not present a situation where reads are “safe” but changes are “dangerous”—every operation is “dangerous” because every operation has cache coherency effects and can trigger faulting"
 */
@property(nonatomic,assign,readonly) NSThread* threadThatOwnsThisStack;

/*! The actual URL that's in use - you can pass this to init, or let the CoreDataStack work it out automatically */
@property(nonatomic,retain) NSURL* databaseURL;
/*! Name of the model file in Xcode, with no extension - e.g. for "Model.xcdatamodeld", this is "Model" */
@property(nonatomic,retain) NSString* modelName;
/*! Apple crashes if you don't tell it the correct 'type' of CoreData store. This class will try to guess it for you, and seems to get it right - if not, you can explicitly set it during or after init */
@property(nonatomic) CDSStoreType coreDataStoreType;
/**
 Defaults to NSConfinementConcurrencyType (was the only option prior to iOS 5)
 
 Changing this *after* you've generated a MOC (by calling the .managedObjectContext getter) will cause an asertion - you really shouldn't do that
 */
@property(nonatomic) NSManagedObjectContextConcurrencyType managedObjectContextConcurrencyType;

/*! Most apps need this set to "TRUE", but Apple defaults to FALSE, so we default to FALSE too */
@property(nonatomic) BOOL automaticallyMigratePreviousCoreData;

/** Very useful when developing an app: make "Failed saves" *immediately* Assert (pause the debugger), so you can quickly debug them,
 instead of silently failing and you not noticing that your in-memory data is corrupt! */
@property(nonatomic) BOOL shouldAssertWhenSaveFails;

/*! To use CoreData, you need to provide a permanent filename for it to save its sqlite DB to disk - or provide a manual URL to where
 you've already saved it. You also need to provide a model name
 
 For instance, in Xcode's visual editor for CoreData, the visual file itself is your "model", and the filename is something like:
 
 "CoreData.mom"
 "Model.momd"
 
 ...or similar.
 
 Generally, you should ignore Xcode's defaults and rename that to something useful, like:
 
 "ModelForUploads.mom"
 "UserAccountsModel.momd"
 
 Whatever you call it ... the first part of the filename (everything before .mom / .momd) is what you provide to this method in your source code to
 access CoreData.
 */
+(STCoreDataStack*) coreDataStackWithModelName:(NSString*) mname;

/*!
 NB: either keep this reference and re-use it throughout your app, or use the other version of this method that returns a "shared" pointer,
 otherwise you'll get CoreData inconsistency errors
 */
+(STCoreDataStack*) coreDataStackWithModelName:(NSString *)mname databaseFilename:(NSString*) dbname;

/**
 Same as the other coreDataStackWithModelName methods, except this caches the result and if you call it again
 later with the same arguments you get a pointer to the same object.
 
 This is convenient when you don't want to pass a CoreDataStack pointer back-and-forth between all your UIViewControllers,
 and makes it act like a singleton
 */
+(STCoreDataStack*) coreDataStackWithSharedModelName:(NSString *)mname databaseFilename:(NSString*) dbname;

/**
 Lower-level version of coreDataStackWithModelName that uses the underlying file URL.
 
 Mostly useful for recreating the exact same stack later on, e.g.:
 
 firstStack = [CoreDataStack coreDataStackWithModelName: @"MyModel"];
 secondStack = [CoreDataStack coreDataStackWithDatabaseURL: firstStack.databaseURL]; // uses the same config data, but is NOT shared
 */
+(STCoreDataStack*) coreDataStackWithDatabaseURL:(NSURL*) dburl modelName:(NSString*) mname;

/**
 Generally, you should NOT use this method; use the static "coreDataStackWith..." methods instead, which
 use this method and automatically generate the non-obvious arguments for you
 */
- (id)initWithURL:(NSURL*) url modelName:(NSString *)mname storeType:(CDSStoreType) type;

/** Apple's NSManagedObjectModel in this stack */
-(NSManagedObjectModel*) dataModel;

/** Apple's NSPersistentStoreCoordinator in this stack */
-(NSPersistentStoreCoordinator*) persistentStoreCoordinator;

/** Apple's NSManagedObjectContext in this stack
 
 NB: your app will FREQUENTLY reference this - the managedObjectContext ("MOC") is the main starting point needed
 for almost all CoreData actions
 */
-(NSManagedObjectContext*) managedObjectContext;

#pragma mark - boilerplate methods which you'll need on every project but Apple didn't include

/*! Useful method that most apps need, to check instantly whether they've been initialized with this CD store before */
-(BOOL) storeContainsAtLeastOneEntityOfClass:(Class) c;

/*! Every app MUST save the context sooner or later, but Apple's implementation of CoreData doesn't support Blocks.
 
 Let's fix that!
 
 NB: the syntax for Apple's non-blocks-based "save" is very easy to get wrong, and requires you to declar an Error
 var every time you use it. This is much simpler.
 */
-(void) saveOrFail:(void(^)(NSError* errorOrNil)) blockFailedToSave;

/** Shorthand for Apple's clunky method:
 
 [NSEntityDescription entityForName: inManagedObjectContext:]
 
 NB: Apple uses an NSString argument; you should never use a string argument! (c.f. top of this file for more details)
 
 ...instead, call this method for an entity named e.g. Entity (Apple's default entity name):
 
 "[stack entityForClass:[Entity class]];"
 
 NB: Obviously, this implementation automatically uses the stack's current NSManagedObjectContext as the final argument - anything else wouldn't make sense
 */
-(NSEntityDescription*) entityForClass:(Class) entityClass;

/**
 Shorthand for Apple's hard-to-remember method that creates new CoreData objects:
 
 [NSEntityDescription insertNewObjectForEntityForName: inManagedObjectContext:]
 
 NB: Apple uses an NSString argument; you should never use a string argument! (c.f. top of this file for more details)
 
 ...instead, call this method for an entity named e.g. Entity (Apple's default entity name):
 
 "[stack insertInstanceOfClass:[Entity class]];"
 
 NB: Obviously, this implementation automatically uses the stack's current NSManagedObjectContext as the final argument - anything else wouldn't make sense
 */
-(NSManagedObject*) insertInstanceOfClass:(Class) entityClass;

/**
 Shorthand for Apple's over-complicated, String-based, method that fetches existing CoreData objects:
 
 [NSFetchRequest fetchRequestWithEntityName:]
 
 This returns a fetchRequest that you can then configure with a predicate, sortDescriptors, etc as usual (as per Apple docs).
 
 NB: Apple uses an NSString argument; you should never use a string argument! (c.f. top of this file for more details)
 
 ...instead, call this method for an entity named e.g. Entity (Apple's default entity name):
 
 "[stack fetchRequestForEntity:[Entity class]];"
 
 NB: Obviously, this implementation automatically uses the stack's current NSManagedObjectContext as the final argument - anything else wouldn't make sense
 */
-(NSFetchRequest*) fetchRequestForEntity:(Class) c;

/**
 Shorthand for the most-frequently-used call to CoreData, that fetches a single object from the store.
 
 Ues your predicate to fetch an instance of the specified class.
 
 1. If it finds more than one match (your predicate is wrong), returns nil AND a nil error.
 2. If it hits an error in CoreData, it returns nil, and the error is passed-through from coredata.
 3. Otherwise, it returns the object that matched
 
 This lets you write concise, clear source code, and if you were "expecting" only one object, but you got
 several, you will immediately get a nil - instead of an app that starts corrupting your database by
 writing to the wrong object.
 */
-(NSManagedObject*) fetchOneOrNil:(Class) c predicate:(NSPredicate*) predicate error:(NSError**) error;

/**
 Shorthand to find out "how many objects are there in the database of class X / matching predicate Y?"
 
 Counts how many entities in CD match your predicate
 
 Returns -1 if it gets an error, or the number of matches otherwise
 */
-(int) countEntities:(Class) c matchingPredicate:(NSPredicate*) predicate;

/**
 Delegates to fetchEntities:matchingPredicate:sortedByDescriptors: with a nil sortDescriptors array
 */
-(NSArray*) fetchEntities:(Class) c matchingPredicate:(NSPredicate*) predicate;

/**
 Shorthand for doing arbitrary fetches from CoreData, in a single line of code, with type-safety (c.f. the top of this file for
 info on why Apple's original version is unsafe)
 
 Allows optional array of sort descriptors, to force CoreData to pre-sort the results for you; if you provide "nil" for sortDescriptors,
 it will do the default CoreData sort.
 
 Allows optional predicate, to force CoreData to filter using the predicate; if you provide "nil" for the predicate, it will
 return all entities unfiltered.
 
 Returns all entities of type Class in CD which match your predicate
 */
-(NSArray*) fetchEntities:(Class) c matchingPredicate:(NSPredicate*) predicate sortedByDescriptors:(NSArray*) sortDescriptors;

/*! Deletes all data from your CoreData store - this is a very fast (and allegedly safe) way
 of resetting your data to a "virginal" state, as if your app had just been installed for the
 first time.
 
 It is ALMOST CERTAINLY not safe to call from a multithreaded environment, because nothing in
 Apple's code is threadsafe. But you already knew that, right?
 
 c.f. http://stackoverflow.com/questions/1077810/delete-reset-all-entries-in-core-data
 
 ALSO ... side effect: all NSFetchedResultsController's will explode. As of iOS 5.1, NSFetchedResultsController is
 buggy, and I'd recommend avoid using it if you possibly can. To make this slightly
 less painful, we'll post an NSNotificaiton that you can listen for inside your own NSFetchedResultsController
 subclasses, and re-build your NSFetchedResultsController when you receive one.
 
 [used in several apps live on AppStore already, to workaround the NSFetchedResultsController bugs]
 
 Easy way: use this code as your init method for your NSFetchedResultsController subclass
 
 -(id)initWithCoder:(NSCoder *)aDecoder
 {
 self = [super initWithCoder:aDecoder];
 if (self) {
 // Custom initialization
 
 [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationDestroyAllNSFetchedResultsControllers object:nil queue:nil usingBlock:^(NSNotification *note) {
 NSLog(@"[%@] must destroy my nsfetchedresultscontroller", [self class]);
 [__fetchedResultsController release];
 __fetchedResultsController = nil;
 }];
 }
 return self;
 }
 */
-(void) wipeAllData;

@end
