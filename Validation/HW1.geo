// Gmsh project created on Mon Feb 03 12:05:54 2020
H = 0.1; //m
W = 0.1; //m
lc_fine = 0.025;
lc_coarse = 0.10;
fetch = 15*H;
wake = 15*H;
lateral = 15*H;
top = 5*H;

nx = 3; //Buildings in x direction per block
ny = 3; //Buildings in y direction per block
nbx = 2; //No of blocks in x direction
nby = 2; //No of blocks in y direction

//Outer bounds
Point(1) = {0, 0, 0, lc_coarse};
Point(2) = {fetch+nbx*nx*2*W+wake,0,0,lc_coarse};
Point(3) = {fetch+nbx*nx*2*W+wake,lateral+nby*ny*2*W+lateral,0,lc_coarse};
Point(4) = {0,lateral+nby*ny*2*W+lateral,0,lc_coarse};
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};


//Define buildings
np = newp;
nl = newl;
nl0 = nl; //Contains first line of first building of the first block (bottom left)

For ii In {1:nbx}
	For jj In {1:nby}
		x0 = fetch+(ii-1)*(2*nx)*W;
		y0 = lateral+(jj-1)*(2*ny)*W;

		For i In {1:nx}
			For j In {1:ny}
				Point(np) = {x0+(i-1)*2*W,y0+(j-1)*2*W,0,lc_fine}; np0 = np;
				np = np+1;
				
				Point(np) = {x0+(i-1)*2*W+W,y0+(j-1)*2*W,0,lc_fine};
				Line(nl) = {np-1,np};
				nl = nl+1;
				np = np+1;
				
				Point(np) = {x0+(i-1)*2*W+W,y0+(j-1)*2*W+W,0,lc_fine};
				Line(nl) = {np-1,np};
				nl = nl+1;
				np = np+1;
				
				Point(np) = {x0+(i-1)*2*W,y0+(j-1)*2*W+W,0,lc_fine};
				Line(nl) = {np-1,np};
				nl = nl+1;
				
				Line(nl) = {np,np0};
				nl = nl+1;
				np=np+1;
			EndFor
		EndFor
	EndFor
EndFor

//Define blocks
offset = 0.5*W;
x0 = fetch;
y0 = lateral;
np = newp; 
np0 = np; //Contains bottom left vertex of city (NOT origin!)
nl = newl;
nlblock0 = nl; //Contains first line of first block (SW corner)

For ii In {1:nbx+1}
	For jj In {1:nby+1}
		Point(np) = {x0+(ii-1)*(2*nx)*W-offset,y0+(jj-1)*(2*ny)*W-offset,0,lc_fine};
		np = np+1;
	EndFor
EndFor

For ii In {1:nbx}
	For jj In {1:nby}
		If(ii==1 && jj==1) //Bottom left block needs special handling
			Line(nl) = {np0,np0+(nby+1)};
			nl = nl+1;
			
			Line(nl) = {np0+(nby+1),np0+(nby+1)+1};
			nl = nl+1;
			
			Line(nl) = {np0+(nby+1)+1,np0+1};
			nl = nl+1;
			
			Line(nl) = {np0+1,np0};
			nl = nl+1;
		ElseIf(ii==1) //Fill first column
			np0block = np0+(jj-1);
			
			Line(nl) = {np0block+(nby+1),np0block+(nby+1)+1};
			nl = nl+1;
			
			Line(nl) = {np0block+(nby+1)+1,np0block+1};
			nl = nl+1;
			
			Line(nl) = {np0block+1,np0block};
			nl = nl+1;
		ElseIf(jj==1)
			np0block = np0 + (ii-1)*(nby+1);
			
			Line(nl) = {np0block,np0block+(nby+1)};
			nl = nl+1;
			
			Line(nl) = {np0block+(nby+1),np0block+(nby+1)+1};
			nl = nl+1;
			
			Line(nl) = {np0block+(nby+1)+1,np0block+1};
			nl = nl+1;
		Else
			np0block = np0 + (ii-1)*(nby+1) + (jj-1);
			
			Line(nl) = {np0block+(nby+1),np0block+(nby+1)+1};
			nl = nl+1;
			
			Line(nl) = {np0block+(nby+1)+1,np0block+1};
			nl = nl+1;
		EndIf
	EndFor
EndFor

