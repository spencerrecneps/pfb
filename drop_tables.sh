#!/usr/bin/env bash

# vars
DBHOST='192.168.40.225'
DBNAME='people_for_bikes'
OSMPREFIX='cambridge'

# drop old tables
echo 'Dropping old tables'
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_ways;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_ways_intersections;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_relations_ways;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_nodes;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_relations;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_way_classes;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_way_tags;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_way_types;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS scratch.${OSMPREFIX}_hwys_ways;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS scratch.${OSMPREFIX}_hwys_ways_vertices_pgr;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS scratch.${OSMPREFIX}_hwys_relations_ways;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS scratch.${OSMPREFIX}_hwys_osm_nodes;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS scratch.${OSMPREFIX}_hwys_osm_relations;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS scratch.${OSMPREFIX}_hwys_osm_way_classes;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS scratch.${OSMPREFIX}_hwys_osm_way_tags;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS scratch.${OSMPREFIX}_hwys_osm_way_types;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_full_line;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_full_point;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_full_polygon;"
psql -h $DBHOST -U gis -d ${DBNAME} \
  -c "DROP TABLE IF EXISTS received.${OSMPREFIX}_osm_full_roads;"