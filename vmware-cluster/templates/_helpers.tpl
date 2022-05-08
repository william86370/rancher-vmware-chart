{{/*
Expand the name of the chart.
*/}}
{{- define "vmware-cluster.name" -}}
{{- default .Chart.Name .Values.cluster.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vmware-cluster.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "vmware-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vmware-cluster.labels" -}}
helm.sh/chart: {{ include "vmware-cluster.chart" . }}
{{ include "vmware-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "vmware-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vmware-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Create the name of the server pool
*/}}
{{- define "vmware-cluster.serverPoolName" -}}
{{- printf "%s-serverpool" (include "vmware-cluster.fullname" .) | replace "+" "-" | replace "." "-" | trunc 63 }}
{{- end }}

{{/*
Create the name of the agent pool
*/}}
{{- define "vmware-cluster.agentPoolName" -}}
{{- printf "%s-agentpool" (include "vmware-cluster.fullname" .) | replace "+" "-" | replace "." "-" | trunc 63  }}
{{- end }}


{{/*
Define the namespace for the nodepools
*/}}
{{- define "vmware-cluster.nodePoolNamespace" -}}
{{- default "fleet-default" .Values.cluster.namespace }}
{{- end }}
{{/*

Define the name for vsphere credentials
*/}}
{{- define "vmware-cluster.vsphereCredentalName" -}}
{{- printf "%s-vsphere-credentals" (include "vmware-cluster.fullname" .) }}
{{- end }}

{{/*
Create the Base Vmware Cluster Config for the Server and Agent Node-Pools
*/}}
{{- define "vmware-cluster.vmwareBaseVMConfig" -}}
# If using a Content Library, specify the name of the library and the image name
{{- if .Values.baseImageConfig.useContentLibrary }}
creationType: library
contentLibrary: {{ .Values.baseImageConfig.contentLibrary.contentLibraryName }}
cloneFrom: {{ .Values.baseImageConfig.contentLibrary.imageName }}
cloudConfig: {{ .Values.baseImageConfig.contentLibrary.cloudConfig }}
{{- end }}
# Define VMware vSphere Cluster Config
datacenter: {{ .Values.vmwareClusterConfig.dataCenter }}
datastore: {{ .Values.vmwareClusterConfig.dataStore }}
folder: {{ .Values.vmwareClusterConfig.folder }}
pool: {{ .Values.vmwareClusterConfig.resourcePool }}
hostsystem: {{ .Values.vmwareClusterConfig.hostSystem }}
network: 
  {{ toYaml .Values.vmwareClusterConfig.network | nindent 2  }}
datastoreCluster: ""
vcenter: ""
vcenterPort: {{ quote .Values.vmwareCredentials.port }}
# Static VMware Docker Machine Driver Config
boot2dockerUrl: null
cfgparam: #TODO Maybe allow for custom cfgparams
  - disk.enableUUID=TRUE
common:
  labels: null
  taints: []
customAttribute: []
tag: []
os: linux
vappIpallocationpolicy: null
vappIpprotocol: null
vappProperty: []
vappTransport: null
# Docker Machine Default Login User
cloudinit: ""
username: ""
password: ""
sshPassword: tcuser
sshPort: "22"
sshUser: docker
sshUserGroup: staff
{{- end }}