const express = require('express');
const controller = require('../controllers/reportController');

const router = express.Router();

router.get('/', controller.getReports);
router.post('/', controller.createReport);
router.put('/:id', controller.updateReport);
router.delete('/:id', controller.deleteReport);

module.exports = router;