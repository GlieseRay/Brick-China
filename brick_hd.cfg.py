import os


zfactor=12 # Reduce this when using high resolution data!
azimuth=345 

datadir = '/home/pset/proj/geodata'
themedir= './themes/Brick_China/'
cachedir= os.path.join(themedir, 'cache')

tag = 'Brick-CH_HD'
tile_size = 512

fmt = 'jpg'

# ============================================================================
# Land terrain relief

azimuth = 325

#    0   1   2   3   4   5   6   7   8   9  10  11
land_zfactors = \
    [100, 90, 80, 50, 40, 20, 16, 12, 9, 7,  6,  5]

land_zfactors_half = map(lambda x: x/2., land_zfactors)

elev_1km = os.path.join(datadir, 'srtm30_new/world_tiled.tif')
elev_100m = os.path.join(datadir, '_processed/world_3857.tif')

land_elevations = \
	[elev_1km, elev_1km, elev_1km, elev_1km, elev_1km, elev_1km, elev_1km,
	 elev_100m, elev_100m, elev_100m , elev_100m,
	 elev_100m]

land_elevation = dict(\
    prototype='node.raster',
    dataset_path=land_elevations,
#    keep_cache=False,
    cache=dict(prototype='metacache',
               root=os.path.join(cachedir, 'land_elevation'),
               compress=False,
               data_format='gtiff',
        ),
    )

land_diffuse = dict(\
    prototype='node.hillshading',
    sources='land_elevation',
    zfactor=land_zfactors,
    scale=1,
    altitude=35,
    azimuth=azimuth,
    )

land_detail = dict(\
    prototype='node.hillshading',
    sources='land_elevation',
    zfactor=land_zfactors_half,
    scale=1,
    altitude=65,
    azimuth=azimuth,
)

land_specular = dict(\
    prototype='node.hillshading',
    sources='land_elevation',
    zfactor=land_zfactors,
    scale=1,
    altitude=85,
    azimuth=azimuth,
    )


land_relief = dict(
    prototype='node.imagemagick',
    sources=['land_diffuse', 'land_detail', 'land_specular'],
    format='jpg',
    command='''
    (
          ( {{land_diffuse}} -fill grey50 -colorize 100%% )
          ( {{land_diffuse}} ) -compose blend -define compose:args=30%% -composite
          ( {{land_detail}} -fill #0055ff -tint 70 -gamma 0.8  ) -compose blend -define compose:args=40%% -composite
          ( {{land_specular}} -gamma 2 -fill #ffcba6 -tint 120 ) -compose blend -define compose:args=30%% -composite
          -brightness-contrast -10%%x-5%%
 	  -quality 100
    )
    ''',
    command_params=dict(
    	blur=['-blur 3', '-blur 3', '-blur 2', '-blur 2', '-blur 2', '-blur 1', '']
    	)
    )


background = dict(\
    prototype='node.mapnik',
    theme=os.path.join(themedir, 'brick-china-background.xml'),
    image_type='png',
    buffer_size=0,
    scale_factor=tile_size//256
    )

roads = dict(\
    prototype='node.mapnik',
    theme=os.path.join(themedir, 'brick-china-roads.xml'),
    image_type='png',
    buffer_size=0,
    scale_factor=tile_size//256
    )

labels = dict(\
    prototype='node.mapnik',
    theme=os.path.join(themedir, 'brick-china-labels.xml'),
    image_type='png',
    buffer_size=tile_size*2,
    scale_factor=tile_size//256
    )

label_halo = dict(\
    prototype='node.mapnik',
    theme=os.path.join(themedir, 'brick-china-labels_halo.xml'),
    image_type='png',
    buffer_size=tile_size*2,
    scale_factor=tile_size//256
    )

composer=dict(\
    prototype='node.imagemagick',   
    sources=['background', 'roads', 'labels', 'label_halo',
#             'land_relief'
             ],
    format=fmt,
    command='''   
    {{background}} 
#    ( {{land_relief}} ) -compose softlight -composite    
    ( 
        {{roads}}
        ( {{label_halo}} 
        #-channel RGBA -blur %(scale)d +channel 
        ) -compose dst-out -composite
    ) -compose over -composite
    ( {{labels}} ) -compose over -composite    
    
#    -colorspace gray -fill wheat -tint 90
    ''' % dict(scale=tile_size//256)
    )

ROOT = dict(\
    renderer='composer',
    metadata=dict(tag=tag,
                  version='2.0',
                  description='Brick - China Road Map',
                  attribution='Open Street Map, Natural Earth',
                  ),
    cache=dict(prototype='cluster',
               stride=8,
               servers=['localhost:11211',],
               root=os.path.join(cachedir, 'export', '%s' % tag),
              ),
    pyramid=dict(levels=range(2, 19),
#                 envelope=(77,15,134,50),                 
                 zoom=8,
                 center=(121.751,31.311),
                 format=fmt,
                 buffer=0,
                 tile_size=tile_size,
                 ),
)
