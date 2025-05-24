"""Add profile fields to user table

Revision ID: 024c47f8fdae
Revises: 8819a0039aba
Create Date: 2025-05-12 13:56:59.996458

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '024c47f8fdae'
down_revision: Union[str, None] = '8819a0039aba'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
