# Test Error
tunningParameters <- c(optimalTuneSVM= optimalTuneSVM_OO)
testErrors <- c(ErrorSVM_OO, ErrorSVM_OA, ErrorNaiveBay, ErrorLDA, ErrorLogistic)
modelNames <- c('SVM_OneOne','SVM_OneAll','Naive_Bayes','LDA','Multinomial')
names(testErrors) <- modelNames

# Test Error Visualization
ggplot(data = as.data.frame(testErrors), aes(1:length(testErrors),testErrors)) + 
  geom_line(colour = 'blue') +
  geom_point(colour = 'red') +
  ggtitle('Model Comparison') + 
  ylab('Test Error') +
  xlab(' ') + 
  scale_x_discrete(limits=1:length(testErrors),
                   labels=modelNames) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1,size=10, color = "black"),
        axis.text.y = element_text(hjust = 1,size=15, color = "black"),
        #panel.background = element_rect(fill = 'white' ),
        plot.title = element_text(size = 20,colour="black"),
        legend.background = element_rect(fill = 'white' ), 
        panel.margin = unit(2, "line"), 
        panel.grid.major.x = element_line(color = "grey71"))


