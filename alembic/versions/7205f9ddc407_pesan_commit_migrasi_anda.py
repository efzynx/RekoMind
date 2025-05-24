"""Pesan commit migrasi Anda

Revision ID: 7205f9ddc407
Revises: 01fd00e482fb
Create Date: 2025-05-12 10:55:08.197533

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '7205f9ddc407'
down_revision: Union[str, None] = '01fd00e482fb'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
