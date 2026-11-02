const reportService = require('../services/reportService');

const VALID_STATUS = ['diterima', 'diproses', 'selesai', 'ditolak'];

const sendError = (res, code, message) =>
  res.status(code).json({ success: false, message });

const isValidId = (id) => /^\d+$/.test(String(id));

const getReports = async (req, res) => {
  try {
    const { ticket_number } = req.query;
    const data = await reportService.getAll(ticket_number);

    if (ticket_number && data.length === 0) {
      return sendError(res, 404, 'Laporan dengan nomor tiket tersebut tidak ditemukan');
    }
    res.status(200).json({ success: true, message: 'Data laporan berhasil diambil', data });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

const createReport = async (req, res) => {
  try {
    const { user_id, category, title, description } = req.body;

    if (!isValidId(user_id) || !category?.trim() || !title?.trim() || !description?.trim()) {
      return sendError(res, 400, 'user_id, category, title, dan description wajib diisi');
    }

    const data = await reportService.create(req.body);
    if (!data) return sendError(res, 404, 'User tidak ditemukan');

    res.status(201).json({
      success: true,
      message: `Laporan berhasil dikirim. Simpan nomor tiket Anda: ${data.ticket_number}`,
      data,
    });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

const updateReport = async (req, res) => {
  try {
    const { id } = req.params;
    const { admin_id, response_text, new_status } = req.body;

    if (!isValidId(id)) return sendError(res, 400, 'ID laporan tidak valid');
    if (!isValidId(admin_id) || !response_text?.trim()) {
      return sendError(res, 400, 'admin_id dan response_text wajib diisi');
    }
    if (new_status && !VALID_STATUS.includes(new_status)) {
      return sendError(res, 400, `new_status harus salah satu dari: ${VALID_STATUS.join(', ')}`);
    }

    const result = await reportService.respond(id, req.body);
    if (result.error === 'REPORT_NOT_FOUND') return sendError(res, 404, 'Laporan tidak ditemukan');
    if (result.error === 'NOT_ADMIN') return sendError(res, 403, 'Hanya admin yang dapat menanggapi laporan');

    res.status(200).json({ success: true, message: 'Tanggapan berhasil disimpan', data: result.data });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

const deleteReport = async (req, res) => {
  try {
    const { id } = req.params;
    if (!isValidId(id)) return sendError(res, 400, 'ID tidak valid');

    const data = await reportService.remove(id);
    if (!data) return sendError(res, 404, 'Laporan tidak ditemukan');

    res.status(200).json({ success: true, message: 'Laporan berhasil dihapus', data });
  } catch (err) {
    console.error(err);
    sendError(res, 500, 'Terjadi kesalahan pada server');
  }
};

module.exports = { getReports, createReport, updateReport, deleteReport };