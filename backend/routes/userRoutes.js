const express = require('express')
const { getUsers, getCurrentUser, createUsers, updateUser, deleteUserById, clearOrganization, getMyProfile, updateMyProfile, getPointsHistory, updateVisibility } = require('../controllers/userController')
const { verifyToken, requireLevel } = require('../middlewares/authMiddleware')

const router = express.Router()

// Todas as rotas de usuário exigem token válido
router.use(verifyToken)

// Rotas de perfil do usuário autenticado - DEVEM VIR ANTES DE /me
router.get('/me/profile', getMyProfile)
router.put('/me/profile', updateMyProfile)
router.get('/me/points-history', getPointsHistory)
router.put('/me/visibility', updateVisibility)

// Rota genérica /me
router.get('/me', getCurrentUser)

// Outras rotas
router.get('/', requireLevel(2), getUsers)
router.post('/', requireLevel(2), createUsers)
router.put('/:id', requireLevel(2), updateUser)
router.delete('/structure', requireLevel(2), clearOrganization)
router.delete('/:id', requireLevel(2), deleteUserById)

module.exports = router