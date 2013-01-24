import os


zfactor=12 # Reduce this when using high resolution data!
azimuth=345 

datadir = '/home/pset/proj/geodata'
themedir= './themes/Brick_China/'
cachedir= os.path.join(themedir, 'cache')

tag = 'Brick-China'
tile_size = 256

fmt = 'png'



elev_1km = dict(\
    prototype='datasource.dataset',
    dataset_path=os.path.join(datadir, 'srtm30_new/world_tiled.tif'),
    cache=dict(prototype='metacache',
        root=os.path.join(cachedir, 'elevation'),
        compress=True,
        data_format='gtiff',
        ),
    )
    
elev_30m = dict(\
    prototype='datasource.dataset',
    dataset_path=os.path.join(datadir, 'SRTM_30_org/world/fill/world_3857.vrt'),
    cache=dict(prototype='metacache',
        root=os.path.join(cachedir, 'elevation'),
        compress=True,
        data_format='gtiff',
        ),
    )
    

elevation = dict(\
    prototype='composite.selector',
    sources = ['elev_1km', 'elev_30m'],
    
    #            0  1  2  3  4  5  6  7  8  9 10 11 12 13 
    condition = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1],
    )

terrain = dict(\
    prototype='composite.imagemagick',
    sources=['diffuse', 'detail', 'specular',],
    cache=dict(prototype='metacache',
              root=os.path.join(cachedir, '%s' % tag),
              data_format=fmt,
             ),
    format='jpg',
    command='''   
    (
         ( $1 -fill grey50 -colorize 100% )
         ( $1 ) -compose blend -define compose:args=50% -composite
         ( $2  -gamma 0.8  ) -compose blend -define compose:args=30% -composite
         ( $3 -gamma 3 ) -compose blend -define compose:args=20% -composite
         -brightness-contrast -10%x-10%
         -gamma 1.2
         -quality 99
    )
    '''
    )





diffuse = dict(\
    prototype='processing.hillshading',
    sources='elevation',
    zfactor=zfactor,
    scale=1,
    altitude=35,
    azimuth=azimuth,
    )

detail = dict(\
    prototype='processing.hillshading',
    sources='elevation',
    zfactor=zfactor / 2.,
    scale=1,
    altitude=65,
    azimuth=azimuth,
)

specular = dict(\
    prototype='processing.hillshading',
    sources='elevation',
    zfactor=zfactor,
    scale=1,
    altitude=85,
    azimuth=azimuth,
    )


landcover = dict(\
    prototype='datasource.mapnik',
    theme=os.path.join(themedir, 'brick-china-background.xml'),
    image_type='png',
    buffer_size=tile_size*2,
    scale_factor=tile_size//256
    )

roads = dict(\
    prototype='datasource.mapnik',
    theme=os.path.join(themedir, 'brick-china-roads.xml'),
    image_type='png',
    buffer_size=tile_size,
    scale_factor=tile_size//256
    )

labels = dict(\
    prototype='datasource.mapnik',
    theme=os.path.join(themedir, 'brick-china-labels.xml'),
    image_type='png',
    buffer_size=tile_size*2,
    scale_factor=tile_size//256
    )

label_halo = dict(\
    prototype='datasource.mapnik',
    theme=os.path.join(themedir, 'brick-china-labels_halo.xml'),
    image_type='png',
    buffer_size=tile_size* 2,
    scale_factor=tile_size//256
    )

composer=dict(\
    prototype='composite.imagemagick',   
    sources=['landcover', 'roads', 'labels', 'label_halo',
             #'terrain'
             ],
    format=fmt,
    command='''   
    $1 
#    ( $5 ) -compose softlight -composite    
    ( 
        $2
        ( $4 -channel RGBA -blur %(scale)d +channel ) -compose dst-out -composite
    ) -compose over -composite
    ( $3 ) -compose over -composite    
    
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
               stride=16,
               servers=['localhost:11211',],
               root=os.path.join(cachedir, 'export', '%s' % tag),
              ),
    pyramid=dict(levels=range(2, 19),
#                   envelope=(-180,-0.58,-52.32,71.60),                 
#                 envelope=(-124,34,-70,48),                 
#                envelope=( -123.40/1, 36.444, -118.65, 39.89),
                 zoom=8,
                 center=(121.751,31.311),
                 format=fmt,
                 buffer=0,
                 tile_size=tile_size,
                 ),
)
