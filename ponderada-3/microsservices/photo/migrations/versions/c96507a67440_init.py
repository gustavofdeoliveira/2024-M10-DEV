"""init

Revision ID: c96507a67440
Revises: 
Create Date: 2022-10-02 17:35:21.037920

"""
import sqlalchemy as sa
import sqlmodel
from alembic import op

# revision identifiers, used by Alembic.
revision = "c96507a67440"
down_revision = None
branch_labels = None
depends_on = None


def upgrade():

    op.create_table(
        "photo",
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("id", sa.Integer(), nullable=False),
        sa.Column("user_token", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("file_name", sqlmodel.sql.sqltypes.AutoString(), nullable=False),
        sa.Column("url", sqlmodel.sql.sqltypes.AutoString(), nullable=True),
        sa.Column("is_black_and_white", sa.Boolean(), nullable=True),
        sa.PrimaryKeyConstraint("id"),
    )
   


def downgrade():
    op.drop_table("photo")
