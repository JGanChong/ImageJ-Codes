/*
 * Instructions: Open your image. Run the macro
 * Macro by Johnny Gan johnny.gan@berkeley.edu
 * 
 */

//Resets and establish minimal settings
roiManager("reset");
run("Options...", "iterations=1 count=1 black do=Nothing");



//Process Image first
run("8-bit");
setForegroundColor(255, 255, 255);
run("Invert");

//Threshold image
run("Auto Threshold", "method=Otsu white");
//Analyze image
run("Analyze Particles...", "add");
total = roiManager("count");
addx = 0;
addy = 0;

//Get coordinates of the ROIs
for (i = 0; i < total; i++) {
	roiManager("deselect");
	roiManager("select", i);
	Roi.getBounds(x, y, width, height);
	addx = addx+x;
	addy = addy+y;
	
	
}

//Get dimensions of image and creates a pseudo squared image
getDimensions(width, height, channels, slices, frames);
if (width>height) {
	box=height*1.5;
}
else {
	box=width*1.5;
}
newImage("square", "8-bit black", box, box, 1);
//Rearranges ROIs in new image
newx=box*0.03;
newy=box*0.03;
maxy = 0;
for (i = 0; i < total; i++) {
	roiManager("deselect");
	roiManager("select", i);
	Roi.getBounds(boundx, boundy, boundwidth, boundheight);
	newx_check =  boundwidth + newx;
	if (newx_check <= box ) {
		Roi.move(newx, newy);
		newx =  boundwidth + newx + (box*0.03);
		if(boundheight>maxy){
			maxy=boundheight+maxy;
		}
	}

	else {
		newx = 0;
		newy=newy+maxy;
		if (newy>box) {
			newy = maxy;
		}
		Roi.move(newx, newy);
		newx =  boundwidth + newx + (box*0.03);
	}
	
	roiManager("Show All");
	
	
}
//Wait for user to rearrange the images
waitForUser("Press on the number of each ROI and move them to desired location. Keep them far apart form each other and from the borders. Once done press OK");

for (i = 0; i < total; i++) {
	roiManager("select", i);
	setForegroundColor(255,255,255);
	run("Fill", "slice");
	
}
run("Select None");
roiManager("reset");
selectImage("square");
//Rescale image to 100x100
run("Scale...", "x=- y=- width=100 height=100 interpolation=None create");

run("Analyze Particles...", "add");

run("Select None");
run("Dilate");
run("RGB Color");
run("Select None");
changeValues(0xffffff, 0xffffff, 0xff0000);

run("Select None");
total = roiManager("count");
setForegroundColor(255,255,255);
for (i = 0; i < total; i++) {
	roiManager("select", i);
	run("Fill", "slice");	
}


run("Select None");
roiManager("reset");


