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