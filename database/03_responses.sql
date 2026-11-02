CREATE TABLE IF NOT EXISTS responses (
    id             SERIAL PRIMARY KEY,
    report_id      INTEGER   NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    admin_id       INTEGER   NOT NULL REFERENCES users(id),
    response_text  TEXT      NOT NULL,
    new_status     VARCHAR(20),
    created_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT responses_status_check
        CHECK (new_status IS NULL OR new_status IN ('diterima','diproses','selesai','ditolak'))
);
CREATE INDEX IF NOT EXISTS idx_responses_report_id ON responses(report_id);