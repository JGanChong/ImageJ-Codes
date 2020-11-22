//Tested with Fiji ImageJ version 1.53c, Java 1.8.0_172 (64bits)

//check if user drew line otherwise ask user to draw line (if no 
//Also preselects line tool too so its quickity quick
line then imagej does weird stuff)
setTool("line");
selection=selectionType();
if(selection!=5){
	waitForUser("ERROR","Please draw line");
}

//Get Image Size to calculate Image Center
getDimensions(width, height, channels, slices, frames);

//Calculate the image center
center_x = width/2;
center_y = height/2;

//get coordinates of your line
getLine(x1, y1, x2, y2, lineWidth);

//find the center of your drawn line
xline_center = ((x2-x1)/2)+x1;
yline_center = ((y1-y2)/2)+y2;


//calculate the offset between your ROI's center to the image's center
xoffset = center_x - xline_center;
yoffset = center_y - yline_center;

//Moves image to align ROI's center to image's center
run("Translate...", "x="+xoffset+" y="+yoffset+" interpolation=None");


//get opposite and adjacent side of triangle to calcualte angle
opposite = y1-y2;
adjacent = x2-x1; 


//calculate angle using inverse tangent
toRotate = atan2(opposite,adjacent);

//convert to degrees
toRotate = toRotate*180/3.14;

//finally rotate image to straigthen
run("Rotate... ", "angle="+toRotate+" grid=1 interpolation=Bilinear");
