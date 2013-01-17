
-- background
CREATE OR REPLACE VIEW brick_landmass AS 
	SELECT *
	FROM org_bp
	WHERE org_bp.kind::text = '0137'::text;
	
	
CREATE OR REPLACE VIEW brick_sea AS 
	SELECT *
	FROM org_bp
	WHERE org_bp.kind::text = '0125'::text OR org_bp.kind::text = '0121'::text;
	
	
CREATE OR REPLACE VIEW brick_waterbody AS 
	SELECT org_bp.gid, 
        CASE
            WHEN org_bp.kind::text = '0122'::text THEN 'lake'::text
            WHEN org_bp.kind::text = '0124'::text THEN 'lake'::text
            WHEN org_bp.kind::text = '0123'::text THEN 'river'::text
            ELSE NULL
        END AS type, 
		st_area(geography(org_bp.the_geom)) AS area, 
		org_bp.the_geom
	FROM org_bp
	WHERE org_bp.kind::text = ANY (ARRAY['0122'::character varying::text, '0123'::character varying::text, '0124'::character varying::text, '01ff'::character varying::text])
	ORDER BY st_area(geography(org_bp.the_geom)) DESC;
	

CREATE OR REPLACE VIEW brick_landusage AS 
	SELECT org_bp.gid, 
        CASE
            WHEN org_bp.kind::text = '0161'::text THEN 'university'::text
            WHEN org_bp.kind::text = '0162'::text THEN 'shopping'::text
            WHEN org_bp.kind::text = '0163'::text THEN 'hospital'::text
            WHEN org_bp.kind::text = '0164'::text THEN 'industry'::text
            WHEN org_bp.kind::text = '0141'::text THEN 'park'::text
            WHEN org_bp.kind::text = '0142'::text THEN 'golf_course'::text
            WHEN org_bp.kind::text = '0144'::text THEN 'greenfield'::text
            ELSE NULL
        END AS type, 
		st_area(geography(org_bp.the_geom)) AS area, 
		org_bp.the_geom
	FROM org_bp
	WHERE org_bp.kind::text = ANY (ARRAY['0161'::character varying::text, '0162'::character varying::text, '0163'::character varying::text, '0164'::character varying::text, '06ff'::character varying::text, '0141'::character varying::text, '0142'::character varying::text, '0144'::character varying::text, '04ff'::character varying::text])
	ORDER BY st_area(geography(org_bp.the_geom)) DESC;
	

CREATE OR REPLACE VIEW brick_building AS 
	SELECT *
	FROM org_building
	ORDER BY st_ymin(st_envelope(org_building.the_geom)::box3d) DESC;
	

-- road
CREATE OR REPLACE VIEW org_road_name_view AS 
	SELECT road.id, road_name.pathname AS name, road_ref.pathpy AS ref
	FROM 
		org_r road
		LEFT JOIN ( 
			SELECT DISTINCT ON (a.id) a.gid, a.mapid, a.id, a.route_id, a.name_kind, a.name_type, a.seq_nm, b.gid, b.route_id, b.route_kind, b.pathname, b.pathpy, b.prename, b.prepy, b.basename, b.basepy, b.sttpname, b.sttppy, b.surname, b.surpy, b.wavname, b.language, b.sttploc
			FROM 
				org_r_lname a
				JOIN 
				org_r_name b 
				ON a.route_id::text = b.route_id::text
			WHERE a.name_type::text = '0'::text AND b.language::text = '1'::text AND b.route_kind::text = '0'::text AND a.name_kind::text <> '3'::text
			ORDER BY a.id, a.seq_nm DESC
			) road_name 
			ON road.id::text = road_name.id::text
			
		LEFT JOIN ( 
			SELECT DISTINCT ON (a.id) a.gid, a.mapid, a.id, a.route_id, a.name_kind, a.name_type, a.seq_nm, b.gid, b.route_id, b.route_kind, b.pathname, b.pathpy, b.prename, b.prepy, b.basename, b.basepy, b.sttpname, b.sttppy, b.surname, b.surpy, b.wavname, b.language, b.sttploc
			FROM 
				org_r_lname a
				JOIN 
				org_r_name b 
				ON a.route_id::text = b.route_id::text
			WHERE a.name_type::text = '0'::text AND b.language::text = '1'::text AND b.route_kind::text <> '0'::text AND a.name_kind::text <> '3'::text
			ORDER BY a.id, a.seq_nm DESC) road_ref ON road.id::text = road_ref.id::text;

			
