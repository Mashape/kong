return {
  postgres = {
    up = [[
      ALTER TABLE IF EXISTS ONLY "keyauth_credentials"
        ALTER "created_at" TYPE TIMESTAMP WITH TIME ZONE USING "created_at" AT TIME ZONE 'UTC',
        ALTER "created_at" SET DEFAULT CURRENT_TIMESTAMP(0) AT TIME ZONE 'UTC';

      DO $$
      BEGIN
        ALTER INDEX IF EXISTS "keyauth_kongsumer_idx" RENAME TO "keyauth_credentials_kongsumer_id_idx";
      EXCEPTION WHEN DUPLICATE_TABLE THEN
        -- Do nothing, accept existing state
      END;
      $$;

      -- Unique constraint on "key" already adds btree index
      DROP INDEX IF EXISTS "keyauth_key_idx";
    ]],
  },

  cassandra = {
    up = [[
    ]],
  },
}
