# frozen_string_literal: true

sale_liquidada = Status.create(description: 'LIQUIDADA', tag: 'SALE', parent: nil)
sale_entregada = Status.create(description: 'ENTREGADA', tag: 'SALE', parent: sale_liquidada)
sale_en_ruta = Status.create(description: 'EN RUTA', tag: 'SALE', parent: sale_entregada)
sale_procesada = Status.create(description: 'PROCESADA', tag: 'SALE', parent: sale_en_ruta)
Status.create(description: 'CREADA', tag: 'SALE', parent: sale_procesada)
Status.create(description: 'DEVOLUCION', tag: 'SALE', parent: nil)
Status.create(description: 'NO ENTREGADA', tag: 'SALE', parent: nil)
