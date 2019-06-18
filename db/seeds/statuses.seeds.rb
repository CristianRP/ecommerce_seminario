# frozen_string_literal: true

sale_finalizada = Status.create(description: 'FINALIZADA', tag: 'SALE')
sale_liquidada = Status.create(description: 'LIQUIDADA', tag: 'SALE', parent: sale_finalizada)
sale_entregada = Status.create(description: 'ENTREGADA', tag: 'SALE', parent: sale_liquidada)
sale_en_ruta = Status.create(description: 'EN RUTA', tag: 'SALE', parent: sale_entregada)
sale_procesada = Status.create(description: 'PROCESADA', tag: 'SALE', parent: sale_en_ruta)
sale_creada = Status.create(description: 'CREADA', tag: 'SALE', parent: sale_procesada)
