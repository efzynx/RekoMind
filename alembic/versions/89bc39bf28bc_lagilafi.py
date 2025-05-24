"""lagilafi

Revision ID: 89bc39bf28bc
Revises: 7205f9ddc407
Create Date: 2025-05-12 10:55:25.759778

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '89bc39bf28bc'
down_revision: Union[str, None] = '7205f9ddc407'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
