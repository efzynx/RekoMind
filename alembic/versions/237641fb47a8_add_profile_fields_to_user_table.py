"""Add profile fields to user table

Revision ID: 237641fb47a8
Revises: eee5bba1a6a0
Create Date: 2025-05-12 13:51:30.952137

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '237641fb47a8'
down_revision: Union[str, None] = 'eee5bba1a6a0'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
