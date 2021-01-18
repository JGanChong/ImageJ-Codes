/*  Merges RGB images from different focus planes into a single image with all planes in focus.
 *  Filters and segment images and provides a count of Foci 
 *  
 *  Macro instruction: Close all images and open only to be merged (different planes). Make sure they are not stacks.
 *  Change settings as desired. Run macro. Afterwards, the ROI manager will pop with all ROIs. Verify the result and either change settings or add/delete rois as needed.
 *  
 * Macro tested with ImageJ 1.53g, Java 1.8.0_172 (64bit) Windows 10
 * Macro by Johnny Gan Chong email:behappyftw@g.ucla.edu 
 * January 2021
 */



//User Variables
Min_Particle_Size = 200; //minimum size of object 
rolling_ball_radius = 50; //Rollingball radius
unsharp_radius = 80 //unsharp mask radius
unsharp_amount = 0.8 //unsharp mask amount
Mean_FLT_radius = 5; //radius for Mean Filter
channel = 2; //1=red 2=green 3= blue. RGB stack channel to process

//Create result table
ResTable = "Counter Results";
isTable = isOpen(ResTable);
if (isTable == false) {
	Table.create(ResTable);
}


//Set macro options
roiManager("reset");
run("ROI Manager...");
setBatchMode(true);
setOption("BlackBackground", true);


//Get list of open images
open_images = getList("image.titles");
noStackImg = " ";

//Get list of all non stack images
for (i = 0; i < open_images.length; i++) {
	selectImage(open_images[i]);
	isStack = getSliceNumber();
	if (isStack==1) {
		noStackImg = noStackImg + open_images[i]+", ";
	}
}

//merge all planes into 1 stack
run("Images to Stack", "name=Stack title=[] use");
//convert to RGB
run("RGB Stack");
//take only the green channe;
run("Duplicate...", "duplicate channels="+channel);


//filter image
run("Unsharp Mask...", "radius="+unsharp_radius+" mask="+unsharp_amount+" stack");
run("Subtract Background...", "rolling="+rolling_ball_radius+" stack");
run("Subtract Background...", "rolling="+rolling_ball_radius+" stack");
run("Mean...", "radius="+Mean_FLT_radius+" stack");

//merge planes to single image and enhance
run("Z Project...", "projection=[Max Intensity]");
run("Unsharp Mask...", "radius="+unsharp_radius+" mask="+unsharp_amount+" stack");

//segment image
run("Auto Threshold", "method=Yen white");
run("Watershed");


//Analyze image to get ROIs and counts
run("Analyze Particles...", "size="+Min_Particle_Size+"-Infinity add");


//Set results
totalROI=roiManager("count");
rows = Table.size(ResTable);
Table.set("Cells", rows, noStackImg,ResTable);
Table.set("Count", rows, totalROI,ResTable);
Table.update;

//Present filtered single plane image to user with ROIs
selectImage("Stack-1");
run("Z Project...", "projection=[Max Intensity]");
close("\\Others");
setBatchMode("exit and display");
run("ROI Manager...");
roiManager("Show All with labels");


