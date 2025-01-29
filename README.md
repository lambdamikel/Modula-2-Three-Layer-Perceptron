## A Simple Three-Layer Perceptron for MNIST-like Pattern Recognition in Modula II with Pattern Editor, Backpropagation Learning, and Loss Function Visualization 

This was developed in January 1994 using TopSpeed Modula II Version 1.17 for DOS (text mode and VGA graphics). 

At that time, I was taking an introductory AI class at the University of Hamburg (Prof. Peter Schefe, R.I.P.), 
and implemented this as a demonstration of "MNIST"-like pattern recognition using a three-layer perceptron with backpropagation learning for the AI lab class. 

The three-layer perceptron and backpropagation learning algorithm was described in pseudo-code in English in the 
well-known 1991 AI book ["Artificial Intelligence - Rich, E. and Knight, K, 2nd edition, McGraw-Hill".](https://books.google.com/books/about/Artificial_Intelligence.html?id=6P6jPwAACAAJ)

The workflow with this interactive program is as follows: 
1. Determine the topology of the three-layer perceptron, and other hyper-parameters such as the learning rate and the number of training epochs. 
2. Use the pattern editor to create the "training data", i.e., the "MNIST"-like one- or two-dimensional patterns that the perceptron shall recognize. 
3. With the patterns specified, start the backpropagation learning process. The learning process is visualized; i.e., the program graphically shows the
   loss functions over epochs, one for each pattern. The loss function usually convergese quickly for each pattern (100 epochs or so are enough with a learning rate of 1).
   will be visualized (VGA mode). 
4. With the three-layer perceptron being trained, we can now use it at inference time - after training, the program returns to the pattern editor, and we can not
   recall the training patterns and send them to the network; the editor shows the training Y-label and the perceptron computed output label (output layer binarized).
   The predefined patterns can be checked for correct classification, and be easily modified with the editor fed into the perceptron as well. Sometimes, the perceptron
   learned to focus on a few characterstic "bits" in the pattern; it is interesting to remove as many bits as possible from a pattern, and see how the classification
   result changes.

You can find a [DOS executable](m2\NEURONAL.EXE) as well as the TopSpeed Modula II source code [here](m2\NEURONAL.MOD). 

Enjoy! 




