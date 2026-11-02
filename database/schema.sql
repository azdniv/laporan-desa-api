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

-- Data contoh (password kedua akun: password123)

INSERT INTO users (nik, full_name, email, password, phone_number, rt, rw, is_verified, role) VALUES
('3578010101010001', 'Rina Wati',  'rina@example.com',  '$2b$10$lUzypyKfEzDILqBpbmMMQO53K7EaTjsVgI9igEm7070aNqfBIrQVq', '081234567890', '003', '001', TRUE, 'warga'),
('3578010101010002', 'Admin Desa', 'admin@example.com', '$2b$10$lUzypyKfEzDILqBpbmMMQO53K7EaTjsVgI9igEm7070aNqfBIrQVq', '081200000000', NULL,  NULL,  TRUE, 'admin');

INSERT INTO reports (user_id, ticket_number, category, title, description, location, status) VALUES
(1, 'LD-SEED-001', 'Jalan', 'Jalan berlubang di RT 03',
 'Jalan di depan balai RT 03 berlubang dan membahayakan pengendara.', 'RT 03 / RW 01', 'diproses');

INSERT INTO responses (report_id, admin_id, response_text, new_status) VALUES
(1, 2, 'Laporan diterima, perbaikan dijadwalkan minggu depan.', 'diproses');