/*From this point on, doing it manually was faster than coding it! Code works for any combination of nbx, nby, nx, and ny up to this point. After this point, it's designed for the 2x2x3x3 case.*/
//Define surfaces
//Roads
Line Loop(1) = {151, 152, 149, 150};
Line Loop(2) = {5, 6, 7, 8};
Line Loop(3) = {17, 18, 19, 20};
Line Loop(4) = {29, 30, 31, 32};
Line Loop(5) = {33, 34, 35, 36};
Line Loop(6) = {21, 22, 23, 24};
Line Loop(7) = {9, 10, 11, 12};
Line Loop(8) = {37, 38, 39, 40};
Line Loop(9) = {25, 26, 27, 28};
Line Loop(10) = {13, 14, 15, 16};
Plane Surface(1) = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
Line Loop(11) = {151, -155, -154, -153};
Line Loop(12) = {42, 43, 44, 41};
Line Loop(13) = {54, 55, 56, 53};
Line Loop(14) = {66, 67, 68, 65};
Line Loop(15) = {70, 71, 72, 69};
Line Loop(16) = {58, 59, 60, 57};
Line Loop(17) = {46, 47, 48, 45};
Line Loop(18) = {74, 75, 76, 73};
Line Loop(19) = {62, 63, 64, 61};
Line Loop(20) = {50, 51, 52, 49};
Plane Surface(2) = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20};
Line Loop(21) = {156, 157, 158, -150};
Line Loop(22) = {79, 80, 77, 78};
Line Loop(23) = {91, 92, 89, 90};
Line Loop(24) = {103, 104, 101, 102};
Line Loop(25) = {105, 106, 107, 108};
Line Loop(26) = {93, 94, 95, 96};
Line Loop(27) = {81, 82, 83, 84};
Line Loop(28) = {109, 110, 111, 112};
Line Loop(29) = {97, 98, 99, 100};
Line Loop(30) = {85, 86, 87, 88};
Plane Surface(3) = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30};
Line Loop(31) = {158, 153, -160, -159};
Line Loop(32) = {113, 114, 115, 116};
Line Loop(33) = {125, 126, 127, 128};
Line Loop(34) = {137, 138, 139, 140};
Line Loop(35) = {141, 142, 143, 144};
Line Loop(36) = {129, 130, 131, 132};
Line Loop(37) = {117, 118, 119, 120};
Line Loop(38) = {145, 146, 147, 148};
Line Loop(39) = {133, 134, 135, 136};
Line Loop(40) = {121, 122, 123, 124};
Plane Surface(4) = {31, 32, 33, 34, 35, 36, 37, 38, 39, 40};

//Outer
Line Loop(41) = {4, 1, 2, 3};
Line Loop(42) = {149, 156, 157, 159, 160, 154, 155, 152};
Plane Surface(5) = {41, 42};

Recombine Surface "*";

//Label horizontal surfaces
Physical Surface("SWroads") = {1};
Physical Surface("NWroads") = {2};
Physical Surface("NEroads") = {4};
Physical Surface("SEroads") = {3};
Physical Surface("outer") = {5};

//Create boundary layer near walls
Field[1] = BoundaryLayer;
Field[1].EdgesList = {5:40, 41:76, 77:112, 113:148};
Field[1].hfar = lc_fine;
Field[1].hwall_n = lc_fine/2.0;
Field[1].thickness = lc_fine/1.0;
Field[1].ratio = 1.1;
Field[1].Quads = 1;

BoundaryLayer Field = 1;
Mesh.CharacteristicLengthFromCurvature = 1;

//First extrude to top of buildings
n = 20; //Numbers of intervals
r = 1.1; //Progression ratio
a = (r - 1) / (r^n - 1);

one[0] = 1;
layer[0] = a;

For i In {1:n-1}
   one[i] = 1;
   layer[i] = layer[i-1] + a * r^i;
EndFor

Extrude{0,0,H}{
	Surface{1:5}; Layers{one[], layer[]}; Recombine;
}

//Label walls
Physical Surface("SWwalls") = {221:361:4};
Physical Surface("NWwalls") = {423:563:4};
Physical Surface("NEwalls") = {827:967:4};
Physical Surface("SEwalls") = {625:765:4};

