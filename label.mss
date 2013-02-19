
///////////////////////////////////////////////////
// Dymo pre-placed names
///////////////////////////////////////////////////

#labels-z4[zoom=4],
#labels-z5[zoom=5],
#labels-z6[zoom=6],
#labels-z7[zoom=7],
#labels-z8[zoom=8],
#labels-z9[zoom=9],
#labels-z10[zoom=10],
{
  //::DEBUG { polygon-opacity:0.5; polygon-fill: orange; }
  text-clip: false;
  //[capital="yes"] { text-face-name: @label-font-heavy; }
  text-face-name: @label-font;
  text-allow-overlap: true;
  text-name: "[name]";
  text-fill: @label-color;
  text-halo-fill: @land-color;
  text-halo-radius: 0 + @smart-halo-raidus;
  text-placement: interior;
  [font_size=18] { text-size: 18; }
  [font_size=24] { text-size: 22; }
  [font_size=32] { text-size: 30; }
}

#places-z4[zoom=4],
#places-z5[zoom=5],
#places-z6[zoom=6],
#places-z7[zoom=7],
#places-z8[zoom=8],
#places-z9[zoom=9],
#places-z10[zoom=10],
{
  [point_size=5] { marker-width: 5+@smart-halo-raidus; }
  [point_size=7] { marker-width: 6+@smart-halo-raidus; }
  marker-fill:@label-color;
  marker-line-color: @land-color;
  marker-line-width: @smart-halo-raidus;
}


///////////////////////////////////////////////////
// Normal place names
///////////////////////////////////////////////////


#places-all[zoom<17] {
  
  ::label {
    text-face-name: @road-font;
    text-name: "";
    text-fill: @label-color;
    text-halo-fill: @land-color;
    text-halo-radius: 0 + @smart-halo-raidus;
    text-line-spacing: -3;
    text-min-distance: 5;

 //   text-placement: point;
    text-size: 10;
    text-min-distance: 8;
    [type<2] {
      text-placement-type: simple;
      text-dx: 8;
      text-dy: 8;
      text-placements: 'N,S,E,W,NE,14,12';    
    }
    
    [type>=2][type<3] {
      text-placement-type: simple;
      text-dx: 7;
      text-dy: 7;
      text-placements: 'N,S,E,W,NE,14,12';    
    }
//    text-allow-overlap: true;
    //  text-spacing: 16;
    [type=0] {
    	[zoom=4],
        [zoom=5]
        {
	      	text-name: "[abbr]";
    		text-size: 18;
      	}
        [zoom>5][zoom<=11] {
      		text-name: "[name]";
        	text-size: 22;
      	}
        [zoom>11] {
      		text-name: "[name]";
        	text-size: 24;
      	}
    }
    [type=1] {
    	[zoom=4][population>750],
        [zoom=5]
        {
      		text-name: "[abbr]";
        	text-size: 16;
      	}
        [zoom>5][zoom<=11] {
      		text-name: "[name]";
        	text-size: 18;
      	}
      	[zoom>11] {
      		text-name: "[name]";
        	text-size: 22;
      	}
    }
    
    [type=2] {
    	[population>500][zoom=6],
        [population>120][zoom=7],
        [zoom>7][zoom<=11]
        {
      		text-name: "[name]";
        	text-size: 14;
      	}
      	[zoom>11]
        {
      		text-name: "[name]";
        	text-size: 18;
      	}
    }
    
    [type=3] {
    	[population>60][zoom=8],
        [zoom>8][zoom<=11]
        {
        	text-name: "[name]";
        	text-size: 12;
      	}
        [zoom>11]
        {
      		text-name: "[name]";
        	text-size: 16;
      	}
    }
  }
  

  ::marker{
    [type=0][zoom>=4],
    [type=1][zoom=4][population>750],
    [type=1][zoom>=5],    
    [type=2][population>500][zoom=6],
    [type=2][population>120][zoom=7],
    [type=2][zoom>7],  
    {
		[type=0] { marker-width: 6+@smart-halo-raidus; }
		[type=1] { marker-width: 5+@smart-halo-raidus; }     
		[type=2] { marker-width: 4+@smart-halo-raidus; }      
  
      	marker-fill:@label-color;
      	marker-line-color: @land-color;
      	marker-line-width: @smart-halo-raidus;
//      	marker-spacing: 8;
//      	marker-allow-overlap: true;
		marker-ignore-placement: true;
    }
  }
  
  
}



