#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinycssloaders)
library(shinyWidgets)
library(ggplot2)
library(plotly)
library(dplyr)
library(DT)

shinyServer(function(input, output,session) {
  

  
  
  lifting_cost_MMBTU <- reactive({
    lifting_cost_MMBTU <- input$lifting
  })
  
  lifting_cost_BOE <- reactive({
    lifting_cost_MMBTU <- lifting_cost_MMBTU()
    lifting_cost_BOE <- lifting_cost_MMBTU*6
    
  })
  
  Capex <- reactive({
    input$capex 
  })
  
  # Se genera el df cash donde estara representada toda la informacion economica del modelo
  
  cash <- reactive({
    
    lifting_cost_MMBTU <- lifting_cost_MMBTU()
    lifting_cost_BOE <- lifting_cost_BOE()
    capex <- Capex()
    
  cash<-    data.frame(Anio = curva_cf$Anio,
                     OPEX_MMBTU = lifting_cost_MMBTU*-curva_cf$Gas/1000/27.1,
                     OPEX_BOE = -lifting_cost_BOE*(curva_cf$Gas/0.159+curva_cf$Oil*6.29)/1000000,
                     CAPEX_MMBTU = 0, #averiguar
                     CAPEX_BOE = 0) #averiguar
    
                  cash$CAPEX_MMBTU[cash$Anio == 'ene-20'] = -capex/2
                  cash$CAPEX_MMBTU[cash$Anio == 'feb-20'] = -capex/2
                  cash$CAPEX_BOE[cash$Anio == 'ene-20'] = -capex/2
                  cash$CAPEX_BOE[cash$Anio == 'feb-20'] = -capex/2
                      
                    })
  
  # Manualmente se cambian los valores de enero y febrero de los dos capex a traves de la siguiente formula
  
  
  amortizaciones_1 <- reactive({
    
    cash <- cash()
    
    data.frame(Anio = curva_cf$Anio,
              capex_MMBTU = cash$CAPEX_MMBTU/sum(cash$CAPEX_MMBTU),
              capex_BOE = cash$CAPEX_BOE/sum(cash$CAPEX_BOE))
    })

  
  amortizaciones_2 <- reactive({
    
    amortizaciones_2 <- data.frame(Anio = curva_cf$Anio,
               Produccion = -(curva_cf$Oil*6.29+curva_cf$Gas*35.315/6)/1000000,
               Apropiación = 0,
               SI = 0, #averiguar
               SF = 0) #averiguar
    
    amortizaciones_2$Apropiación[amortizaciones_2$Anio == 'ene-20'] = produccion_parametro/2
    amortizaciones_2$Apropiación[amortizaciones_2$Anio == 'feb-20'] = produccion_parametro/2
  
    amortizaciones_2$Anio <- NULL
    
    for(i in  1:nrow(amortizaciones_2)){
      
      amortizaciones_2$SF[i] <- amortizaciones_2$Produccion[i] + amortizaciones_2$Apropiación[i] + amortizaciones_2$SI[i] 
      amortizaciones_2$SI[i + 1] <- amortizaciones_2$SF[i]
    }
    })

  
  # # Se cambian manualmente los valores de enero y febrero del segundo df a traves de la siguiente formula
  # amortizaciones_2$Apropiación[amortizaciones_2$Anio == 'ene-20'] = produccion_parametro/2
  # amortizaciones_2$Apropiación[amortizaciones_2$Anio == 'feb-20'] = produccion_parametro/2
  # 
  # Se elimina la columna Anio
  #amortizaciones_2$Anio <- NULL
  
  # A traves del siguiente bucle for generamos las columnas SF y SI que dependen la una de la otra
  #ERRROR AQUIIIIIIIIIIIIIIIIIIIIIIII!!!!!!!!!!!!
  # for(i in  1:nrow(amortizaciones_2)){
  #   
  #   amortizaciones_2$SF[i] <- amortizaciones_2$Produccion[i] + amortizaciones_2$Apropiación[i] + amortizaciones_2$SI[i] 
  #   amortizaciones_2$SI[i + 1] <- amortizaciones_2$SF[i]
  #   
  # }
  
  SI_BU <- reactive({
    0  #averiguar
    
  })
  
  
  amortizaciones <- reactive({
    SI_BU <- SI_BU()
    cash <- cash()
    amortizaciones_1 <- amortizaciones_1()
    amortizaciones_2 <- amortizaciones_2()
    
    amortizaciones <- cbind(amortizaciones_1, amortizaciones_2)
    
    amortizaciones$Alicuota <- -amortizaciones$Produccion/(amortizaciones$SI + amortizaciones$Apropiación)
    amortizaciones$DDyA[amortizaciones$Anio == "ene-20"] <- (SI_BU-cash$CAPEX_MMBTU[cash$Anio == "ene-20"]/1.5)*amortizaciones$Alicuota[amortizaciones$Anio == "ene-20"]
    amortizaciones$SI_2[amortizaciones$Anio == "ene-20"] <- SI_BU-cash$CAPEX_MMBTU[cash$Anio == "ene-20"]-amortizaciones$DDyA[amortizaciones$Anio == "ene-20"]
    
    for(i in 1:nrow(amortizaciones)){
      
      if(sum(amortizaciones$Produccion[i]:amortizaciones$Produccion[nrow(amortizaciones)]) == 0){
        amortizaciones$DDyA[i+1] <- (amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1])*amortizaciones$Alicuota[i+1]
      }
      else{
        amortizaciones$DDyA[i+1] <- (amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1]/1.5)*amortizaciones$Alicuota[i+1]
      }
      
      amortizaciones$SI_2[i+1] <- amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1]-amortizaciones$DDyA[i+1]
      
    }
    
    
    })
  
  # amortizaciones <- cbind(amortizaciones_1, amortizaciones_2)
  # amortizaciones$Alicuota <- -amortizaciones$Produccion/(amortizaciones$SI + amortizaciones$Apropiación)
  # 
  
  
  
  
 
  
  # Se calculan los valores para las columnas DDyA y SI_2 para enero de 2020
  #amortizaciones$DDyA[amortizaciones$Anio == "ene-20"] <- (SI_BU-cash$CAPEX_MMBTU[cash$Anio == "ene-20"]/1.5)*amortizaciones$Alicuota[amortizaciones$Anio == "ene-20"]
  #amortizaciones$SI_2[amortizaciones$Anio == "ene-20"] <- SI_BU-cash$CAPEX_MMBTU[cash$Anio == "ene-20"]-amortizaciones$DDyA[amortizaciones$Anio == "ene-20"]
  
  # for(i in 1:nrow(amortizaciones)){
  #   
  #   if(sum(amortizaciones$Produccion[i]:amortizaciones$Produccion[nrow(amortizaciones)]) == 0){
  #     amortizaciones$DDyA[i+1] <- (amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1])*amortizaciones$Alicuota[i+1]
  #   }
  #   else{
  #     amortizaciones$DDyA[i+1] <- (amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1]/1.5)*amortizaciones$Alicuota[i+1]
  #   }
  #   
  #   amortizaciones$SI_2[i+1] <- amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1]-amortizaciones$DDyA[i+1]
  #   
  # }
  
  regalias <- reactive({
    
    regalias <- as.numeric(input$regalias)
  })
  
  
  IIBB_Oil <- reactive({
    
    IIBB_Oil <- as.numeric(input$IIBB_Oil)
  })
  
  
  IIBB_Gas <- reactive({
    IIBB_Gas <- as.numeric(input$IIBB_Gas)
    
  })
  
  
  ventas <- reactive({
    
    
    ventas <- data.frame(Anio = precios$Anio, #faltara ese input
                       Oil = curva_cf$Oil*6.29*precios$Oil/1000000,
                       Gas = curva_cf$Gas/1000/27.1*precios$Gas,
                       LPG = precios$LPG*curva_cf$LPG/1000000)
    })
  
  cash <- reactive({
    cash <- cash()
    regalias <- regalias()
    IBB_oil <- IIBB_Oil()
    IBB_Gas <- IIBB_Gas()
    ventas <- ventas()
    
    for(i in  1:nrow(ventas)){
      
      cash$Ventas[i] <- ventas$Oil[i] + ventas$Gas[i] + ventas$LPG[i] 
      
    } 
    
    cash$regalias <- -cash$Ventas*regalias
    cash$IIBB <- -ventas$Oil*IIBB_Oil-ventas$Gas*IIBB_Gas
    
  })
  
  
  
  
  
  # Se realiza la suma de las ventas de Oil, Gas y LPG y se genera una columa en el df cash con el resultado
  # for(i in  1:nrow(ventas)){
  #   
  #   cash$Ventas[i] <- ventas$Oil[i] + ventas$Gas[i] + ventas$LPG[i] 
  #   
  # }
   
