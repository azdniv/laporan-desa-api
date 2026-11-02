const pool = require('../config/db');

const BASE_SELECT = `
  SELECT r.id, r.ticket_number, r.category, r.title, r.description,
         r.location, r.status, r.created_at,
         u.full_name AS reporter_name, u.rt, u.rw,
         COALESCE((
           SELECT json_agg(json_build_object(
                    'id', s.id,
                    'response_text', s.response_text,
                    'new_status', s.new_status,
                    'admin_name', a.full_name,
                    'created_at', s.created_at
                  ) ORDER BY s.created_at)
             FROM responses s
             JOIN users a ON a.id = s.admin_id
            WHERE s.report_id = r.id
         ), '[]'::json) AS responses
    FROM reports r
    JOIN users u ON u.id = r.user_id
`;

const getAll = async (ticketNumber) => {
  const params = [];
  let where = '';
  if (ticketNumber) {
    params.push(ticketNumber);
    where = 'WHERE r.ticket_number = $1';
  }
  const result = await pool.query(
    `${BASE_SELECT} ${where} ORDER BY r.created_at DESC`,
    params
  );
  return result.rows;
};

// return null jika user_id tidak ada
const create = async ({ user_id, category, title, description, location }) => {
  const user = await pool.query('SELECT id FROM users WHERE id = $1', [user_id]);
  if (user.rows.length === 0) return null;

  const result = await pool.query(
    `INSERT INTO reports (user_id, ticket_number, category, title, description, location)
     VALUES ($1,
             'LD-' || to_char(NOW(), 'YYYYMMDD') || '-' ||
             lpad(nextval('report_ticket_seq')::text, 4, '0'),
             $2, $3, $4, $5)
     RETURNING *`,
    [user_id, category, title, description, location || null]
  );
  return result.rows[0];
};

// Menambah tanggapan admin dan memperbarui status laporan dalam satu transaksi
const respond = async (reportId, { admin_id, response_text, new_status }) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    const report = await client.query('SELECT id FROM reports WHERE id = $1 FOR UPDATE', [reportId]);
    if (report.rows.length === 0) {
      await client.query('ROLLBACK');
      return { error: 'REPORT_NOT_FOUND' };
    }

    const admin = await client.query(
      "SELECT id FROM users WHERE id = $1 AND role = 'admin'",
      [admin_id]
    );
    if (admin.rows.length === 0) {
      await client.query('ROLLBACK');
      return { error: 'NOT_ADMIN' };
    }

    const inserted = await client.query(
      `INSERT INTO responses (report_id, admin_id, response_text, new_status)
       VALUES ($1, $2, $3, $4) RETURNING *`,
      [reportId, admin_id, response_text, new_status || null]
    );

    if (new_status) {
      await client.query('UPDATE reports SET status = $1 WHERE id = $2', [new_status, reportId]);
    }

    await client.query('COMMIT');
    return { data: inserted.rows[0] };
  } catch (err) {
    await client.query('ROLLBACK');
    throw err;
  } finally {
    client.release();
  }
};

const remove = async (id) => {
  const result = await pool.query('DELETE FROM reports WHERE id = $1 RETURNING *', [id]);
  return result.rows[0];
};

module.exports = { getAll, create, respond, remove };