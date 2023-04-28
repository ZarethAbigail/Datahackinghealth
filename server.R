# server ------------------------------------------------------------------

server <- function(input, output) { 
  
  # Carga de datos ----------------------------------------------------------
  
  datos <- reactive({
    file <- input$archivo
    if(is.null(file)){return()} 
    read_csv(file$datapath, show_col_types = FALSE) %>% 
      select( Nombre = v2,
              Apellido = v3,
              Genero = v4,
              Peso = v5,
              Altura = v6,
              Minutos = v7,
              `Examen 1` = v8,
              `Examen 2` = v9,
              `Examen 3` = v10) %>% 
      mutate(Altura = Altura*100) %>% 
      mutate(Genero = case_when(Genero == 1 ~ "Hombre",
                                Genero == 2 ~ "Mujer",
                                Genero == 3 ~ "Otro")) %>% 
      mutate(Nombre_Completo = paste(Nombre, Apellido)) %>% 
      mutate(Peso = Peso + 0.5) %>%
      select(Nombre_Completo, 3:9)
  })
  
  # Tabla de datos ----------------------------------------------------------
  
  output$tabla <- renderDataTable({
    datatable(datos(),
              rownames = FALSE)
  })
  
  # Grafica -----------------------------------------------------------------
  
  output$grafica <- renderPlotly({
    ggplotly(
      ggplot(datos(), aes(x = datos()[[input$variable_x]], 
                          y = datos()[[input$variable_y]])) + 
        geom_point() +
        geom_smooth(method ='lm', se = FALSE, color ='dodgerblue1') +
        labs(title = paste("Grafica de", input$variable_x, "vs", input$variable_y),
             x = "Nombre del eje x",
             y = input$variable_y) +
        theme_minimal() +
        theme(plot.title = element_text(hjust = 0.5, size = 20))
    )
  })
  
  # Textos ------------------------------------------------------------------
  
  output$conteo_hombres <- renderText({
    paste("La cantidad de pacientes hombres es: ", 
          nrow(datos() %>% filter(Genero == "Hombre")))
    
  })
  output$conteo_mujeres <- renderText({
    paste("La cantidad de pacientes mujeres es: ", 
          nrow(datos() %>% filter(Genero == "Mujer")))
    
  })
  
  
  
  # Cajas de información ----------------------------------------------------
  
  output$promedio_minutos <- renderInfoBox({
    
    infoBox(title = paste("Promedio de minutos"), 
            value = round(mean(datos()$minutos), 2),
            color = "light-blue"
    )
    
  })
  
  output$nueva_box <- renderInfoBox({
    
    infoBox(title = paste("Caja nueva"), 
            value = 2+2,
            color = "red"
    )
    
  })
  
  # Fin ---------------------------------------------------------------------
  
}