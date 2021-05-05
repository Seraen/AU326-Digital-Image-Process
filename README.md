# AU326-digital-image-process
Materials and problem sets for Digital Image Process in SJTU.


problem set 01
==========
Question 1 to 6 
---
Shown as execises in reference books.

question 7
----
Develop a program to calculate histogram and make histogram equalization for given images. Test the program on suitable images.Display histogram plots of the original and equalized images. (Both code and result report are required.)


* Codes are in `/problem_set/01/7`.


* Here `set7.m` uses inserted functions in Matlab.


* `set7myself.m` implements my own functions to calculate histogram and make histogram equalization mainly depending on scientific concepts.



question 8
----
Add different levels of Gaussian noises to a given image, observe the change of corresponding histograms (based on the program you developed above). And then process the Gaussian noise polluted images using your designed kernels to achieve desired effect. (Both code and result report are required.)



* Codes are in `/problem_set/01/8`.


* Here `set8.m` uses inserted functions in Matlab.


* `myGaussianNoise.m` and `myGaussianFilter.m` implement my own functions to add Gaussian noise to the image and Filter on the polluted images. `processFile.m` call functions and present the results.



