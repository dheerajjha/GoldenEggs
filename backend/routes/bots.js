const express = require('express');
const router = express.Router();
const dataStore = require('../services/dataStore');

// Get all bots
router.get('/', (req, res) => {
  const bots = dataStore.getAllBots();
  res.json({ bots });
});

// Get a specific bot
router.get('/:botId', (req, res) => {
  const { botId } = req.params;
  const bot = dataStore.getBot(botId);
  
  if (!bot) {
    return res.status(404).json({ error: 'Bot not found' });
  }
  
  res.json(bot);
});

// Follow a bot
router.post('/:botId/follow', (req, res) => {
  const { botId } = req.params;
  const { userId = 'user_default' } = req.body;
  
  const bot = dataStore.getBot(botId);
  if (!bot) {
    return res.status(404).json({ error: 'Bot not found' });
  }
  
  dataStore.followBot(userId, botId);
  res.json({ success: true, bot });
});

// Unfollow a bot
router.delete('/:botId/follow', (req, res) => {
  const { botId } = req.params;
  const { userId = 'user_default' } = req.body;
  
  const bot = dataStore.getBot(botId);
  if (!bot) {
    return res.status(404).json({ error: 'Bot not found' });
  }
  
  dataStore.unfollowBot(userId, botId);
  res.json({ success: true, bot });
});

// Get followed bots for a user
router.get('/user/:userId/following', (req, res) => {
  const { userId } = req.params;
  const followedBotIds = dataStore.getFollowedBots(userId);
  const followedBots = followedBotIds.map(id => dataStore.getBot(id)).filter(bot => bot);
  
  res.json({ followedBots });
});

module.exports = router; 