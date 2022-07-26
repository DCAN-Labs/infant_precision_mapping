# Code repo for work on infant precission mapping

Disclaimer: this repo needs to be sorted and commented plus it contains a lot of hardcoded paths in the code. 

This repo contains code for the analysis of different aspects of infant precisionmapping data, mainly focused on the analysis of data reliability. 

## Seedmaps

code for creating seedmaps includes code for:
 - creating dense connectivity matrices (dconns)
 - calculating dscalars for selected seeds
 - plotting figures of these dscalars
 - arranging these figures in markdown slides
 
## Reliability curves

code for creating reliability curves includes code for:
 - creating parcellated connectivity matrices (pconns)
 - creating masks to select a given amount of continous data
 - correlating two pconns (upper triangles of matrix - whole brain level)
 - permuting this analysis and plotting curves


## Parcel by parcel reliability curves

code for creating parcel by parcel reliability curves includes code for:
 - creating parcellated connectivity matrices (pconns)
 - creating masks to select a given amount of continous data
 - correlating two pconns (parcel by parcel)
 - permuting this analysis and plotting results, combining parcels that belong to a given network

## Vertex wise reliability maps

code for creating vertex wise reliability maps includes code for:
 - creating dense connectivity matrices (dconns)
 - creating masks to select a given amount of continous data
 - calculating distances between vertices
 - correlating two dconns (removing correlations of spatialy close vertices)
 - plotting of results

