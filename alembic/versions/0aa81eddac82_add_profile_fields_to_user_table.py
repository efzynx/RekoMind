"""Add profile fields to user table

Revision ID: 0aa81eddac82
Revises: 024c47f8fdae
Create Date: 2025-05-12 07:18:53.726530

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '0aa81eddac82'
down_revision: Union[str, None] = '024c47f8fdae'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
