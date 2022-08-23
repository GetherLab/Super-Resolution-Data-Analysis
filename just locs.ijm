
function STORM(input,output,filename) {
	filename = replace(filename,".nd2","");
	inport = input + filename + ".nd2";
	outport = output + filename + ".csv";

	run("Bio-Formats Importer", "open=[inport] color_mode=Default split_channels view=Hyperstack stack_order=XYCZT use_virtual_stack");
	run("Camera setup", "isemgain=true pixelsize=160.0 gainem=300.0 offset=51.57 photons2adu=12.22");
	run("Run analysis", "filter=[Wavelet filter (B-Spline)] scale=2.0 order=3 detector=[Non-maximum suppression] threshold=1.7*std(Wave.F1) radius=3 threshold=2.0*std(Wave.F1) estimator=[PSF: Integrated Gaussian] sigma=1.6 fitradius=3 method=[Weighted Least squares] full_image_fitting=false mfaenabled=false renderer=[No Renderer]");
	run("Export results", "filepath=["+outport+"] fileformat=[CSV (comma separated)] sigma1=true chi2=true sigma2=true intensity=true saveprotocol=true id=true frame=true bkgstd=true offset=true z=true y=true uncertainty=true x=true");
	}


setBatchMode(true); 



input = "H:\\virus\\210808\\210808\\";
output = "H:\\virus\\210808\\output\\";
list = getFileList(input);

for (i = 0; i < list.length; i++){
	STORM(input, output, list[i]);
	run("Close All");
	run("Collect Garbage");
}

setBatchMode(false);

