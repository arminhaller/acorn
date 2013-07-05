#! /usr/bin/env python

import ConfigParser 
import fileinput
import sys
from os import listdir

config=ConfigParser.ConfigParser()
config.readfp(open('./IPconfig.cfg'))

#get machine config containing new machine paths.
sparql = config.get('Virtuoso', 'sparql')
eldaAPI = config.get('Elda', 'api')

#shouldn't need to modify these paths unless acorn.ttl is changed directly
oldsparql='http://ec2-54-251-3-66-ap-southeast-1.compute.amazonaws.com:8890/sparql'
oldeldaAPI='http://lab.environment.data.gov.au'

#files to fix
obsdir = './rdf/observations'
ontologydir = './rdf/ontology'
filelist =['./acorn.ttl']




for filename in listdir(obsdir):
	filelist.append(obsdir+'/'+filename)

for filename in listdir(ontologydir):
	filelist.append(ontologydir+'/'+filename)
print filelist	


#replace strings in ttl, rdf and owl files.
for filename in filelist:
        for line in fileinput.FileInput(filename,inplace=1):
                line = line.replace(oldsparql, sparql)
                sys.stdout.write(line)
        for line in fileinput.FileInput(filename,inplace=1):
                line = line.replace(oldeldaAPI, eldaAPI)
                sys.stdout.write(line)