//Create and define roofs
Line Loop(43) = {168, 169, 166, 167};
Surface(1031) = {43};
Line Loop(44) = {173, 170, 171, 172};
Surface(1032) = {44};
Line Loop(45) = {177, 174, 175, 176};
Surface(1033) = {45};
Line Loop(46) = {186, 187, 188, 189};
Surface(1034) = {46};
Line Loop(47) = {182, 183, 184, 185};
Surface(1035) = {47};
Line Loop(48) = {178, 179, 180, 181};
Surface(1036) = {48};
Line Loop(49) = {193, 190, 191, 192};
Surface(1037) = {49};
Line Loop(50) = {197, 194, 195, 196};
Surface(1038) = {50};
Line Loop(51) = {201, 198, 199, 200};
Surface(1039) = {51};

Physical Surface("SWroofs") = {1031:1039};

Line Loop(52) = {368, 369, 370, 371};
Surface(1040) = {52};
Line Loop(53) = {372, 373, 374, 375};
Surface(1041) = {53};
Line Loop(54) = {376, 377, 378, 379};
Surface(1042) = {54};
Line Loop(55) = {380, 381, 382, 383};
Surface(1043) = {55};
Line Loop(56) = {384, 385, 386, 387};
Surface(1044) = {56};
Line Loop(57) = {388, 389, 390, 391};
Surface(1045) = {57};
Line Loop(58) = {392, 393, 394, 395};
Surface(1046) = {58};
Line Loop(59) = {396, 397, 398, 399};
Surface(1047) = {59};
Line Loop(60) = {400, 401, 402, 403};
Surface(1048) = {60};

Physical Surface("NWroofs") = {1040:1048};

Line Loop(61) = {775, 772, 773, 774};
Surface(1049) = {61};
Line Loop(62) = {779, 776, 777, 778};
Surface(1050) = {62};
Line Loop(63) = {783, 780, 781, 782};
Surface(1051) = {63};
Line Loop(64) = {787, 784, 785, 786};
Surface(1052) = {64};
Line Loop(65) = {791, 788, 789, 790};
Surface(1053) = {65};
Line Loop(66) = {795, 792, 793, 794};
Surface(1054) = {66};
Line Loop(67) = {799, 796, 797, 798};
Surface(1055) = {67};
Line Loop(68) = {803, 800, 801, 802};
Surface(1056) = {68};
Line Loop(69) = {807, 804, 805, 806};
Surface(1057) = {69};

Physical Surface("NEroofs") = {1049:1057};

Line Loop(70) = {571, 572, 573, 570};
Surface(1058) = {70};
Line Loop(71) = {575, 576, 577, 574};
Surface(1059) = {71};
Line Loop(72) = {579, 580, 581, 578};
Surface(1060) = {72};
Line Loop(73) = {585, 582, 583, 584};
Surface(1061) = {73};
Line Loop(74) = {589, 586, 587, 588};
Surface(1062) = {74};
Line Loop(75) = {593, 590, 591, 592};
Surface(1063) = {75};
Line Loop(76) = {597, 594, 595, 596};
Surface(1064) = {76};
Line Loop(77) = {601, 598, 599, 600};
Surface(1065) = {77};
Line Loop(78) = {605, 602, 603, 604};
Surface(1066) = {78};

Physical Surface("SEroofs") = {1058:1066};
Recombine Surface{1031:1066};

//Extrude to atmosphere
n = 20; //Numbers of intervals
r = 1.2; //Progression ratio
a = (r - 1) / (r^n - 1);

one[0] = 1;
layer[0] = a;

For i In {1:n-1}
   one[i] = 1;
   layer[i] = layer[i-1] + a * r^i;
EndFor

Extrude{0,0,top}{
	Surface{1031:1066,1030,766,362,564,968}; Layers{one[], layer[]}; Recombine;
}

//Label surfaces
Physical Surface("west") = {1875, 985};
Physical Surface("north") = {1887, 997};
Physical Surface("east") = {1883, 993};
Physical Surface("south") = {1879, 989};
Physical Surface("atmosphere") = {1088, 1110, 1132, 1198, 1176, 1154, 1220, 1242, 1264, 1330, 1308, 1286, 1352, 1374, 1396, 1418, 1440, 1462, 1682, 1704, 1726, 1748, 1770, 1792, 1814, 1836, 1858, 1528, 1506, 1484, 1550, 1572, 1594, 1616, 1638, 1660, 2324, 2122, 2728, 2526, 1920};
Physical Volume("internal") = Volume "*";

//np = newp;
//Point(np) = {1.85,2.15,0,lc_fine};