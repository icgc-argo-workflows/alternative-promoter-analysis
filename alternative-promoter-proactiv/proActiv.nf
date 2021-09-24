#!/usr/bin/env nextflow

/*
  Copyright (c) 2021, Yuk Kei Wan, Genome Institute of Singapore

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

  Authors:
    Yuk Kei Wan
*/

/********************************************************************/
/* this block is auto-generated based on info from pkg.json where   */
/* changes can be made if needed, do NOT modify this block manually */
nextflow.enable.dsl = 2
version = '0.1.0'  // package version

container = [
    'ghcr.io': 'ghcr.io/icgc-argo-rna-wg/alternative-promoter-analysis.alternative-promoter-proactiv'
]
default_container_registry = 'ghcr.io'
/********************************************************************/

// universal params go here, change default value as needed
params.container = ""
params.container_registry = ""
params.container_version = ""
params.cpus = 1
params.mem = 1  // GB
params.publish_dir = ""  // set to empty string will disable publishDir

// tool specific parmas go here, add / change as needed
params.junction_file = ""
params.condition     = ""
params.annotation    = ""

// please update workflow code as needed
process icgcArgoRnaSeqAlternativePromoterProactiv {
  container "${params.container ?: container[params.container_registry ?: default_container_registry]}:${params.container_version ?: version}"
//  container "docker.io/yuukiiwa/proactiv:0.1"
//  publishDir "${params.publish_dir}/${task.process.replaceAll(':', '_')}", mode: "copy", enabled: params.publish_dir
  publishDir "${params.publish_dir}/${task.process.replaceAll(':', '_')}/${params.condition}", mode: "copy", enabled: params.publish_dir

  cpus params.cpus
  memory "${params.mem} GB"

  input:
  path junction_file
  val  condition
  path premade_annotation_rds

  output:    
  path "*.csv"                , emit: proactiv_csv
  path "proactiv.version.txt" , emit: proactiv_version
  path "r.version.txt"        , emit: r_version

  script:
  """
  /tools/proActiv.r --junction_file=$junction_file --condition=$condition --annotation=$premade_annotation_rds
  Rscript -e "library(proActiv); write(x=as.character(packageVersion('proActiv')), file='proactiv.version.txt')"
  echo \$(R --version 2>&1) > r.version.txt
  """
}


// this provides an entry point for this main script, so it can be run directly without clone the repo
// using this command: nextflow run <git_acc>/<repo>/<pkg_name>/<main_script>.nf -r <pkg_name>.v<pkg_version> --params-file xxx
workflow {
  icgcArgoRnaSeqAlternativePromoterProactiv(
    file(params.junction_file),
    params.condition,
    file(params.annotation)
  )
}
