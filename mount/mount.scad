// Feather wig doubler dimensions pulled from here: https://learn.adafruit.com/featherwing-proto-and-doubler/downloads

// All measurements are in mm

mmPerIn = 25.4;

// Feather Wing Dimensions
featherWingDoublerWidth = 2 * mmPerIn;
featherWingDoublerLength = 1.85 * mmPerIn; 
screwHoleCenterFromEdge = 0.1 * mmPerIn;
riserBase = 2 * screwHoleCenterFromEdge;
bodyMargin = 10;
heightMargin = 5;
solderHeight = 4;

// Battery Dimensions
batteryDiameter = 18;
batteryLength = 69;
batteryMargin = 5;

// Screw Dimensions
m3ThreadDiameter = 3.00;
m3InnerThreadDiameter = 2;
m3HeadDiameter = 6.00; 
m3HeadHeight = 3.00;
threadLength = 10;
screwMargin = 2; // Min distance between screws

// Attachment Adaptor Dimensions
attachAdaptorWidth = 20;
attachAdaptorBezzelRad = 2;

// Intermediate calculations 
// NOTE: These should not need to be changed if you're just adjusting the parameters above
plateHeight = threadLength - solderHeight + heightMargin;
plateWidth = max(batteryLength, featherWingDoublerWidth);
plateLength = featherWingDoublerLength + batteryDiameter + 2 * batteryMargin;
minBodyMargin = max(bodyMargin, riserBase/2);

attachAdaptorWidthActual = min(featherWingDoublerWidth - attachAdaptorBezzelRad - 3 * riserBase - 2 * screwMargin, attachAdaptorWidth);
attachAdaptorScrewOffset = (attachAdaptorWidthActual + attachAdaptorBezzelRad)/2 + m3HeadDiameter/2 + abs(screwMargin - attachAdaptorBezzelRad);
// Draw the elements
difference() 
{
    union()
    {
        // Draw the main body
        translate(v = [-plateWidth/2, -plateLength/2, 0])
        {
            minkowski()
            {
                cube([plateWidth, plateLength, plateHeight/2], center = false);
                cylinder(h = plateHeight/2, r = minBodyMargin, center = false, $fn = 360);
            }
        }
        
        // Draw the risers
        for (i = [-(featherWingDoublerWidth/2 - screwHoleCenterFromEdge), (featherWingDoublerWidth/2 - screwHoleCenterFromEdge)])
        {
            for(j = [-(featherWingDoublerLength/2 - screwHoleCenterFromEdge), (featherWingDoublerLength/2 - screwHoleCenterFromEdge)]){
                translate(v = [i, j - batteryDiameter/2 - batteryMargin, plateHeight]) {
                    cylinder(h = solderHeight, r1 = riserBase, r2 = screwHoleCenterFromEdge, center = false, $fn = 360);
                }
            }  
        }
    }
    
    
    // Draw the screw holes
    for (i = [-(featherWingDoublerWidth/2 - screwHoleCenterFromEdge), (featherWingDoublerWidth/2 - screwHoleCenterFromEdge)])
    {
        for(j = [-(featherWingDoublerLength/2 - screwHoleCenterFromEdge), (featherWingDoublerLength/2 - screwHoleCenterFromEdge)]){
            translate(v = [i, j - batteryDiameter/2 - batteryMargin, -0.5]) {
                cylinder(h = plateHeight+solderHeight+1, d = m3InnerThreadDiameter, center = false, $fn = 360);
            }
        }  
    } 
   
    // Draw the attachment adaptor hole
    translate(v = [-(attachAdaptorWidthActual - attachAdaptorBezzelRad)/2, -(attachAdaptorWidthActual - attachAdaptorBezzelRad)/2, -0.5]) 
    {
        minkowski()
        {
            cube([attachAdaptorWidthActual - attachAdaptorBezzelRad, attachAdaptorWidthActual - attachAdaptorBezzelRad, plateHeight/2 + 1], center = false);
            cylinder(h = plateHeight/2 + 1, r = attachAdaptorBezzelRad, center = false, $fn = 360);
        } 
    }
    
    // Draw the attachment adaptor screw holes
    for (i = [-attachAdaptorScrewOffset, attachAdaptorScrewOffset])
    {
        for(j = [-attachAdaptorScrewOffset, attachAdaptorScrewOffset]){
            translate(v = [i, j, -0.5]) {
                cylinder(h = plateHeight+solderHeight+1, d = m3ThreadDiameter, center = false, $fn = 360);
            }
            translate(v = [i, j, plateHeight - m3HeadHeight]) {
                cylinder(h = plateHeight+solderHeight+1, d = m3HeadDiameter, center = false, $fn = 360);
            }
        }  
    } 
}

