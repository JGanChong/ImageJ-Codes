/*
 * Instructions: 
 * Change the desired measurement by changing "Length" with any of the other options in line 15 after measurement_value = 
 * Open your image. Run the macro.
 * Set the number of total columns desired
 * Give a name to all the columns. Its better to not include spaces in the title
 * Start measuring. Use a linetool to measure. Once done, press "ok" to add to the column.
 * To add a custom value, type it in the custom value area. Typing something in the custom value box will overwrite any current selection measurement.
 * Check the "stop" box when you are done and press "ok" to exit.
 * Macro by Johnny Gan johnny.gan@berkeley.edu
 * 
 */

 
measurement_value = "Length"; 
//Can be any of the following: "Area", "Mean", "StdDev", "Mode", "Min", "Max", "X", "Y", "XM", 
//"YM", "Perim.", "BX", "BY", "Width", "Height", "Major", "Minor", "Angle", "Circ.", "Feret", "IntDen", 
//"Median", "Skew", "Kurt", "%Area", "RawIntDen", "Ch", "Slice", "Frame", "FeretX", "FeretY", 
//"FeretAngle", "MinFeret", "AR", "Round", "Solidity", "MinThr", "MaxThr" or "Length"


Dialog.create("Settings");
Dialog.addNumber("total columns", 1);
Dialog.show(); 

columns = Dialog.getNumber();
columns_array = newArray(columns);

Table.create("measurements");
for (i = 1; i <= columns; i++) {
	Dialog.create("Settings");
	Dialog.addString("Column_"+i+"_name", "Column_"+i);
	Dialog.show(); 
	name = Dialog.getString();
	Table.setColumn(name);
	columns_array[i-1] = name;
}

stop = 0;
rowIndex = 0;

while (stop == false) {
	
	for (i = 0; i < columns; i++) {
		run("Select None");
		Dialog.createNonBlocking("Settings");
		Dialog.addString("custom_text","");
		Dialog.addCheckbox("stop_program", false);
		Dialog.show();
		
		customtext = Dialog.getString();
		stop = Dialog.getCheckbox();
		if (stop == true) {
			exit;
		}
		if (customtext.length==0) {
			value = getValue(measurement_value);
			Table.set(columns_array[i], rowIndex, value);
			Table.update;
		}
		else {
			Table.set(columns_array[i], rowIndex, customtext);
			Table.update;
		}
	}
	rowIndex = rowIndex + 1;


}