CREATE OR REPLACE VIEW planet_osm_line_view AS 
	SELECT 
		a.gid AS osm_id, 
		c.name, 
		c.ref, 
        CASE
			WHEN a.kind::text ~* '0005|000b'::text THEN 'motorway_link'::text
            WHEN a.kind::text ~* '00\w\w'::text THEN 'motorway'::text
            WHEN a.kind::text ~* '0105|000b'::text THEN 'trunk_link'::text
            WHEN a.kind::text ~* '01\w\w'::text THEN 'trunk'::text
            WHEN a.kind::text ~* '0205|000b'::text THEN 'primary_link'::text
            WHEN a.kind::text ~* '02\w\w'::text THEN 'primary'::text
            WHEN a.kind::text ~* '0305|000b'::text THEN 'secondary_link'::text
            WHEN a.kind::text ~* '03\w\w'::text THEN 'secondary'::text
            WHEN a.kind::text ~* '0405|000b'::text THEN 'tertiary_link'::text
            WHEN a.kind::text ~* '04\w\w'::text THEN 'tertiary'::text
            WHEN a.kind::text ~* '06\w\w'::text THEN 'residential'::text
            WHEN a.kind::text ~* '08\w\w'::text THEN 'path'::text
            WHEN a.kind::text ~* '09\w\w'::text THEN 'path'::text
            WHEN a.kind::text ~* '0a\w\w'::text THEN 'ferry'::text
            WHEN a.kind::text ~* '0b\w\w'::text THEN 'footpath'::text
            ELSE NULL::text
        END AS highway, 
		NULL::text AS railway, 
        CASE
            WHEN b.layer IS NOT NULL THEN b.layer::text
            ELSE '0'::text
        END AS layer, 
        CASE
            WHEN a.direction::text = '0'::text THEN 'no'::text
            WHEN a.direction::text = '1'::text THEN 'no'::text
            WHEN a.direction::text = '2'::text THEN 'yes'::text
            WHEN a.direction::text = '3'::text THEN '-1'::text
            ELSE 'no'::text
        END AS oneway, 
        CASE
            WHEN a.kind::text ~* '\w\w0f'::text THEN 'yes'::text
            ELSE 'no'::text
        END AS tunnel, 
        CASE
            WHEN a.kind::text ~* '\w\w08'::text THEN 'yes'::text
            ELSE 'no'::text
        END AS bridge, a.the_geom AS way
	FROM org_r a
	LEFT JOIN brick_roads_layer b ON a.id::text = b.id::text
	LEFT JOIN org_road_name c ON a.id::text = c.id::text;


