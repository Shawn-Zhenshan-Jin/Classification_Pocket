########################
# Model Comparison based on Final Test Error
########################
ggplot(data = as.data.frame(testError), aes(1:length(testError),testError)) + 
  geom_line() +
  geom_point() +
  ggtitle('Model Comparison') + 
  ylab('Test Error') +
  xlab(' ') + 
  scale_x_discrete(limits=1:length(testError),
                   labels=modelNames) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1,size=10, color = "black"),
        axis.text.y = element_text(hjust = 1,size=15, color = "black"),
        #panel.background = element_rect(fill = 'white' ),
        plot.title = element_text(size = 20,colour="black"),
        legend.background = element_rect(fill = 'white' ), 
        panel.margin = unit(2, "line"), 
        panel.grid.major.x = element_line(color = "grey71"))
