# Drawing Overlaps

This was one of my early ventures into overlapping shapes. There are two questions to ask on this topic: Where are my shapes overlapping? How many shapes overlap on my pixels?
One way of answering these questions is to encode all the information in the pixels themselves. I did this by drawing all my shapes with an opacity on 1. When two shapes overlap,
the section of overlap has opacity of 2. Three, opacity 3, and so on.

# Process

1. If the mouse is pressed:
   a. Record the current mouse position
   b. Draw a line from the previous position.
2. If the mouse is not pressed:
   a. Erase everything
   b. Save the points as a new shape
   c. Draw all shapes in opacity 1
   d. Use opacity value of the pixels to determine number of layers and color accordingly.

# Images
