//Tested with with ImageJ/FIJI 1.53c, Java 1.8.0_172 (64bit), IJ Macro
//Get File Name
name = getTitle();

//Get image height and width to find ceneter
imageheight = getHeight();
imagewidth= getWidth();

//Convert and threshold image
run("8-bit");
run("Auto Threshold", "method=Otsu");

//Select only the middle down
makeRectangle((imagewidth/2)-10,imageheight/2,10,imageheight/2);
run("Crop");
roiManager("deselect");
roiManager("delete");

//Get ROI
run("Analyze Particles...", "size=3000-Infinity add");
roiManager("Select", 0);

//Measure height of ROI
Roi.getBounds(x, y, width, height);
roiManager("deselect");

//Put in result table
row = nResults;
setResult("Image", row, name);
setResult("Height_pixels", row, height);
updateResults();
close("*");
