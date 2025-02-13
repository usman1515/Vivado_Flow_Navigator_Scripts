# URL: https://docs.amd.com/r/en-US/xapp1335-isolation-design-flow-mpsoc/Shading-Pblocks
# INFO: open checkpoint and run in Tcl Console

# get a list of all the pblocks
set pblocks [get_pblocks *];

# initialze color index var (ci) to 1
set ci 1;

# visually highlight all pblocks
foreach pblock $pblocks {
    highlight_objects -color_index [expr {1 + ($ci % 19)}] [get_pblocks $pblock];
    incr ci
}
