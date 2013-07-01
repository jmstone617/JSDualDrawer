JSDualDrawer
============

A dual drawer containment view controller similar to Facebook or Path

JSDualDrawer is very simple to use! See the Xcode project for an example. The gist is as follows:

Initialize `JSDualDrawerContainerViewController` using the singleton class method:

    JSDualDrawerViewController *containerVC = [JSDualDrawerViewController sharedDrawerController];

Then, as you would with a `UITabBarController`, initialize your view controllers and add them to the drawer view controller:

```objc
UIViewController *firstVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
UIViewController *secondVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SecondViewController"];

[containerVC addViewControllers:@[firstVC, secondVC]];
```
    
Finally, set the container view controller as the root view controller of the main window:

```objc
[self.window setRootViewController:containerVC];
```

And that's it! Lay out your view controllers in .xibs or a storyboard, and everything else is taken care of for you.

The left drawer is intended to be used for navigation between view controllers. You could very easily replace the left table view with a collection view or some other navigation paradigm.

The right drawer is intended to be used to filter the content in the current view controller.

I will probably continue working on this to make it a little more modular, but I wanted to make sure I got this up for the big Objective-C GitHub day! Enjoy!
