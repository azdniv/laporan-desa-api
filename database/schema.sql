-- Skema database Portal Lapor Desa
-- Urutan pembuatan tabel: users -> reports -> responses

CREATE TABLE IF NOT EXISTS users (
    id            SERIAL PRIMARY KEY,
    nik           VARCHAR(16)  NOT NULL UNIQUE,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    password      VARCHAR(255) NOT NULL,
    phone_number  VARCHAR(20),
    rt            VARCHAR(3),
    rw            VARCHAR(3),
    is_verified   BOOLEAN      NOT NULL DEFAULT FALSE,
    role          VARCHAR(20)  NOT NULL DEFAULT 'warga',
    created_at    TIMESTAMP    NOT NULL DEFAULT NOW(),
    CONSTRAINT users_role_check CHECK (role IN ('warga', 'admin'))
);

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

CREATE TABLE IF NOT EXISTS responses (
    id             SERIAL PRIMARY KEY,
    report_id      INTEGER   NOT NULL REFERENCES reports(id) ON DELETE CASCADE,
    admin_id       INTEGER   NOT NULL REFERENCES users(id),
    response_text  TEXT      NOT NULL,
    new_status     VARCHAR(20),
    created_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT responses_status_check
        CHECK (new_status IS NULL OR new_status IN ('diterima', 'diproses', 'selesai', 'ditolak'))
);

CREATE INDEX IF NOT EXISTS idx_responses_report_id ON responses(report_id);