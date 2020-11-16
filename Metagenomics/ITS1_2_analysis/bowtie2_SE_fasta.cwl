#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
label: "bowtie2 execution script: Single End mode"
baseCommand: bowtie2

hints:
  SoftwareRequirement:
    packages:
      bowtie2:
        specs: [ "http://bowtie-bio.sourceforge.net/bowtie2/index.shtml" ]
        version: [ "2.3.4.1" ]

inputs:
  seed_n:
    type: int
    inputBinding:
      position: 1
      separate: false
      prefix: -N
  match_n:
    type: int
    inputBinding:
      prefix: -k
      separate: false
      position: 2
  index_loc:
    type: Any
    inputBinding:
      position: 3
      prefix: -x
      separate: true
  input_FASTA:
    type:
      type: array
      items: string
    inputBinding:
      prefix: -f
      separate: true
      itemSeparator: ","
      position: 4
  output_sam:
    type: string
    inputBinding:
      prefix: -S
      separate: true
      position: 6
  processors:
    type: int
    inputBinding:
      prefix: -p
      separate: true
      position: 5
  local_alignment:
    type: boolean
    inputBinding:
      position: 7
      prefix: --local
  unaligned_items:
    type: boolean
    inputBinding:
      position: 8
      prefix: --no-unal


outputs:
  output_file_sam:
    type: File
    outputBinding:
      glob: $(inputs.output_sam)
