shinyUI(
pageWithSidebar(
 headerPanel("property value Minsk 2016"),
 sidebarPanel(
 selectInput("district", "Choose a district:", 
                choices = c("Moskowsky", "Oktyabrsky", "Partizansky", "Pervomaisky", "Sovetsky", "Centralny")),

selectInput("tipdoma", "Choose a construction:", 
                choices = c("brick", "solid", "panel")),

selectInput("planirovka", "Choose a type:", 
                choices = c("new building", "standard", "advanced")),

 
radioButtons("remont", "Choose a renovation:", 
                choices = c("No", "Yes")),

selectInput("mrasst.f", "Choose a distance from subway(m.):", 
                choices = c("(0,100]", "(100,500]", "(500,1000]", "(1000,2000]")),

sliderInput('area1', 'flat area, m2',value = 25, min = 25, max = 100, step = 1)

# submitButton('Submit')
 ),

 mainPanel(
  h4('Square meter value (USD)'),
   h3(textOutput("price"))
#  h3(textOutput("t1")),
#     h3(textOutput("t2")),
#    h3(textOutput("t3")),
#    h3(textOutput("t4")),
#    h3(textOutput("t5")),
#     h3(textOutput("t6"))
 )

))
