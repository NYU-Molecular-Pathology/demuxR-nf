# demuxR-nf
Demultiplexing nextflow pipeline for molecular research 
# Usage
Clone this repository:
```
git clone --recursive https://github.com/NYU-Molecular-Pathology/demuxR-nf.git
```
# Deployment
The deploy recipe in Makefile can be used to create a new demultiplexing directory based on existing sequencing run directory.
This recipe accepts arguments to specify the configuration parameters for your sequencing run, allowing you to customize the setup according to your needs.
```
cd demuxR-nf
make deploy RUNID=250815_VH00130_101_123FNMKNX SAMPLESHEET=SampleSheet.csv SEQTYPE=Archer 
```
Arguments:
  - `RUNID`: the identifier given to the run by the sequencer
  
  - `SAMPLESHEET`: the samplesheet required for demultiplexing with `bcl2fastq`
  
  - `SEQTYPE`: the type of sequencing; currently only `Archer` or `HiC` are used
  
  - `SEQDIR`: parent directory where the sequencer outputs its data (pre-configured for NYU server locations)
  
  - `PRODDIR`: parent directory where demultiplexing output should be stored (pre-configured for NYU server locations) (Default). If you want the production directory per seqtype, you can explicitly specify in the deploy command.
    ```
    make deploy RUNID=250815_VH00113_101_123FNMKNX SAMPLESHEET=SampleSheet.csv SEQTYPE=Archer PRODDIR=/path/to/labspace/production/Demultiplexing/Archer
    ```
# Run Workflow
After deploying the demultiplexing directory with generated configuration file, you can submit the parent Nextflow pipeline as a job on HPC Cluster:
```
make submit

# with a different submission queue:
make submit SUBQ=fn_long

# with a different submission time:
make submit SUBQ=cpu_long SUBTIME='--time=6-00:00:00'
```
# Software
- Nextflow version 24.04.2
- Java 17+ / OpenJDK 21.0.1+
- GNU `make`
  
The pipeline uses singularity containers built for the following bioinformatics tools:

  - bcl2fastq version 2.20.0
  - FastQC version 0.12.1
  - Multiqc version 1.21
  - Python 3.8
