MAP_BASELAYERS = [{
    "source": {"ptype": "gxp_olsource"},
    "type": "OpenLayers.Layer",
    "args": ["No background"],
    "name": "background",
    "visibility": False,
    "fixed": True,
    "group":"background"
},
# {
#     "source": {"ptype": "gxp_olsource"},
#     "type": "OpenLayers.Layer.XYZ",
#     "title": "TEST TILE",
#     "args": ["TEST_TILE", "http://test_tiles/tiles/${z}/${x}/${y}.png"],
#     "name": "background",
#     "attribution": "&copy; TEST TILE",
#     "visibility": False,
#     "fixed": True,
#     "group":"background"
# },
{
    "source": {"ptype": "gxp_osmsource"},
    "type": "OpenLayers.Layer.OSM",
    "name": "mapnik",
    "visibility": True,
    "fixed": True,
    "group": "background"
}]
