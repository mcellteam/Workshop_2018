% Start CellOrganizer
setup(true)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SEED EXAMPLE
seed = 3;
try
    state = rng(seed);
catch
    state = RandStream.create( 'mt19937ar', 'seed', seed );
    RandStream.setDefaultStream( state );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERATE SIMPLE GEOMETRIES
if ~exist( './synthetic_images' )
    mkdir( './synthetic_images' );
end

for i=1:1:25
    options.image_size = 256;
    
    a = randi([1/4*options.image_size 1/2*options.image_size]);
    b = randi([1/4*options.image_size 1/2*options.image_size]);
    c = randi([1/4*options.image_size 1/2*options.image_size]);
    filename = ['./synthetic_images/synthetic' num2str(sprintf('%04d',i)) '_0.tif'];
    if ~exist( filename )
        disp(['Making image ' filename]);
        img = generate_ellipsoid(a,b,c,options);
        img2tif( img, filename, 'lzw' );
    end
    
    a = randi([1/2*options.image_size 3/4*options.image_size]);
    b = randi([1/2*options.image_size 3/4*options.image_size]);
    c = randi([1/2*options.image_size 3/4*options.image_size]);
    filename = ['./synthetic_images/synthetic' num2str(sprintf('%04d',i)) '_1.tif'];
    if ~exist( filename )
        disp(['Making image ' filename]);
        img = generate_ellipsoid(a,b,c,options);
        img2tif( img, filename, 'lzw' );
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TRAIN MODEL WITH SIMPLE GEOMETRIES
clear options
tic

% location of TIF files and resolution
dna = './synthetic_images/*_0.tif';
cell = './synthetic_images/*_1.tif';
options.model.resolution = [0.049, 0.049, 0.2000]; 

%training flag is set to framework because want to train a model for 
%nuclear and cell shape
options.train.flag = 'framework';

%train model at full resolution
options.downsampling = [1 1 1];

%combination of supported model class and type
options.nucleus.name = 'ellipsoids';
options.nucleus.class = 'nuclear_membrane';
options.nucleus.type = 'cylindrical_surface';

%combination of supported model class and type
options.cell.name = 'ellipsoids';
options.cell.class = 'cell_membrane';
options.cell.type = 'ratio';

%output filename
options.model.filename = 'model.mat';

%helper options
options.verbose = true;
options.debug = true;

%CellOrganizer call
img2slml( '3D', dna, cell, [], options );
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SYNTHESIZE IMAGE FROM MODEL
model_file_path = './model.mat';

clear options
options.targetDirectory = pwd;

%output folder name
options.prefix = 'examples';

%number of images to synthesize
options.numberOfSynthesizedImages = 1;

%save images as TIF files
options.output.tifimages = true;

%compression for TIF output
options.compression = 'lzw';

%do not apply point-spread-function
options.microscope = 'none';

%render Gaussian objects as discs
options.sampling.method = 'disc';

%overlap frequency model and generate a single object
options.numberOfGaussianObjects = 1;

%generate framework
options.synthesis = 'framework';

%generate SBML output
options.output.blenderfile = true;
options.output.blender.downsample = [1 1 1];

%helper options
options.verbose = true;

%CellOrganizer call
slml2img( {model_file_path}, options );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