#   cash <- data1() 
#   cash$regalias <- -cash$Ventas*regalias
#   cash$IIBB <- -ventas$Oil*IIBB_Oil-ventas$Gas*IIBB_Gas
#   
  ITF <- reactive({
    input$ITF
  })
    
  cash <- reactive({
    cash <- cash()
    ITF <- ITF()
    
    cash$ITF <- cash$Ventas*-1*0.006*ITF+cash$OPEX_MMBTU[i]*0.006+cash$CAPEX_MMBTU*0.006+cash$IIBB*0.006+cash$regalias*0.006
    
  })  
  
  amortizaciones <- reactive({
    cash <- cash()
    amortizaciones <- amortizaciones()
    
    for(i in 1:nrow(amortizaciones)){
      
      amortizaciones$EBIT[i] <- cash$Ventas[i]+cash$OPEX_MMBTU[i]+cash$regalias[i]+cash$IIBB+cash$ITF[i]
      
    }
    
    # Calculo de base del IIGG con el siguiente bucle
    for(i in 1:nrow(amortizaciones)){
      
      amortizaciones$base_IIGG[i] <- amortizaciones$EBIT[i] - amortizaciones$DDyA[i]
      
    }
    
    # Se iguala el valor de enero 2020 de base IIGG Queb a base IIGG
    amortizaciones$base_IIGG_Queb[amortizaciones$Anio == "ene-20"] <- amortizaciones$base_IIGG[amortizaciones$Anio == "ene-20"]
    
    # Calculo del resto de valores de base IIGG Queb
    #ERROR AQUI!!!!!!!!!!!
    for(i in 1:nrow(amortizaciones)){
      
      if(amortizaciones$base_IIGG_Queb[i] < 0){
        amortizaciones$base_IIGG_Queb[i+1] <- amortizaciones$base_IIGG_Queb[i] + amortizaciones$base_IIGG[i+1]
      }
      else{
        amortizaciones$base_IIGG_Queb[i+1] <- amortizaciones$base_IIGG[i+1]
      }
      
    }
    
    
  })
  
  
  
  
  #cash$ITF <- cash$Ventas*-1*0.006*ITF+cash$OPEX_MMBTU[i]*0.006+cash$CAPEX_MMBTU*0.006+cash$IIBB*0.006+cash$regalias*0.006
  
  # Calculo del EBIT con el siguiente bucle
  # cash <- data1()
  # 
  # 
  # for(i in 1:nrow(amortizaciones)){
  #   
  #   amortizaciones$EBIT[i] <- cash$Ventas[i]+cash$OPEX_MMBTU[i]+cash$regalias[i]+cash$IIBB+cash$ITF[i]
  #   
  # }
  # 
  # # Calculo de base del IIGG con el siguiente bucle
  # for(i in 1:nrow(amortizaciones)){
  #   
  #   amortizaciones$base_IIGG[i] <- amortizaciones$EBIT[i] - amortizaciones$DDyA[i]
  #   
  # }
  # 
  # # Se iguala el valor de enero 2020 de base IIGG Queb a base IIGG
  # amortizaciones$base_IIGG_Queb[amortizaciones$Anio == "ene-20"] <- amortizaciones$base_IIGG[amortizaciones$Anio == "ene-20"]
  # 
  # # Calculo del resto de valores de base IIGG Queb
  # #ERROR AQUI!!!!!!!!!!!
  # for(i in 1:nrow(amortizaciones)){
  #   
  #   if(amortizaciones$base_IIGG_Queb[i] < 0){
  #     amortizaciones$base_IIGG_Queb[i+1] <- amortizaciones$base_IIGG_Queb[i] + amortizaciones$base_IIGG[i+1]
  #   }
  #   else{
  #     amortizaciones$base_IIGG_Queb[i+1] <- amortizaciones$base_IIGG[i+1]
  #   }
  #   
  # }
  
  
  aux_caudales <- reactive({
    # Creacion del df de auxiliar de caudales
  aux_caudales <- data.frame(Anio = curva_cf$Anio,
                             Prod_Oil = curva_cf$Oil*6.29/1000,
                             QOil = curva_cf$Oil*6.29/(365.25/12),
                             Prod_Gas = curva_cf$Gas/1000)
  aux_caudales$QGas <- aux_caudales$Prod_Gas/365.25*12
    
  })
  
  #### CALCULO PAY OUT ####
  IIGG_2020 <- reactive({
    
    IIGG_2020 <- input$IIGG_2020
  })
  
  
  cash <- reactive({
    IIGG_2020 <- IIGG_2020()
    cash <- cash()
    amortizaciones  <-  amortizaciones()
    
    for(i in 1:nrow(cash)){
      
      cash$FF_preIIGG[i] <- cash$OPEX_MMBTU[i] + cash$CAPEX_MMBTU[i] + cash$Ventas[i] + cash$regalias[i] + cash$IIBB[i] + cash$ITF[i]
      
    }
    
    for(i in 1:nrow(cash)){
      
      if(-amortizaciones$base_IIGG_Queb[i]*IIGG_2020 > 0){
        cash$IIGG[i] <- 0
      }
      else{
        cash$IIGG[i] <- -amortizaciones$base_IIGG_Queb[i]*IIGG_2020
      }
      
    }
    
    for(i in 1:nrow(cash)){
      
      cash$FF[i] <- cash$FF_preIIGG[i] + cash$IIGG[i]
      
    }
  })
  
    pay_out <- reactive({
      pay_out <- data.frame(Anio = curva_cf$Anio)
       
      cash <- cash()
      pay_out$FF_acum[1] <- cash$FF[1]
      
      for(i in 1:nrow(cash)){
        
        pay_out$FF_acum[i+1] <- pay_out$FF_acum[i] + cash$FF[i+1]
        
      }
      
    })
    
    # Valor Y para el calculo de Anios
    cash <- reactive({
      
      cash <- cash()
      
      for(i in 1:nrow(cash)){
        
        if(i <= 3){
          cash$Y[i] <- 0
        }
        else{
          cash$Y[i] <- cash$FF[i]
        }
        
      }
    })
    
    # Calculo de la columna Anios
    
    pay_out <- reactive({
      
      pay_out <- pay_out()
      cash <- cash()
      
      for(i in 1:nrow(pay_out)){
        
        if(pay_out$FF_acum[i+1]<0){
          pay_out$Anios[i+1] <- 1/12
        }
        else{
          if(pay_out$FF_acum[i]>0){
            pay_out$Anios[i+1] <- 0
          }
          else{
            pay_out$Anios[i+1] <- -pay_out$Anios[i]/cash$Y[i+1]*(1/12)
          }
        }
        
      }
      
      pay_out$FF_acum <- round(pay_out$FF_acum,2)
      pay_out$Anios[1] <- 0
      
    })
   
    
    cash <- reactive({
      
      cash <- cash()
      cash$Anio <- fechas[0:58] #validar
      
    })
    
    # Se calcula todo con la siguiente tasa de descuento
    tdescuento <- reactive({
      tdescuento <- as.numeric(input$desc)
      
    })  
    
    VAN <- reactive({
      tdescuento <- tdescuento()
      cash <- cash()
      
      VAN <- npv(tdescuento, cash$FF)
    })
    
    TIR <- reactive({
      cash <- cash()
      
      TIR <- irr(cash$FF)*100
      
    })
    
    IA <- reactive({
      tdescuento <- tdescuento()
      cash <- cash()
      
      IA <- npv(tdescuento, cash$CAPEX_MMBTU)*-1
    }) 
    
    
    VAN_IA <- reactive({
      VAN <- VAN()
      IA <- IA()
      
      VAN_IA <- VAN/IA
      
    })
      
    output$calc1 <- renderText({
      VAN <- VAN()
      
    })
    
    output$calc2 <- renderText({
      TIR <- TIR()
    })
    
   
    output$calc4 <- renderText({
      VAN_IA <- VAN_IA()
      VAN_IA
  
    })
    
    
  output$acumulada <- DT::renderDataTable({
    pay_out <- pay_out()
    
    pay_out},
    options = list(
      autoWidth = TRUE,
      columnDefs = list(list(width = '400px', targets = c(1,2)))
    ))
  
  
  
  #td <- reactive({
      #as.numeric(input$desc)
    #npv(r = input$lifting, cash$FF)
  #})
  
   #calc111 <- reactive({
  #   td <- as.numeric(input$desc)
  #   npv(td, cash$FF)
  # })   
      
  
  
  output$acum <- renderPlotly({
    pay_out <- pay_out()
    
    ggplot(data=pay_out, aes(x=Anio, y=FF_acum, group=1))+
      geom_line() +
      geom_point()+ 
    labs(title = 'Visualizacion de Flujo de Caja')+
      xlab('Fecha')+ylab('Efectivo Esperado')+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  })
  
})

#-3.268728/4.673913
