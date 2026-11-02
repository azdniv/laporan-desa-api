   INSERT INTO users (nik, full_name, email, password, phone_number, rt, rw, is_verified, role) VALUES
   ('3578010101010001', 'Rina Wati',  'rina@example.com',  '$2b$10$lUzypyKfEzDILqBpbmMMQO53K7EaTjsVgI9igEm7070aNqfBIrQVq', '081234567890', '003', '001', TRUE, 'warga'),
   ('3578010101010002', 'Admin Desa', 'admin@example.com', '$2b$10$lUzypyKfEzDILqBpbmMMQO53K7EaTjsVgI9igEm7070aNqfBIrQVq', '081200000000', NULL,  NULL,  TRUE, 'admin');

   INSERT INTO reports (user_id, ticket_number, category, title, description, location) VALUES
   (1, 'LD-SEED-001', 'Jalan', 'Jalan berlubang di RT 03',
    'Jalan di depan balai RT 03 berlubang dan membahayakan pengendara.', 'RT 03 / RW 01');

   INSERT INTO responses (report_id, admin_id, response_text, new_status) VALUES
   (1, 2, 'Laporan diterima, perbaikan dijadwalkan minggu depan.', 'diproses');