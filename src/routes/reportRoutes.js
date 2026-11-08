const express = require('express');
const controller = require('../controllers/reportController');

const router = express.Router();

router.get('/:id', controller.getReportById);
router.get('/', controller.getReports);
router.get('/:id', controller.getReportById);
router.post('/', controller.createReport);
router.put('/:id', controller.updateReport);
router.delete('/:id', controller.deleteReport);

module.exports = router;