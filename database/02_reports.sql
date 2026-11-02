CREATE SEQUENCE IF NOT EXISTS report_ticket_seq START 1;

CREATE TABLE IF NOT EXISTS reports (
    id             SERIAL PRIMARY KEY,
    user_id        INTEGER      NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ticket_number  VARCHAR(20)  NOT NULL UNIQUE,
    category       VARCHAR(50)  NOT NULL,
    title          VARCHAR(150) NOT NULL,
    description    TEXT         NOT NULL,
    location       VARCHAR(255),
    status         VARCHAR(20)  NOT NULL DEFAULT 'diterima',
    created_at     TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT reports_status_check
        CHECK (status IN ('diterima', 'diproses', 'selesai', 'ditolak'))
);
CREATE INDEX IF NOT EXISTS idx_reports_user_id ON reports(user_id);