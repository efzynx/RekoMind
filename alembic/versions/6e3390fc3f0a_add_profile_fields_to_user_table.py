"""Add profile fields to user table

Revision ID: 6e3390fc3f0a
Revises: a185c9ac776d
Create Date: 2025-05-12 17:23:17.931300

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '6e3390fc3f0a'
down_revision: Union[str, None] = 'a185c9ac776d'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
