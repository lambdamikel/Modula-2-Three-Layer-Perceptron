## A Simple Three-Layer Perceptron for MNIST-like Pattern Recognition
   in Modula II with Pattern Editor, Backpropagation Learning, and
   Loss Function Visualization

This was developed in January 1994 using TopSpeed Modula II Version
1.17 for DOS (text mode and VGA graphics).

![TopSpeed Modula II a](pics/Capture-1.png)

![TopSpeed Modula II b](pics/Capture-2.png)

### Background

At that time, I was taking an introductory AI class at the University
of Hamburg (Prof. Peter Schefe, R.I.P.), and implemented this as a
demonstration of "MNIST"-like pattern recognition using a three-layer
perceptron with backpropagation learning for the AI lab class.

The three-layer perceptron and backpropagation learning algorithm was
described in pseudo-code in English in the well-known 1991 AI book
["Artificial Intelligence - Rich, E. and Knight, K, 2nd edition,
McGraw-Hill".](https://books.google.com/books/about/Artificial_Intelligence.html?id=6P6jPwAACAAJ)

### Program 

The workflow with this interactive program is as follows: 

1. Determine the topology of the three-layer perceptron, and other
hyper-parameters such as the learning rate and the number of training
epochs.

![Network Topology](pics/Capture-8.png)

2. Use the pattern editor to create the "training data", i.e., the "MNIST"-like one- or two-dimensional patterns that the perceptron shall recognize.

![Training Data Editor 1](pics/Capture-9.png)

![Training Data Editor 2](pics/Capture-10.png)

3. With the patterns specified, start the backpropagation learning
   process. The learning process is visualized; i.e., the program
   graphically shows the loss functions over epochs, one for each
   pattern. The loss function usually convergese quickly for each
   pattern (100 epochs or so are enough with a learning rate of 1).
   will be visualized (VGA mode).

![Loss Function](pics/Capture-11.png)

4. With the three-layer perceptron being trained, we can now use it at
   inference time - after training for the requested number of epochs,
   the program returns to the pattern editor. We can now recall the
   training patterns and send them to the perceptron; the editor shows
   the training Y-label as well as the perceptron computed output
   label (which simply shows the perceptron activiation levels
   binarized via a > 0.5 threshold).

   The predefined patterns can be checked for correct classification, 
   and also be modified with the editor and fed into the perceptron. 


   Sometimes, the perceptron learned to focus on a few characterstic
   "bits" in the patterns; it is interesting to remove as many bits as
   possible from the pattern without changing the classification
   result.  This robustness to noise and drastic changes in the input
   without affecting classification was (and still is) a selling point
   for neural networks.

![Runtime Inference 1](pics/Capture-12.png)

![Runtime Inference 2](pics/Capture-16.png)

![Runtime Inference 3](pics/Capture-18.png)

![Runtime Inference 4](pics/Capture-20.png)

### Source & Executable 

You can find a [DOS executable](m2\NEURONAL.EXE) as well as the
TopSpeed Modula II source code [here](m2\NEURONAL.MOD).

Enjoy! 




