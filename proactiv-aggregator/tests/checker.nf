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

/*
 This is an auto-generated checker workflow to test the generated main template workflow, it's
 meant to illustrate how testing works. Please update to suit your own needs.
*/

/********************************************************************/
/* this block is auto-generated based on info from pkg.json where   */
/* changes can be made if needed, do NOT modify this block manually */
nextflow.enable.dsl = 2
version = '0.1.0'  // package version

container = [
    'ghcr.io': 'ghcr.io/icgc-argo-workflows/alternative-promoter-analysis.proactiv-aggregator'
]
default_container_registry = 'ghcr.io'
/********************************************************************/

// universal params
params.container_registry = ""
params.container_version = ""
params.container = ""

// tool specific parmas go here, add / change as needed
params.input_directory = ""
params.expected_absolute_activity = ""
params.expected_relative_gene_activity = ""
params.expected_relative_tx_activity = ""
params.expected_promoter_class = ""

include { proActivAggregator } from '../proActiv_aggregator'


process file_smart_diff {
  container "${params.container ?: container[params.container_registry ?: default_container_registry]}:${params.container_version ?: version}"

  input:
    path outputted_absolute_activity
    path expected_absolute_activity
    path outputted_relative_gene_activity
    path expected_relative_gene_activity
    path outputted_relative_tx_activity
    path expected_relative_tx_activity
    path outputted_promoter_class
    path expected_promoter_class

  output:
    stdout()

  script:
    """
    diff outputted_absolute_activity expected_absolute_activity \
      && ( echo "Test PASSED" && exit 0 ) || ( echo "Test FAILED, output file mismatch." && exit 1 )

    diff outputted_relative_gene_activity expected_relative_gene_activity \
      && ( echo "Test PASSED" && exit 0 ) || ( echo "Test FAILED, output file mismatch." && exit 1 )

    diff outputted_relative_tx_activity expected_relative_tx_activity \
      && ( echo "Test PASSED" && exit 0 ) || ( echo "Test FAILED, output file mismatch." && exit 1 )

    diff outputted_promoter_class expected_promoter_class \
      && ( echo "Test PASSED" && exit 0 ) || ( echo "Test FAILED, output file mismatch." && exit 1 )
    """
}


workflow checker {
  take:
    input_directory
    expected_absolute_activity
    expected_relative_gene_activity
    expected_relative_tx_activity
    expected_promoter_class

  main:
    proActivAggregator(
      input_directory
    )

    file_smart_diff(
      proActivAggregator.out.absolute_promoter_usage_csv,
      expected_absolute_activity,
      proActivAggregator.out.gene_relative_promoter_usage_csv,
      expected_relative_gene_activity,
      proActivAggregator.out.tx_relative_promoter_usage_csv,
      expected_relative_tx_activity,
      proActivAggregator.out.promoter_class_csv,
      expected_promoter_class
    )
}


workflow {
  checker(
    file(params.input_directory),
    file(params.expected_absolute_activity).
    file(params.expected_relative_gene_activity),
    file(params.expected_relative_tx_activity),
    file(params.expected_promoter_class)
  )
}
