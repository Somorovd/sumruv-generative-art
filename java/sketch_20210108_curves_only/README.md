# 20210108 Genuary Day 08 - "Curves Only"
## Process
1. For some number of rows, split the width of canvas into random sizes sections. Each section gets a control point alternating up and down. These points will be smoothed out to form a curve later. 
2. Between each row, create secondary rows whose points interpolate the primary row points.
3. Use Chaikin smoothing to create a curve between the points of the secondary rows.
4. Calculate an even spacing of points along the Chaikin curve.

## Images
![CurvesOnly202118204035](https://github.com/Somorovd/sumruv-generative-art/assets/18534469/0431974f-01ab-4f52-8553-82a04f4ab99a)

![CurvesOnly202118204139](https://github.com/Somorovd/sumruv-generative-art/assets/18534469/8b83e523-6194-49be-bcce-8629768daca3)
![CurvesOnly202392513830](https://github.com/Somorovd/sumruv-generative-art/assets/18534469/d8401d53-ef01-47c4-9558-8e2d1c93a855)
