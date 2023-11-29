# Drawing Overlaps

This was one of my early ventures into overlapping shapes. There are two questions to ask on this topic: <br>
1. Where are my shapes overlapping? <br>
2. How many shapes overlap on my pixels?<br>

One way of answering these questions is to encode all the information in the pixels themselves. I did this by drawing all my shapes with an opacity on 1. When two shapes overlap, the section of overlap has opacity of 2. Three, opacity 3, and so on.

# Process

1. If the mouse is pressed:<br>
   a. Record the current mouse position<br>
   b. Draw a line from the previous position<br>
2. If the mouse is not pressed:<br>
   a. Erase everything<br>
   b. Save the points as a new shape<br>
   c. Draw all shapes in opacity 1<br>
   d. Use opacity value of the pixels to determine number of layers and color accordingly<br>

# Images
![image](https://github.com/Somorovd/sumruv-generative-art/assets/18534469/9735f8d2-65a5-46aa-92ef-1f5cd67e5726)
