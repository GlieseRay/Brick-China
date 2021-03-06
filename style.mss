///////////////////////////////////////////////////
// Colors
///////////////////////////////////////////////////

///// Landmass

@land-color: #e3e3d8;
@water-color: #859db6;

///// Landusage

@residential-color: #dadacf;
@green-color: #bbccbb;
@green-color-alt: #adc0b3;
@grey-color: #ceccc4;
@grey-color-alt: #cacdc3;
@yellow-color: #d5d1b9;

@healthcare-color: #cfc3ba;
@education-color: #d5cfb9;
@sports-color: #ccdec6;

@airport-color: #cfcbbe;
@aeroway-color: lighten(@airport-color, 10);
@terminal-color: darken(@airport-color, 10);

@building-color: #d6d4cb;
@boundary-color: #888888;

///// Road

@highway-body-color: #cc9988;
@highway-casing-color: #776666;

@major_road-body-color: #d9cdc4;
@major_road-casing-color: lighten(@highway-casing-color, 15%);
@major_road-casing-color-alt: lighten(@highway-casing-color, 30%);

@minor_road-body-color: #f6f3f0;
@minor_road-casing-color: lighten(@highway-casing-color, 20%);
@minor_road-casing-color-alt: lighten(@highway-casing-color, 30%);

@path-body-color: #f6f3f0;
@path-casing-color: lighten(@highway-casing-color, 25%);
@path-casing-color-alt: lighten(@path-casing-color, 25%);

@highway-link-color: lighten(desaturate(@highway-body-color, 10%), 8%);
@road-dash: 5,2;

@ferry-color: #53789a;
@rail-color: #aaa197;
@rail-casing-color: @land-color;
@rail-outline-color: @rail-color;

///// Font 
@label-color: #27201c;
@label-color-alt : #645e5e;
@label_halo-color: @land-color;
@label-color-blue: @ferry-color;

@label-font: 'Songti SC Black';//,'American Typewriter Condensed', 'Arial Unicode MS Regular';
@label-font-alt: 'American Typewriter Regular', 'Arial Unicode MS Regular';
@label-font-heavy: 'American Typewriter Bold', 'Arial Unicode MS Regular';
@road-font: 'STHeiti Regular';

///// Variable depth buffer
@smart-halo-raidus: 2;


Map { 
  background-color: @water-color; 
  //buffer-size: 0;
  font-directory: url('/usr/share/fonts/Mac/');
}
