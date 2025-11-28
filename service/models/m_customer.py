from sqlalchemy import Column, BigInteger, Integer, String, Numeric, DateTime, Boolean
from sqlalchemy.sql import func
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

Base = declarative_base()

class MCustomer(Base):
    __tablename__ = "m_customer"

    id = Column(Integer, primary_key=True, autoincrement=True)

    customer_name = Column(String(30), nullable=False)
    customer_username = Column(String(50), nullable=False)
    customer_pin = Column(String(200), nullable=False)

    customer_phone = Column(String(20), nullable=True)
    customer_email = Column(String(50), nullable=True)
    cif_number = Column(String(30), nullable=True)

    failed_login_attempts = Column(Integer, default=0)
    failed_ib_token_attempts = Column(Integer, default=0)
    failed_mb_token_attempts = Column(Integer, default=0)

    ib_status = Column(String(1), nullable=True)
    mb_status = Column(String(1), nullable=True)

    previous_ib_status = Column(String(1), nullable=True)
    previous_mb_status = Column(String(1), nullable=True)

    last_login = Column(DateTime, nullable=True)
    last_token_id = Column(String(50), nullable=True)

    registration_card_number = Column(String(20), nullable=True)

    created = Column(DateTime, default=datetime.now, nullable=False)
    createdby = Column(Integer, default=1, nullable=False)

    updated = Column(DateTime, default=datetime.now, onupdate=datetime.now, nullable=False)
    updatedby = Column(Integer, default=1, nullable=False)

    m_customer_group_id = Column(Integer, default=1, nullable=False)

    auto_close_date = Column(DateTime, nullable=True)
    last_link_token = Column(DateTime, nullable=True)

    user_link_token = Column(String(20), nullable=True)
    spv_link_token = Column(String(20), nullable=True)

    token_type = Column(String(1), nullable=True)

    registration_account_number = Column(String(30), nullable=True)