CREATE OR REPLACE VIEW brick_road_rail AS 
 SELECT foo.z15, foo.z14, foo.z13, foo.z12, foo.z11, foo.z10, foo.brick_oneway, foo.is_link, foo.is_tunnel, foo.is_bridge, foo.explicit_layer, foo.implied_layer, foo.brick_kind, foo.priority, foo.osm_id, foo.name, foo.highway, foo.railway, foo.layer, foo.oneway, foo.tunnel, foo.bridge, foo.way
   FROM ( SELECT 
                CASE
                    WHEN planet_osm_line.highway = ANY (ARRAY['motorway'::text, 'motorway_link'::text]) THEN 'highway'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['trunk'::text, 'trunk_link'::text]) THEN 'trunk'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['primary'::text, 'primary_link'::text, 'secondary'::text, 'secondary_link'::text, 'tertiary'::text, 'tertiary_link'::text]) THEN 'major_road'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['residential'::text, 'unclassified'::text, 'road'::text, 'minor'::text]) THEN 'minor_road'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['service'::text, 'footpath'::text, 'track'::text, 'footway'::text, 'steps'::text, 'pedestrian'::text, 'path'::text, 'cycleway'::text]) THEN 'path'::text
                    WHEN planet_osm_line.railway = ANY (ARRAY['rail'::text, 'tram'::text, 'light_rail'::text, 'narrow_guage'::text, 'monorail'::text]) THEN 'rail'::text
                    ELSE NULL::text
                END AS z15, 
                CASE
                    WHEN planet_osm_line.highway = ANY (ARRAY['motorway'::text, 'motorway_link'::text]) THEN 'highway'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['trunk'::text, 'trunk_link'::text]) THEN 'trunk'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['primary'::text, 'primary_link'::text, 'secondary'::text, 'secondary_link'::text, 'tertiary'::text, 'tertiary_link'::text]) THEN 'major_road'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['residential'::text, 'unclassified'::text, 'road'::text, 'minor'::text]) THEN 'minor_road'::text
                    WHEN planet_osm_line.railway = 'rail'::text THEN 'rail'::text
                    ELSE NULL::text
                END AS z14, 
                CASE
                    WHEN planet_osm_line.highway = ANY (ARRAY['motorway'::text, 'motorway_link'::text]) THEN 'highway'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['trunk'::text, 'trunk_link'::text]) THEN 'trunk'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['primary'::text, 'primary_link'::text, 'secondary'::text, 'secondary_link'::text, 'tertiary'::text]) THEN 'major_road'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['residential'::text, 'unclassified'::text, 'road'::text, 'minor'::text]) THEN 'minor_road'::text
                    WHEN planet_osm_line.railway = 'rail'::text THEN 'rail'::text
                    ELSE NULL::text
                END AS z13, 
                CASE
                    WHEN planet_osm_line.highway = ANY (ARRAY['motorway'::text, 'motorway_link'::text]) THEN 'highway'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['trunk'::text, 'trunk_link'::text]) THEN 'trunk'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['secondary'::text, 'primary'::text]) THEN 'major_road'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['tertiary'::text, 'residential'::text, 'unclassified'::text, 'road'::text]) THEN 'minor_road'::text
                    WHEN planet_osm_line.railway = 'rail'::text THEN 'rail'::text
                    ELSE NULL::text
                END AS z12, 
                CASE
                    WHEN planet_osm_line.highway = 'motorway'::text THEN 'highway'::text
                    WHEN planet_osm_line.highway = 'trunk'::text THEN 'trunk'::text
                    WHEN planet_osm_line.highway = 'primary'::text THEN 'major_road'::text
                    WHEN planet_osm_line.highway = ANY (ARRAY['secondary'::text, 'tertiary'::text]) THEN 'minor_road'::text
                    ELSE NULL::text
                END AS z11, 
                CASE
                    WHEN planet_osm_line.highway = 'motorway'::text THEN 'highway'::text
                    WHEN planet_osm_line.highway = 'trunk'::text THEN 'trunk'::text
                    WHEN planet_osm_line.highway = 'primary'::text THEN 'major_road'::text
                    WHEN planet_osm_line.highway = 'secondary'::text THEN 'minor_road'::text
                    ELSE NULL::text
                END AS z10, 
                CASE
                    WHEN planet_osm_line.oneway = ANY (ARRAY['yes'::text, 'true'::text]) THEN 1
                    WHEN planet_osm_line.oneway = ANY (ARRAY['no'::text, 'false'::text]) THEN 0
                    WHEN planet_osm_line.oneway = '-1'::text THEN (-1)
                    ELSE 0
                END AS brick_oneway, 
                CASE
                    WHEN planet_osm_line.highway ~~ '%_link'::text THEN 1
                    ELSE 0
                END AS is_link, 
                CASE
                    WHEN planet_osm_line.tunnel = ANY (ARRAY['yes'::text, 'true'::text]) THEN 1
                    ELSE 0
                END AS is_tunnel, 
                CASE
                    WHEN planet_osm_line.bridge = ANY (ARRAY['yes'::text, 'true'::text]) THEN 1
                    ELSE 0
                END AS is_bridge, 
                CASE
                    WHEN planet_osm_line.layer ~ '^-?[[:digit:]]+(\.[[:digit:]]+)?$'::text THEN planet_osm_line.layer::double precision
                    ELSE 0::double precision
                END AS explicit_layer, 
                CASE
                    WHEN planet_osm_line.tunnel = ANY (ARRAY['yes'::text, 'true'::text]) THEN (-1)
                    WHEN planet_osm_line.bridge = ANY (ARRAY['yes'::text, 'true'::text]) THEN 1
                    ELSE 0
                END AS implied_layer, COALESCE(planet_osm_line.highway, planet_osm_line.railway) AS brick_kind, 
                CASE
                    WHEN planet_osm_line.highway = 'motorway'::text THEN 0::numeric
                    WHEN planet_osm_line.railway = ANY (ARRAY['rail'::text, 'tram'::text, 'light_rail'::text, 'narrow_guage'::text, 'monorail'::text]) THEN 0.5
                    WHEN planet_osm_line.highway = 'trunk'::text THEN 1::numeric
                    WHEN planet_osm_line.highway = 'primary'::text THEN 2::numeric
                    WHEN planet_osm_line.highway = 'secondary'::text THEN 3::numeric
                    WHEN planet_osm_line.highway = 'tertiary'::text THEN 4::numeric
                    WHEN planet_osm_line.highway ~~ '%_link'::text THEN 5::numeric
                    WHEN planet_osm_line.highway = ANY (ARRAY['residential'::text, 'unclassified'::text, 'road'::text]) THEN 6::numeric
                    WHEN planet_osm_line.highway = ANY (ARRAY['service'::text, 'minor'::text]) THEN 7::numeric
                    ELSE 99::numeric
                END AS priority, planet_osm_line.osm_id, planet_osm_line.name, planet_osm_line.highway, planet_osm_line.railway, planet_osm_line.layer, planet_osm_line.oneway, planet_osm_line.tunnel, planet_osm_line.bridge, planet_osm_line.way
           FROM planet_osm_line) foo;
		   
		   
