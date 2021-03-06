----------------------------------------
-- INPUTS
-- location: neighborhood
----------------------------------------
DROP TABLE IF EXISTS generated.neighborhood_connected_census_blocks;

CREATE TABLE generated.neighborhood_connected_census_blocks (
    id SERIAL PRIMARY KEY,
    source_blockid10 VARCHAR(15),
    target_blockid10 VARCHAR(15),
    low_stress BOOLEAN,
    low_stress_cost INT,
    high_stress BOOLEAN,
    high_stress_cost INT
);

INSERT INTO generated.neighborhood_connected_census_blocks (  -- took 2 hrs on the server
    source_blockid10, target_blockid10, low_stress, high_stress
)
SELECT  source_block.blockid10,
        target_block.blockid10,
        'f'::BOOLEAN,
        't'::BOOLEAN
FROM    neighborhood_census_blocks source_block,
        neighborhood_census_blocks target_block
WHERE   EXISTS (
            SELECT  1
            FROM    neighborhood_zip_codes zips
            WHERE   ST_Intersects(source_block.geom,zips.geom)
            AND     zips.zip_code = '02138'
        )
AND     source_block.geom <#> target_block.geom < 3350      --3350 meters ~~ 11000 ft
AND     EXISTS (
            SELECT  1
            FROM    neighborhood_census_block_roads source_br,
                    neighborhood_census_block_roads target_br,
                    neighborhood_reachable_roads_high_stress hs
            WHERE   source_block.blockid10 = source_br.blockid10
            AND     target_block.blockid10 = target_br.blockid10
            AND     hs.base_road = source_br.road_id
            AND     hs.target_road = target_br.road_id
        );

-- block pair index
CREATE INDEX idx_neighborhood_blockpairs
ON neighborhood_connected_census_blocks (source_blockid10,target_blockid10);
ANALYZE neighborhood_connected_census_blocks (source_blockid10,target_blockid10);

-- low stress
UPDATE  neighborhood_connected_census_blocks
SET     low_stress = 't'::BOOLEAN
WHERE   EXISTS (
            SELECT  1
            FROM    neighborhood_census_block_roads source_br,
                    neighborhood_census_block_roads target_br,
                    neighborhood_reachable_roads_low_stress ls
            WHERE   source_blockid10 = source_br.blockid10
            AND     target_blockid10 = target_br.blockid10
            AND     ls.base_road = source_br.road_id
            AND     ls.target_road = target_br.road_id
        )
AND     (
            SELECT  MIN(total_cost)
            FROM    neighborhood_census_block_roads source_br,
                    neighborhood_census_block_roads target_br,
                    neighborhood_reachable_roads_low_stress ls
            WHERE   source_blockid10 = source_br.blockid10
            AND     target_blockid10 = target_br.blockid10
            AND     ls.base_road = source_br.road_id
            AND     ls.target_road = target_br.road_id
        )::FLOAT /
        COALESCE((
            SELECT  MIN(total_cost) + 1
            FROM    neighborhood_census_block_roads source_br,
                    neighborhood_census_block_roads target_br,
                    neighborhood_reachable_roads_high_stress hs
            WHERE   source_blockid10 = source_br.blockid10
            AND     target_blockid10 = target_br.blockid10
            AND     hs.base_road = source_br.road_id
            AND     hs.target_road = target_br.road_id
        ),3350) <= 1.3;         --3350 meters ~~ 11000 ft

-- stress index
CREATE INDEX idx_neighborhood_blockpairs_lstress ON neighborhood_connected_census_blocks (low_stress);
CREATE INDEX idx_neighborhood_blockpairs_hstress ON neighborhood_connected_census_blocks (high_stress);
ANALYZE neighborhood_connected_census_blocks (low_stress,high_stress);