///////////////////////////////////////////////////
// Landusage
///////////////////////////////////////////////////

#landusage-label[zoom>6] {
  text-clip: false; 
  text-face-name: @label-font-alt;
  text-allow-overlap: false;
  text-name: "";
  text-fill: @label-color-alt;
  text-halo-fill: @land-color;
  text-halo-radius: @smart-halo-raidus;
  text-wrap-width: 60;
  text-placement: point;
  text-size: 12;
  text-min-distance: 10;
  
  [zoom>=16] {text-size: 14;}
  //// Render control
  
  [type='nature_reserve'],
  [type='park'], 
  [type='conservation'],
  [type='military'],     
  {
    [zoom=9][priority<1],
    [zoom=10][priority<1]  
    {
  		text-name: "[name]";
    }
  }
  [type='nature_reserve'],
  [type='park'],    
  [type='conservation'],
  [type='military'],    
  [type='aerodrome'],
  [type='railway'],
  [type='water'],    
  [type='salt_pond'],
  {
	[zoom=11][priority<1],
  	[zoom=12][priority<2],
    [zoom=13][priority<2],
    [zoom=14][priority<3],
    {
  		text-name: "[name]";
    }
  }
  [type='nature_reserve'],
  [type='aerodrome'],
  [type='park'],
  [type='conservation'],
  [type='military'],    
  [type='hospital'],
  [type='university'],
  [type='railway'],
  [type='cemetery'],
  [type='water'],
  [type='pond'],
  {
    
    [zoom=15][priority<3],
    {
  		text-name: "[name]";
    }
  }
  [zoom=16],
  [zoom>=17],
  {
  	text-name: "[name]";
  }
  
  //// Color control
  
  [type='forest'], [type='grass'], [type='wood'], [type='wetland'],
  [type='golf_course'], [type='conservation'],
  [type='park'], [type='nature_reserve'] {
   	text-fill: desaturate(darken(@green-color, 40%), 5%);
  }

  [type='hospital'] {
  	text-fill: saturate(darken(@healthcare-color, 45%), 40%);
  }

  [type='reservoir'], [type='water'], [type='pond'], [type='salt_water'] {
    text-fill: @ferry-color;
  }
  
  [type='aerodrome'], [type='university'], [type='railway'],
  {
    text-fill: @label-color;
  }
  
  //// Marker

  [type='aerodrome'] {
    [zoom=9][priority<1],
    [zoom=10][priority<1],
	[zoom=11][priority<1],
  	[zoom=12][priority<1],
    [zoom=13][priority<2],
    [zoom>=14]
    {
      ::marker {
        marker-placement: point;
        marker-width: 12;
        marker-height: 12;           
		marker-fill: @label-color;
        marker-file: url("marker/airport.svg");
      }
	  text-placement-type: simple;
      text-dx: 12;
      text-dy: 12;
      text-placements: 'S,E,W,N';
    }  
  }
  [type='railway'] {
	[zoom=11][priority<1],
  	[zoom=12][priority<1],
    [zoom=13][priority<2],
    [zoom=14][priority<3],
    [zoom=15][priority<3],
    [zoom>=16]
    {
      ::marker {
        marker-placement: point;
        marker-width: 8;
        marker-height: 8;           
		marker-fill: @label-color;
        marker-file: url("marker/rail.svg");
      }
      text-dy: 8;
    }

  }
  [type='hospital'] {
    [zoom=15][priority<5],
    [zoom=16],
    [zoom>=17],   
    {
      ::marker {
        marker-placement: point;
        marker-width: 8;
        marker-height: 8;        
        marker-file: url("marker/hospital.svg");
		marker-fill: saturate(darken(@healthcare-color, 40%), 40%);        
      }
      text-dy: 7;
    }  
  }
  [type='university'],[type='college'] {
    [zoom=15][priority<4],
    [zoom=16],
    [zoom>=17],   
    {
      ::marker {
        marker-placement: point;
        marker-width: 11;
        marker-height: 11;        
        marker-file: url("marker/college.svg");
		marker-fill: @label-color;
      }
      text-dy: 12;
    }  
  }  
 [type='school'],[type='highschool'] {
 	[zoom=15][priority<4],
    [zoom=16][priority<5],
    [zoom>=17],    
    {
      ::marker {
        marker-placement: point;
        marker-width: 11;
        marker-height: 11;        
        marker-file: url("marker/school.svg");
		marker-fill: @label-color;
      }
      text-dy: 10;
    }  
  } 
  
  [type='nature_reserve'],[type='conservation'],[type='park'] {
    [zoom=6][priority<1],
    [zoom=7][priority<1],
    [zoom=8][priority<1],
    [zoom=9][priority<1],
    [zoom=10][priority<1],
	[zoom=11][priority<1],
  	[zoom=12][priority<2],
    [zoom=13][priority<2],
    [zoom=14][priority<4],
    [zoom=15][priority<4],
    [zoom=16][priority<5],
    [zoom>=17],
    {
      ::marker {
        marker-placement: point;
        marker-file: url("marker/tree-1.svg");
        marker-width: 9;
        marker-height: 10;
     	marker-fill: desaturate(darken(@green-color, 40%), 5%);
      }
	  text-placement-type: simple;
      text-dx: 7;
      text-dy: 9;
      text-placements: 'S,E,W,N';
    }  
  }
  [type='cemetery'] {
    [zoom=14][priority<4],
    [zoom=15][priority<4],
    [zoom=16][priority<5],
    [zoom>=17],
    {
      ::marker {
        marker-placement: point;
        marker-file: url("marker/cemetery.svg");
        marker-width: 10;
        marker-height: 10;
		marker-fill: @label-color-alt;
      }
      text-dy: 9;
    }  
  }  
}


