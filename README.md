# Super-Resolution-Data-Analysis

## The following code was used to generate the data presented in Nanoscopic dopamine transporter distribution and conformation are inversely regulated by excitatory drive and D2-autoreceptor activity

Localizations were first fit with the imageJ macro using ThunderSTORM called "just locs.ijm"
Drift correction, uncertantiy cutoff, and merging were completed with the python script "DataAnalysisStep1"
Data was blinded with the python script "Blind"
ROIs were exrtracted with the matlab script "ROISaver"
Clustering values were extracted with the python scrip "See"



## The following code was used to generate the data presented in Cholesterol- and neuronal activity-dependent dopamine transporter nanodomains revealed by super-resolution microscopy

The 2017 method: 
DBSCAN_main.R was used to identify clusteres and generate the "Percent of localizations found in clusters" that is used throughout the paper as a metric.

Total Cluster Analysis-Zeros.py can also be used to generate the % clustered data for each ROI, and it also generates a table containing the size of each cluster, with the clusters identified by image.

Density Based Analysis.py includes multiple ways to display the data to reflect the density of localizations throughout the region of interest

Colocalization viewer.py takes the information gathered through the LAMA super resolution microscopy toolbox and views it.

Lama can be downloaded from its homepage located here: http://user.uni-frankfurt.de/~malkusch/lama.html

The analysis used for sup. figure 1 can be accessed here: http://www.nature.com/nmeth/journal/v13/n8/full/nmeth.3897.html

