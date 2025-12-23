from datetime import datetime

from sqlalchemy import (BigInteger, Boolean, Column, DateTime, Integer,
                        Numeric, String)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class TTransaction(Base):
    __tablename__ = "t_transaction"

    id = Column(Integer, primary_key=True, autoincrement=True)

    m_customer_id = Column(Integer, nullable=False)

    mti = Column(String(4), nullable=True)
    transaction_type = Column(String(2), nullable=False, default="")
    card_number = Column(String(20), nullable=True)

    transaction_amount = Column(Numeric(30, 5), nullable=True)
    fee_indicator = Column(String(1), nullable=True)
    fee = Column(Numeric(30, 5), nullable=True)

    transmission_date = Column(DateTime, nullable=True)
    transaction_date = Column(DateTime, nullable=True)
    value_date = Column(DateTime, nullable=True)

    conversion_rate = Column(Numeric(30, 5), nullable=True)

    stan = Column(Numeric(6), nullable=True)
    merchant_type = Column(String(4), nullable=True)
    terminal_id = Column(String(8), nullable=True)

    reference_number = Column(String(12), nullable=True)
    approval_number = Column(String(12), nullable=True)
    response_code = Column(String(2), nullable=True)
    currency_code = Column(String(3), nullable=True)

    customer_reference = Column(String(50), nullable=True)
    biller_name = Column(String(50), nullable=True)

    from_account_number = Column(String(20), nullable=True)
    to_account_number = Column(String(20), nullable=True)

    from_account_type = Column(String(2), nullable=False, default="00")
    to_account_type = Column(String(2), nullable=False, default="00")

    balance = Column(String(100), nullable=True)
    description = Column(String(250), nullable=True)

    to_bank_code = Column(String(3), nullable=True)
    execution_type = Column(String(10), nullable=False, default="N")
    status = Column(String(10), nullable=False)

    translation_code = Column(String(1000), nullable=True)

    free_data1 = Column(String(99999), nullable=True)
    free_data2 = Column(String(99999), nullable=True)
    free_data3 = Column(String(1000), nullable=True)
    free_data4 = Column(String(1000), nullable=True)
    free_data5 = Column(String(1000), nullable=True)

    delivery_channel = Column(String(10), nullable=True)
    delivery_channel_id = Column(String(50), nullable=True)

    created = Column(DateTime, default=datetime.now, nullable=False)
    createdby = Column(Integer, default=1, nullable=False)

    updated = Column(DateTime, default=datetime.now, onupdate=datetime.now, nullable=False)
    updatedby = Column(Integer, default=1, nullable=False)

    archive = Column(Boolean, default=False)
    t_transaction_queue_id = Column(Integer, nullable=True)

    biller_id = Column(String(20), nullable=True)
    product_id = Column(String(20), nullable=True)