///////////////////////////////////////////////////
// Road names
///////////////////////////////////////////////////


#road-shield [zoom>7] {
  [category='CHINA/G0'] {
    shield-file: url('shield/ch-0.svg');
    shield-placement: line;    
	shield-clip: false;    
    shield-face-name: 'Arial Bold';
    shield-name: '[ref]';
    shield-fill: white;
    shield-text-dy: 1;
    shield-size: 9;
    shield-allow-overlap: false;
   
    [zoom<=10] {shield-spacing: 150;}
    [zoom>10][zoom<15] {shield-spacing: 300;}
    [zoom>=15] {shield-spacing: 600;}

    [zoom=8] { shield-min-distance: 10; }
    [zoom=9] { shield-min-distance: 20; }
    [zoom=10] { shield-min-distance: 40; }
    [zoom=11] { shield-min-distance: 100; }
    [zoom=12] { shield-min-distance: 120; }
    [zoom=13] { shield-min-distance: 160; }
    [zoom=14] { shield-min-distance: 180; }    
    [zoom=15] { shield-min-distance: 200; }
    [zoom=16] { shield-min-distance: 250; }    
    [zoom>=17] { shield-min-distance: 300; }    

  }
  
  [category='CHINA/G1'][zoom>9] {
    shield-file: url('shield/ch-1.svg');
    shield-placement: line;    
	shield-clip: false;    
    shield-face-name: 'Arial Bold';
    shield-name: '[ref]';
    shield-fill: white;
    
    shield-size: 9;
    shield-allow-overlap: false;

    [zoom<=10] {shield-spacing: 150;}
    [zoom>10][zoom<15] {shield-spacing: 300;}
    [zoom>=15] {shield-spacing: 600;}
    
    [zoom=8] { shield-min-distance: 10; }
    [zoom=9] { shield-min-distance: 20; }
    [zoom=10] { shield-min-distance: 40; }
    [zoom=11] { shield-min-distance: 100; }
    [zoom=12] { shield-min-distance: 120; }
    [zoom=13] { shield-min-distance: 160; }
    [zoom=14] { shield-min-distance: 180; }    
    [zoom=15] { shield-min-distance: 400; }
    [zoom=16] { shield-min-distance: 250; }    
    [zoom>=17] { shield-min-distance: 300; }    
  }
  
  [category='CHINA/S0'][zoom>=12] {
    shield-file: url('shield/ch-2.svg');
    shield-placement: line;    
    shield-clip: false;
    shield-face-name: 'Arial Bold';
    shield-name: '[ref]';
    shield-fill: white;
    shield-text-dy: 2;
    shield-size: 9;
    shield-allow-overlap: false;

    [zoom>12][zoom<15] {shield-spacing: 300;}
    [zoom>=15] {shield-spacing: 600;}
    
    [zoom=12] { shield-min-distance: 120; }
    [zoom=13] { shield-min-distance: 180; }
    [zoom=14] { shield-min-distance: 200; }    
    [zoom=15] { shield-min-distance: 220; }
    [zoom=16] { shield-min-distance: 250; }    
    [zoom>=17] { shield-min-distance: 300; }  
  }
  [category='CHINA/S1'][zoom>=12] {
    shield-file: url('shield/ch-3.svg');
    shield-placement: line;    
    shield-clip: false;
    shield-face-name: 'Arial Bold';
    shield-name: '[ref]';
    shield-fill: white;

    shield-size: 9;
    shield-allow-overlap: false;
    
    [zoom>12][zoom<15] {shield-spacing: 300;}
    [zoom>=15] {shield-spacing: 600;}
    
    [zoom=12] { shield-min-distance: 120; }
    [zoom=13] { shield-min-distance: 180; }
    [zoom=14] { shield-min-distance: 200; }    
    [zoom=15] { shield-min-distance: 220; }
    [zoom=16] { shield-min-distance: 250; }    
    [zoom>=17] { shield-min-distance: 300; }    
  }
  
}

