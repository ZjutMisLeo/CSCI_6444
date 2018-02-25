library(igraph)
filePath = "C:/Users/L/Desktop/Big Data/Project1/Features"

files = list.files(path = filePath, full.names = T, recursive = T)
#create a datafram to store edges
relations = data.frame() 
#ccreate a list to store name of each file                           
nameList = as.list(data.frame())          
vertices = as.list(data.frame())       
for (path in files){
	#get the first column of node
	#subNode = scan(path, what = 'list', flush = T)
    feat = read.table(path, stringsAsFactors = F)    
    name = gsub("C:/Users/L/Desktop/Big Data/Project1/Features/", "", path)
    name = as.numeric(gsub(".feat", "", name))
    nameList = c(nameList, name)
    #here we get feature name of this file
    featureNamePath = paste("C:/Users/L/Desktop/Big Data/Project1/FeatureNames/", name, ".featnames", sep = "")
    featureName = read.table(featureNamePath, stringsAsFactors = F, comment.char = '~', fill = TRUE)
    for(row in 1:nrow(feat)) {
        for(col in 1:ncol(feat)) {
            if (col == 1) {
                #first column here is the sub node
                test = data.frame(from = name, to = feat[row, col])
                relations = rbind(relations, test)
                vertices = c(vertices, as.numeric(feat[row, col]))
            }else {
                if (feat[row, col] == 0){

                }else {
                    #somedatastructure.add featureName[col][2]
                }
            }
        }
    }
}
#
#Add edges to make it a ring
> g = g + path(circles[0][,1], circles[0][0], color = "grey")
