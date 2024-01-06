server <- function(input, output, session) {
  
  # reactive values----
  ho <- reactiveValues(
    pg = 1, # the selected webpage number
    hm = 1  # the selected image on the home page
  )
  
  # wallpaper----
  output$wallppr <- renderUI(
    if (ho$pg == 1) {
      setBackgroundImage(
        paste0('hotel1_', ho$hm, '.jpg')
      )
    } else if (ho$pg >= 2) {
      setBackgroundImage(paste0('hotel', ho$pg, '.jpg'))
    }
  )
  
  # ui tabs----
  output$uiTabs <- renderUI(
    div(
      style = 'padding:10px 0 0 0;',
      align = 'center',
      lapply(
        1:7,
        function(i) {
          tabBttn(i)
        }
      ),
      hr(style = 'border: single white 3px;')
    )
  )
  
  # function to change look of tab when selected
  tabBttn <- function(i) {
    t <- actionBttn(
      inputId = ti[i],
      label = tl[i],
      style = ifelse(ho$pg == i, 'simple', 'stretch'),
      color = ifelse(ho$pg == i, 'default', 'default'),
      size = 'sm'
    )
    return(t)
  }
  
  # _event tab buttons----
  observeEvent(eventExpr = input$home, {ho$pg <- 1})
  observeEvent(eventExpr = input$loca, {ho$pg <- 2})
  observeEvent(eventExpr = input$acco, {ho$pg <- 3})
  observeEvent(eventExpr = input$dini, {ho$pg <- 4})
  observeEvent(eventExpr = input$amen, {ho$pg <- 5})
  observeEvent(eventExpr = input$attr, {ho$pg <- 6})
  observeEvent(eventExpr = input$abou, {ho$pg <- 7})
  
  # ui home page----
  output$uiHome <- renderUI(
    if (ho$pg == 1) {
      div(
        div(
          align = 'left',
          style = 'padding:40vh 0 0 5%;',
          img(
            src = 'cu.png',
            width = '100px'
          ),
          h1(
            style = 'color:white;',
            'Namibia SQL'
          ),
          h3(
            style = 'color:white; padding:0; margin:0;',
            'Your Dream Destination'
          )
        ),
        div(
          align = 'center',
          style = 'padding:20vh 0 10px 0;',
          actionBttn(
            inputId = 'home1',
            label = '<',
            style = 'jelly',
            color = 'default',
            size = 'sm'
          ),
          actionBttn(
            inputId = 'home2',
            label = '>',
            style = 'jelly',
            color = 'default',
            size = 'sm'
          )
        )
      )
    }
  )
  
  # _event home slide buttons----
  observeEvent(eventExpr = input$home1, {ho$hm <- switch(ho$hm, 3, 1, 2)})
  observeEvent(eventExpr = input$home2, {ho$hm <- switch(ho$hm, 2, 3, 1)})
  
  # ui loca page----
  output$uiLoca <- renderUI(
    if (ho$pg == 2) {
      fluidRow(
        column(
          width = 6,
          style = 'padding:30vh 10% 0 10%;',
          h3(
            style = 'color:white;',
            paste0(
              'Discorver the rugged beauty at Namibia SQL.',
              'The perfect base for exploring the stunning landscapes, ',
              'vibrant culture, and unique wildlife of this incredible country. ',
              'Book your stay today and experience the best of Namibia!'
            )
          )
        ),
        column(
          width = 6,
          style = 'padding:0 25px 0 0;',
          wellPanel(
            leafletOutput(
              outputId = 'hotMap',
              height = '80vh'
            )
          )
        )
      )
    }
  )
  
  # _hotel map----
  output$hotMap <- renderLeaflet(
    {
      leaflet() %>% 
        addTiles() %>% 
        addMarkers(
          lat = hlat,
          lng = hlng
        ) %>% 
        setView(
          lat = hlat,
          lng = hlng,
          zoom = 5
        )
    }
  )
}