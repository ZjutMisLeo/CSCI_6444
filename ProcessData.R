filePath = "C:/Users/L/Desktop/Big Data/Project1/Circles"
FeaturesPath = "C:/Users/L/Desktop/Big Data/Project1/Features"
FeaturesPath = "C:/Users/L/Desktop/Big Data/Project1/FeatureNames"

files = list.files(path = filePath, full.names = T, recursive = T)
#create a datafram to store edges
relations = data.frame() 
#ccreate a list to store name                             
name = data.frame()
nameList = as.list(name)                                 
i = 1
for (path in files){
	g = scan(path)
	if (!inherits(g, 'try-error')) g                       # I am not sure scan() will catch blank here.
	gList = as.list(g)
	circleSeq = scan(path, what = 'list', flush = T)       # the number of circle in each file, dont know how to process
    name = gsub("C:/Users/L/Desktop/Big Data/Project1/Circles/", "", path)
    name = gsub(".circles", "", name)
    nameList[i] = name
    i = i + 1
	if (length(gList) != 0) {                              # skip the empty file, we already have all nodes in nameList
		for (temp in gList){                           # use this for loop to get edges of the node
			if (temp > 100) {
				test = data.frame(from = name, to = temp)  
		        relations = rbind(relations, test)
		    }
		}
	}
}

users = data.frame(name = nameList)
                   #Features = ,
                   #FeatureNames = )

g = graph_from_data_frame(relations, directed = TRUE, vertices = users)
is.simple(g)                                                   # check duplicate
g = simplify(g)
plot(g, vertex.size = 5, vertex.label = NA, layout=layout.auto, edge.color = grey(0.5), edge.arrow.mode = "-")

