class Transaction < ApplicationRecord
  has_many :transaction_details, dependent: :destroy
  accepts_nested_attributes_for :transaction_details, reject_if: ->(attributes){ attributes['id'].blank? }, allow_destroy: true
  belongs_to :status, class_name: :Status, foreign_key: :status_id, optional: false
  belongs_to :dealer
  belongs_to :carrier, class_name: :Carrier, foreign_key: :carrier_id, optional: true
  belongs_to :courier, -> { where courier: true }, class_name: :Dealer#, foreign_key: :id, optional: true
  belongs_to :type, -> { where tag: 'TRANSACTION_TYPE' }, class_name: :Parameter, foreign_key: 'type_id', primary_key: 'int_value'
  belongs_to :delivery, class_name: :Delivery, foreign_key: :delivery_id

  def closed?(tag)
    status == Status.closed(tag).first
  end

  def open?(tag)
    status == Status.initial(tag).first
  end

  def on_route?(tag)
    status == Status.on_route(tag).first
  end

  def not_delivery?(tag)
    status == Status.not_delivery(tag).first
  end

  def delivered?(tag)
    status == Status.delivered(tag).first
  end

  scope :pending_to_packing, ->(tag) { where(status: Status.closed(tag), type_id: 2) }
  scope :pending_to_deliver, ->(tag, courier_id) { where(status: Status.on_route(tag), courier_id: courier_id) }
  scope :delivered_courier, ->(tag, courier_id) { where(status: [Status.not_delivery(tag).first, Status.delivered(tag).first], courier_id: courier_id) }
  scope :watching_to_deliver, ->(tag) { where(status: Status.on_route(tag)) }
  scope :delivered, ->(tag) { where(status: [Status.not_delivery(tag).first, Status.delivered(tag).first]) }
  scope :delivered_liq, ->(tag) { where(status: Status.delivered(tag).first) }
  scope :not_delivered_liq, ->(tag) { where(status: Status.not_delivery(tag).first) }
  scope :pending_to_close, ->(tag) { where(status: Status.finished(tag)) }

  ransacker :created_at do
    Arel.sql('date(created_at)')
  end

  def self.to_csv
    attributes = %w{id description client address address2 phone amount estado vendedor tracking_number transportista fecha mensajero productos }
    CSV.generate(headers: true) do |csv|
      csv << attributes

      report.each do |transaction|
        csv << attributes.map{ |attr| transaction.send(attr) }
      end
    end
  end

  def self.report
    t = Transaction.arel_table
    s = Status.arel_table
    d = Dealer.arel_table
    ca = Carrier.arel_table
    co = Dealer.arel_table
    dt = TransactionDetail.arel_table
    p = Product.arel_table
    join_on = dt.create_on(t[:id].eq(dt[:transaction_id]))
    inner_join = dt.create_join(t, join_on)
    select_array = TransactionDetail.select(Arel::Nodes::NamedFunction.new('CONCAT',
      [literal("'|'"), p[:description], literal("'-'"), dt[:unit_price], literal("'-'"),
      dt[:quantity], literal("'|'")])).joins(:product).where(t[:id].eq(dt[:id])).to_sql + ")"
    array_productos = Arel::Nodes::NamedFunction.new('ARRAY', [Arel::Nodes::SqlLiteral.new(select_array)])
    Transaction.select(t[:id], t[:description], t[:client], t[:address], t[:address2], t[:phone],
      t[:amount], s[:description].as('ESTADO'), concat(d[:name], d[:last_name], 'VENDEDOR'),
     t[:tracking_number], ca[:name].as('TRANSPORTISTA'),
     Arel::Nodes::NamedFunction.new('TO_CHAR',
       [t[:created_at], Arel::Nodes::SqlLiteral.new("'dd/mm/yyy'")]).as('FECHA'),
     concat(co[:name], co[:last_name], 'MENSAJERO'),
     (Arel::Nodes::NamedFunction.new('(SELECT', [Arel::Nodes::SqlLiteral.new(array_productos.to_sql)], 'PRODUCTOS'))
     ).joins(:status, :dealer, :carrier, :courier)
  end

  def self.concat(first, second, as)
    Arel::Nodes::NamedFunction.new('CONCAT', [first, Arel::Nodes.build_quoted(' '), second], as)
  end

  def self.literal(str)
    Arel::Nodes::SqlLiteral.new(str)
  end

  #Transaction.select(t[:id], t[:description], t[:client], t[:address], t[:address2], t[:phone],
  # t[:amount], s[:description].as('ESTADO'), concat(d[:name], d[:last_name], 'VENDEDOR'),
  #t[:tracking_number], ca[:name].as('TRANSPORTISTA'),
  #Arel::Nodes::NamedFunction.new('TO_CHAR',
  #  [t[:created_at], Arel::Nodes::SqlLiteral.new("'dd/mm/yyy'")]).as('FECHA'),
  #concat(co[:name], co[:last_name], 'MENSAJERO'),
  #(Arel::Nodes::NamedFunction.new('(SELECT', [Arel::Nodes::SqlLiteral.new(array_productos.to_sql)], 'PRODUCTOS'))
  #).joins(:status, :dealer, :carrier, :courier).to_sql

#
#  SELECT T.ID, T.DESCRIPTION, T.CLIENT, T.ADDRESS, T.ADDRESS2,
#T.PHONE, T.AMOUNT, S.DESCRIPTION ESTADO, CONCAT(D.NAME, ' ', D.LAST_NAME) VENDEDOR,
#T.TRACKING_NUMBER, CA.NAME TRANSPORTISTA, TO_CHAR(T.CREATED_AT, 'dd/mm/yyyy') FECHA,
#CONCAT(CO.NAME, ' ', CO.LAST_NAME) MENSAJERO,
#(SELECT ARRAY(SELECT '|' || P.DESCRIPTION || '-' || DT.UNIT_PRICE || '-' || DT.QUANTITY || '|' FROM
#TRANSACTION_DETAILS DT INNER JOIN PRODUCTS P ON P.ID = DT.PRODUCT_ID WHERE DT.TRANSACTION_ID = T.ID)) PRODUCTOS
#FROM TRANSACTIONS T
#INNER JOIN STATUSES S ON S.ID = STATUS_ID
#INNER JOIN DEALERS D ON D.ID = DEALER_ID
#INNER JOIN CARRIERS CA ON CA.ID = CARRIER_ID
#INNER JOIN DEALERS CO ON CO.ID = COURIER_ID AND CO.COURIER = TRUE;
end
