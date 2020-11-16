#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
label: "python sam file parser"
baseCommand: ITS1_parser_ITSoneDB.py

hints:
  SoftwareRequirement:
    packages:
      python:
        specs: [ "https://www.python.org" ]
        version: [ "2.7" ]
      pysam:
        specs: [ "http://pysam.readthedocs.io/en/latest/#" ]
        version: [ "0.11.2.2" ]
      numpy:
        specs: [ "http://www.numpy.org" ]
        version: [ "1.12.1" ]

inputs:
  identity_threshold:
    type: ["null", int]
    inputBinding:
      separate: true
      prefix: -i
  coverage:
    type: ["null", int]
    inputBinding:
      separate: true
      prefix: -c
  fasta_itesondb:
    type: ["null", string]
    inputBinding:
      prefix: -f
      separate: true
  paired:
    type: ["null", string]
    inputBinding:
      prefix: -p
      separate: true
  single:
    type: ["null", string]
    inputBinding:
      prefix: -s
      separate: true
  outfile:
    type: string
    inputBinding:
      prefix: -o
      separate: true
  help_flag:
    type: ["null", boolean]
    inputBinding:
      prefix: -h

outputs:
  match_file:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
