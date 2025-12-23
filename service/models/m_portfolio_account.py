from datetime import datetime

from sqlalchemy import BigInteger, Column, DateTime, Integer, Numeric, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.sql import func

Base = declarative_base()

class MPortfolioAccount(Base):
    __tablename__ = "m_portfolio_account"

    id = Column(Integer, primary_key=True, autoincrement=True)

    m_customer_id = Column(Integer, nullable=True)
    account_number = Column(String(20), nullable=True)
    account_status = Column(String(1), nullable=True)
    account_name = Column(String(50), nullable=True)
    account_type = Column(String(10), nullable=True)

    product_code = Column(String(10), nullable=True)
    product_name = Column(String(50), nullable=True)

    currency_code = Column(String(3), nullable=True)
    branch_code = Column(String(10), nullable=True)

    plafond = Column(Numeric(30, 5), nullable=True)
    clear_balance = Column(Numeric(30, 5), nullable=True)
    available_balance = Column(Numeric(30, 5), nullable=True)

    confidential = Column(String(1), nullable=True)

    created = Column(DateTime, default=datetime.now, nullable=False)
    createdby = Column(Integer, default=1, nullable=False)

    updated = Column(DateTime, default=datetime.now, onupdate=datetime.now, nullable=False)
    updatedby = Column(Integer, default=1, nullable=False)
