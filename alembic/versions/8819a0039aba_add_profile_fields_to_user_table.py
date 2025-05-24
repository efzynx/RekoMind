"""Add profile fields to user table

Revision ID: 8819a0039aba
Revises: 237641fb47a8
Create Date: 2025-05-12 13:53:51.377718

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '8819a0039aba'
down_revision: Union[str, None] = '237641fb47a8'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
