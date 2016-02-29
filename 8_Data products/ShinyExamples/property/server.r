# library(caret)
library(MASS)

mutch <- function(t){
    t1 <- c("Зав", "Лен", "Мос", "Окт", "Пар", "Пер", "Сов", "Фр", "Цен", "кирпичный", "монолитный", "панельный", "новостройка", "стандартный проект", "улучшеный проект", "хороший ремонт", "без отделки", "(0,100]", "(100,500]", "(500,1e+03]", "(1e+03,2e+03]")
    t2 <- c("Zavodskoy","Leninsky","Moskowsky","Oktyabrsky","Partizansky","Pervomaisky","Sovetsky","Frunzensky","Centralny","brick","solid","panel","new building","standard","advanced","Yes","No","(0,100]","(100,500]","(500,1000]","(1000,2000]")
    t1[which(t2==t, arr.ind = T)]
    }

predictvalue <- function(t1,t2,t3,t4,t5,t6){
        load(file="fit_lda.RData")
        tt <- data.frame(district=t1, tipdoma=t2, 
                         planirovka=t3, remont=t4,
                         mrasst.f=mutch(t5), area1=numeric(t6), stringsAsFactors = F)#, pricem2.f="(1100,1200)")
        p1 <- predict(fit_lda, tt)
        p1$class[1]
        #(as.numeric(sub(x = p1, "\\((\\d+),(\\d+)\\)", replacement = "\\1"))+as.numeric(sub(x=p1, "\\((\\d+),(\\d+)\\)", replacement = "\\2")))/2*as.numeric(t6)
}

shinyServer(
    function(input, output) {
#         output$t1 <- renderPrint(mutch(input$district))
#         output$t2 <- renderPrint(mutch(input$tipdoma))
#         output$t3 <- renderPrint(mutch(input$planirovka))
#         output$t4 <- renderPrint(mutch(input$remont))
#         output$t5 <- renderPrint(mutch(input$mrasst.f))
#         output$t6 <- renderPrint(input$area1)
        
        output$price <- renderPrint({as.character(predictvalue(input$district, input$tipdoma, 
                                                               input$planirovka, input$remont, 
                                                               input$mrasst.f, input$area1))}) #pred[1]) #pred
    }
)