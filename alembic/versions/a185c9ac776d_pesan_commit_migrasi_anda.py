"""Pesan commit migrasi Anda

Revision ID: a185c9ac776d
Revises: 0aa81eddac82
Create Date: 2025-05-12 07:29:00.044532

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'a185c9ac776d'
down_revision: Union[str, None] = '0aa81eddac82'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