#road-label-gen1[zoom>=10][zoom<14][is_link=0],
#road-label[zoom>=14][is_link=0] {
  text-clip: false;
  text-face-name: @road-font;
  text-allow-overlap: false;
  text-name: "";
  text-fill: @label-color;
  text-halo-fill: @land-color;
  text-halo-radius: 1;
  text-placement: line;
  text-character-spacing: 2;
  text-label-position-tolerance: 16;
  text-max-char-angle-delta: 20;
  text-size: 12;
  
  [kind='motorway'], 
  [kind='motorway_link'] {
  	text-halo-fill: @highway-body-color;
  }
  [kind='trunk'],
  [kind='trunk_link'] {
    text-halo-fill: @highway-body-color;
  }
  
  [kind='primary'],
  [kind='primary_link'],
  [kind='secondary'],
  [kind='secondary_link'],
  [kind='tertiary'],
  [kind='tertiary_link'] {
    text-halo-fill: @major_road-body-color;
  }

  [priority>=3] { text-fill: @label-color-alt; }
 
  [priority<=0][zoom>=10][zoom<=11] {  
    text-name: "[name_abbr]";
    text-min-distance: 120;
    text-spacing: 120;
  }
  
  [priority<=1][zoom>11][zoom<14] {
    text-name: "[name_abbr]";
    text-min-distance: 120;
    text-spacing: 180;
  }
  
  [zoom=14][priority<=3] { 
    text-name: "[name_abbr]";
    text-size: 12;
    text-min-distance: 160;
    text-spacing: 180;
  }
  [zoom=15][priority<=6] { 
    text-name: "[name_abbr]";
    text-size: 12;
  	text-min-distance: 120;
    text-spacing: 180;
    text-character-spacing: 4;
  }
  [zoom=16][priority<=7] {
    text-name: "[name]";
    text-size: 14;
  	text-min-distance: 60;
    text-spacing: 180;
    //text-character-spacing: 4;
    text-min-padding: 10;
  }
  [zoom>=17] { 
    text-name: "[name]";
  	text-size: 16; 
    text-min-distance:60;
    text-spacing: 180;
    text-character-spacing: 4;
  }
}
