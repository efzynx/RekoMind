"""Add profile fields to user table

Revision ID: f6710a9d78dc
Revises: 6e3390fc3f0a
Create Date: 2025-05-12 17:23:37.218674

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'f6710a9d78dc'
down_revision: Union[str, None] = '6e3390fc3f0a'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
