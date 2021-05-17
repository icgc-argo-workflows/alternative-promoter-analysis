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

nextflow.enable.dsl = 2
version = '0.1.0'  // package version

// universal params
params.publish_dir = ""

// tool specific parmas go here, add / change as needed
params.input_file = ""
params.annotation = ""
params.expected_output = "tests/expected/expected_proActiv_count.csv"

include { icgcArgoRnaSeqAlternativePromoterProactiv } from '../proActiv'

process diff_count_csv {
  input:
    path output_file
    path expected_file

  output:
    stdout()

  script:
    """
    diff <(sort ${output_file}) <(sort ${expected_file}) \
      && ( echo "Test PASSED" && exit 0 ) || ( echo "Test FAILED, proActiv output csv files mismatch." && exit 1 )
    """
}


workflow checker {
  take:
    input_file
    annotation
    expected_output

  main:
    icgcArgoRnaSeqAlternativePromoterProactiv(
      input_file,
      annotation
    )

    diff_count_csv(
      icgcArgoRnaSeqAlternativePromoterProactiv.out.proactiv_csv,
      expected_output
    )
}


workflow {
  checker(
    file(params.input_file),
    file(params.annotation),
    file(params.expected_output)
  )
}