CREATE OR REPLACE VIEW brick_road_z10 AS 
	SELECT foo.render, foo.z10 AS category, foo.brick_kind AS kind, foo.brick_oneway AS oneway, foo.is_link, foo.is_tunnel, foo.is_bridge, foo.way
	FROM (         
		SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'outline'::text AS render, 1 AS is_outline
        FROM brick_road_rail
        WHERE brick_road_rail.z10 IS NOT NULL
        
		UNION ALL 
        
		SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'inline'::text AS render, 0 AS is_outline
        FROM brick_road_rail
        WHERE brick_road_rail.z10 IS NOT NULL
		) foo
	ORDER BY 
		foo.is_outline DESC, 
		foo.explicit_layer, 
		foo.implied_layer, 
		foo.priority DESC;
		

CREATE OR REPLACE VIEW brick_road_z11 AS 
	SELECT foo.render, foo.z11 AS category, foo.brick_kind AS kind, foo.brick_oneway AS oneway, foo.is_link, foo.is_tunnel, foo.is_bridge, foo.way
	FROM (         
		SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'outline'::text AS render, 1 AS is_outline
		FROM brick_road_rail
		WHERE brick_road_rail.z11 IS NOT NULL
        
		UNION ALL 
        
		SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'inline'::text AS render, 0 AS is_outline
		FROM brick_road_rail
		WHERE brick_road_rail.z11 IS NOT NULL
		) foo
  ORDER BY 
		foo.is_outline DESC, 
		foo.explicit_layer, 
		foo.implied_layer, 
		foo.priority DESC;
		
		
CREATE OR REPLACE VIEW brick_road_z12 AS 
	SELECT foo.render, foo.z12 AS category, foo.brick_kind AS kind, foo.brick_oneway AS oneway, foo.is_link, foo.is_tunnel, foo.is_bridge, foo.way
	FROM (         
		SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'outline'::text AS render, 1 AS is_outline
		FROM brick_road_rail
		WHERE brick_road_rail.z12 IS NOT NULL
        
		UNION ALL 
        
		SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'inline'::text AS render, 0 AS is_outline
		FROM brick_road_rail
		WHERE brick_road_rail.z12 IS NOT NULL
		) foo
	ORDER BY 
		foo.is_outline DESC, 
		foo.explicit_layer, 
		foo.implied_layer, 
		foo.priority DESC;
		

CREATE OR REPLACE VIEW brick_road_z13 AS 
	SELECT foo.render, foo.z13 AS category, foo.brick_kind AS kind, foo.brick_oneway AS oneway, foo.is_link, foo.is_tunnel, foo.is_bridge, foo.way
	FROM 	(        
				(        
					         
					(
						SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'outline'::text AS render, 1 AS is_outline, 1 AS is_casing, 0 AS is_marker
						FROM brick_road_rail
						WHERE brick_road_rail.z13 IS NOT NULL
						
						UNION ALL 
						
						SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'casing'::text AS render, 0 AS is_outline, 1 AS is_casing, 0 AS is_marker
						FROM brick_road_rail
						WHERE brick_road_rail.z13 IS NOT NULL
					)
			
					UNION ALL 
					
					SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'inline'::text AS render, 0 AS is_outline, 0 AS is_casing, 0 AS is_marker
					FROM brick_road_rail
					WHERE brick_road_rail.z13 IS NOT NULL
					
				)
				
				UNION ALL 
                 
				SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'marker'::text AS render, 0 AS is_outline, 0 AS is_casing, 1 AS is_marker
				FROM brick_road_rail
				WHERE brick_road_rail.z13 IS NOT NULL
			) foo
	ORDER BY 
		foo.is_outline DESC, 
		foo.explicit_layer, 
		foo.implied_layer, 
		foo.is_casing DESC, 
		foo.is_marker, 
		foo.priority DESC;

		
		
