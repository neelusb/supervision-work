# OOP Supo 2 (srns2)

## Questions

### Argument passing

#### Question 23

The first `add` function takes in an array of two integers, and the amount to add to each, while the second one takes in the two integers separately. The difference is that when you pass an integer as an argument into a function, its value is passed so a copy of the integer is created and the original is not changed, while with an array the array itself is passed in and the original array changes.

Therefore, the following occurs: First, `xypair` is initialised to `[1, 1]`. Then the second `add` function is called, so the integers themselves are passed in. The function adds 1 to each, but doesn't have a return value and since the integers were passed in the originals don't change, so `xypair` remains `[1, 1]`, so the print statement prints `1 1`. Then the first `add` function is called, and the array `xypair` is passed in. This adds 1 to each element, and since it's an array the original array is changed, so `xypair` is now `[2, 2]`, so the print statement prints `2 2`.

### Inheritance; Inheriting fields and methods

#### Question 24
Even though a `Vector3D` can be thought of as a `Vector2D` with an extra dimension, but creating `Vector3D` by extending `Vector2D` is conceptually wrong as a 3D Vector isn't a type of 2D Vector. A better approach would be to create a generic `Vector` and have `Vector2D` and `Vector3D` each extend it separately. Furthermore, `Vector2D` may have methods that are programmed for 2 dimensions and these would have to be manually changed to work with 3 dimensions, so the programmer may as well just extend from a generic `Vector` class if they're rewriting these anyway (or even write some of these for a generic number of dimensions within the generic class itself).

#### Question 27

In the table, a tick (✅) means that `Y` can access `value` in `X` and the code therefore compiles, while a cross (❌) means that it cannot and the code will therefore not compile.

|         | `public` | `protected` | `private` | unspecified |
| :-----: | :------: | :---------: | :-------: | :---------: |
| **(a)** |    ✅    |      ✅     |     ❌    |      ✅     |
| **(b)** |    ✅    |      ✅     |     ❌    |      ❌     |
| **(c)** |    ✅    |      ✅     |     ❌    |      ✅     |
| **(d)** |    ✅    |      ❌     |     ❌    |      ❌     |

### Abstract classes and abstract methods; Subtype polymorphism

#### Question 28
In OOP, dynamic polymorphism refers to the concept of an object being able to be of multiple types. For example, if a class `B` extends a class `A`, and `b` is an instance of `B`, then `b` can be used as an object of type `B` and `A`. This is useful because it makes it possible to write generic code for different types of the same class, but also write methods that all of them share, and can therefore all be passed into.

#### Question 29
This could have some benefits. If it doesn't make sense for a specific subclass to have a certain method but it does for the rest of the subclasses of a class, then selective inheritance would be one way of solving this. However, there are more elegant solutions. An easy solution is to throw a runtime error if the subclass that doesn't have the method tries to use it. However this is not ideal. A better solution would be to create an intermediate subclass. For example, say `A` is a class extended by the subclasses `X`, `Y` and `Z`. If `A` has a method that makes sense to implement for `X` and `Y` but not for `Z`, then instead of `X` and `Y` directly extending `A`, a new subclass `B` could extend `A`, implementing the method, and `X` and `Y` could then extend `B`, leaving `Z` to extend `A` as before (or even an intermediate subclass of its own if necessary).

### Interfaces

#### Question 33

A class can have instances created of it, so has all its methods defined. An abstract class, however, has one or more methods that are not defined but just declared, leaving the programmer to define these methods separately for each subclass. Therefore an abstract class cannot have instances. Sometimes a class may need to extend multiple classes. Java does not have a way to do this as it can be ambiguous which class to use a particular method from if it is defined in multiple of them, and that is where interfaces come in. An interface, like an abstract class, has one or more methods that aren't defined, but unlike abstract classes, it cannot have any of its methods defined (i.e. all its methods must be abstract). A class can implement multiple interfaces as since the programmer defines all methods in the class anyway there is no ambiguity about which to use.

### Multiple inheritance

#### Question 36

A class can only extend one class, but it can extend a class and implement interfaces. Therefore, one of these classes can be turned into an interface, and the other class can be extended. For example, say `Employee` has been turned into an interface and `Ninja` remains a class, then `EmployeeNinja` can extend `Ninja` and implement `Employee`. However, this would require reimplementation of every method in `Employee` in each of its subclasses, so it is not ideal.

A better solution could be to create an interface (for example `Person`) that both `Employee` and `Ninja` implement. Then, the class `EmployeeNinja` can also implement `Person`. In methods in `Employee` and `Ninja`, dynamic polymorphism could be implemented by taking `Person` objects as arguments rather than `Employee` or `Ninja`, and then `EmployeeNinja` can be passed into these without problems.

### Object destruction

#### Question 41

The `finally` block is guaranteed to run after a `try-catch` block (even without a `catch`). Where an object needs to be created and used, the code can be wrapped in a `try` block. After this `try` block, a `finally` block can be implemented with code freeing resources (or any other functionality the programmer wishes to have from a destructor). This is guaranteed to run right after the `try` block, i.e. immediately after the object has been used and not an indeterminate amount of time later.

#### Question 42

Java guarantees that a `finally` block will be run after a `try-catch` block, so even though the `try` block is returning a value, the `finally` block still runs. However, once a function returns a value it can no longer do anything else. Therefore, before the 6 is returned, whatever is in the `finally` block is first run, and then the 6 is returned.

## Chime tasks

### Fibonacci
Repo: https://chime.cl.cam.ac.uk/page/repos/srns2/fibonacci

Part 1: https://chime.cl.cam.ac.uk/page/repos/srns2/fibonacci/code/e9e16a426869e570edbc754b0ddcb2675d43dfa0
Part 2: https://chime.cl.cam.ac.uk/page/repos/srns2/fibonacci/code/dafc2b19dbd6ac6ef2f9ae65a1af8db9876939dd

### Matrices
Repo: https://chime.cl.cam.ac.uk/page/repos/srns2/matrices

Part 1: https://chime.cl.cam.ac.uk/page/repos/srns2/matrices/code/5e6d4287374e1fd38512996bbabe62deffdf08ba
Part 2: https://chime.cl.cam.ac.uk/page/repos/srns2/matrices/code/a59998ae8849bea942c777d1874096d2254d5bef

### Sorting
*QuickSort and InsertionSort implemented, MergeSort not yet implemented*

Repo: https://chime.cl.cam.ac.uk/page/repos/srns2/sorting

Code: https://chime.cl.cam.ac.uk/page/repos/srns2/sorting/code

### Chess

Repo: https://chime.cl.cam.ac.uk/page/repos/srns2/chess

Code: https://chime.cl.cam.ac.uk/page/repos/srns2/chess/code