CREATE OR REPLACE VIEW brick_road_z14 AS 
	SELECT foo.render, foo.z14 AS category, foo.brick_kind AS kind, foo.brick_oneway AS oneway, foo.is_link, foo.is_tunnel, foo.is_bridge, foo.way
	FROM 	(
				(
					(         
						SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'outline'::text AS render, 1 AS is_outline, 1 AS is_casing, 0 AS is_marker
						FROM brick_road_rail
						WHERE brick_road_rail.z14 IS NOT NULL
                        
						UNION ALL 
						
						SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'casing'::text AS render, 0 AS is_outline, 1 AS is_casing, 0 AS is_marker
						FROM brick_road_rail
						WHERE brick_road_rail.z14 IS NOT NULL
					)
                
					UNION ALL 
					 
					SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'inline'::text AS render, 0 AS is_outline, 0 AS is_casing, 0 AS is_marker
					FROM brick_road_rail
					WHERE brick_road_rail.z14 IS NOT NULL
				)
        
				UNION ALL 
				
				SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'marker'::text AS render, 0 AS is_outline, 0 AS is_casing, 1 AS is_marker
				FROM brick_road_rail
				WHERE brick_road_rail.z14 IS NOT NULL
			) foo
	ORDER BY 
		foo.is_outline DESC, 
		foo.explicit_layer, 
		foo.implied_layer, 
		foo.is_casing DESC, 
		foo.is_marker, 
		foo.priority DESC;

		
CREATE OR REPLACE VIEW brick_road_z15 AS 
	SELECT foo.render, foo.z15 AS category, foo.brick_kind AS kind, foo.brick_oneway AS oneway, foo.is_link, foo.is_tunnel, foo.is_bridge, foo.way
	FROM 	(        
				(        
					(         
						SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'outline'::text AS render, 1 AS is_outline, 1 AS is_casing, 0 AS is_marker
                        FROM brick_road_rail
						WHERE brick_road_rail.z15 IS NOT NULL
                        
						UNION ALL 
						
						SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'casing'::text AS render, 0 AS is_outline, 1 AS is_casing, 0 AS is_marker
						FROM brick_road_rail
						WHERE brick_road_rail.z15 IS NOT NULL
						
					)
				
					UNION ALL 
                     
					SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'inline'::text AS render, 0 AS is_outline, 0 AS is_casing, 0 AS is_marker
					FROM brick_road_rail
					WHERE brick_road_rail.z15 IS NOT NULL
				)
				
				UNION ALL 
                
				SELECT brick_road_rail.z15, brick_road_rail.z14, brick_road_rail.z13, brick_road_rail.z12, brick_road_rail.z11, brick_road_rail.z10, brick_road_rail.brick_oneway, brick_road_rail.is_link, brick_road_rail.is_tunnel, brick_road_rail.is_bridge, brick_road_rail.explicit_layer, brick_road_rail.implied_layer, brick_road_rail.brick_kind, brick_road_rail.priority, brick_road_rail.osm_id, brick_road_rail.name, brick_road_rail.highway, brick_road_rail.railway, brick_road_rail.layer, brick_road_rail.oneway, brick_road_rail.tunnel, brick_road_rail.bridge, brick_road_rail.way, 'marker'::text AS render, 0 AS is_outline, 0 AS is_casing, 1 AS is_marker
				FROM brick_road_rail
				WHERE brick_road_rail.z15 IS NOT NULL
			) foo
	ORDER BY 
		foo.is_outline DESC, 
		foo.explicit_layer, 
		foo.implied_layer, 
		foo.is_casing DESC, 
		foo.is_marker, 
		foo.priority DESC;

		
-- label
CREATE OR REPLACE VIEW planet_osm_point_view AS 
	SELECT 
		a.gid AS osm_id, 
        CASE
            WHEN a.class::text = '2'::text AND a.center::text = '1'::text THEN 'capital'::text
            WHEN a.class::text = '2'::text AND a.center::text = '2'::text THEN 'city'::text
            WHEN a.class::text = '2'::text THEN 'town'::text
            WHEN a.class::text = '3'::text THEN 'village'::text
            ELSE 'hamlet'::text
        END AS place, 
		b.name, 
		a.population, 
		a.the_geom AS way
	FROM 	( 
				SELECT org_a.gid, org_a.class, org_a.admincode, org_a.center, org_a.population, org_a.linkid, org_a.side, org_a.dummy, org_a.the_geom
				FROM org_a
				WHERE org_a.class::integer > 1
			) a
			JOIN 
			( 
				SELECT DISTINCT ON (org_fname.featid) org_fname.gid, org_fname.featid, org_fname.nametype, org_fname.name, org_fname.py, org_fname.keyword, org_fname.seq_nm, org_fname.signnumflg, org_fname.signnametp, org_fname.language, org_fname.nameflag
				FROM org_fname
				WHERE org_fname.nametype::text = '14'::text AND org_fname.language::text = '1'::text
			) b ON a.admincode::text = b.featid::text;
			
			
CREATE OR REPLACE VIEW brick_places AS 
	SELECT planet_osm_point.way, 
        CASE
            WHEN planet_osm_point.place = 'capital'::text THEN 0
            WHEN planet_osm_point.place = 'city'::text THEN 1
            WHEN planet_osm_point.place = 'town'::text THEN 2
            WHEN planet_osm_point.place = 'village'::text THEN 3
            ELSE 3
        END AS type, 
		regexp_replace(planet_osm_point.name::text, '(.*族)(.*)'::text, '\1
\2'::text) AS name, 
		regexp_replace(planet_osm_point.name::text, '(.*)市'::text, '\1'::text) AS abbr, 
        CASE
            WHEN planet_osm_point.population::text ~ '^\d+$'::text THEN planet_osm_point.population::integer
            ELSE 0
        END AS population
	FROM planet_osm_point
	WHERE planet_osm_point.place = ANY (ARRAY['capital'::text, 'city'::text, 'town'::text, 'village'::text, 'hamlet'::text, 'suburb'::text, 'neighbourhood'::text, 'locality'::text])
	ORDER BY 
			planet_osm_point.place, 
			CASE
				WHEN planet_osm_point.population::text ~ '^\d+$'::text THEN planet_osm_point.population::integer
				ELSE 0
			END DESC NULLS LAST, planet_osm_point.osm_id DESC;
			

CREATE OR REPLACE VIEW brick_road_shield_view AS 
	SELECT planet_osm_line.ref, 
        CASE
            WHEN planet_osm_line.ref::text ~~ 'G___'::text THEN 'CHINA/G1'::text
            WHEN planet_osm_line.ref::text ~~ 'G%'::text AND length(planet_osm_line.ref::text) < 6 THEN 'CHINA/G0'::text
            WHEN planet_osm_line.ref::text ~~ 'S___'::text THEN 'CHINA/S1'::text
            WHEN planet_osm_line.ref::text ~~ 'S%'::text AND length(planet_osm_line.ref::text) < 6 THEN 'CHINA/S0'::text
            ELSE NULL::text
        END AS category, st_multi((st_dump(st_multi(st_linemerge(st_collectionextract(st_collect(planet_osm_line.way), 2))))).geom) AS way
	FROM planet_osm_line
	WHERE planet_osm_line.ref IS NOT NULL AND planet_osm_line.highway !~~ '%_link'::text
	GROUP BY planet_osm_line.ref
	ORDER BY 
        CASE
            WHEN planet_osm_line.ref::text ~~ 'G___'::text THEN 1
            WHEN planet_osm_line.ref::text ~~ 'G%'::text AND length(planet_osm_line.ref::text) < 6 THEN 0
            WHEN planet_osm_line.ref::text ~~ 'S___'::text THEN 3
            WHEN planet_osm_line.ref::text ~~ 'S%'::text AND length(planet_osm_line.ref::text) < 6 THEN 2
            ELSE 99
        END, 
		length(planet_osm_line.ref::text), 
		st_length(geography(st_multi((st_dump(st_multi(st_linemerge(st_collectionextract(st_collect(planet_osm_line.way), 2))))).geom))) DESC;

