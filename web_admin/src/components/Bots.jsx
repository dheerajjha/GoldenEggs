import { useState, useEffect } from 'react';
import api from '../services/api';

function Bots() {
  const [bots, setBots] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchBots();
  }, []);

  const fetchBots = async () => {
    try {
      setLoading(true);
      const response = await api.get('/bots');
      setBots(response.data.bots);
    } catch (error) {
      console.error('Error fetching bots:', error);
    } finally {
      setLoading(false);
    }
  };

  const toggleBotStatus = (botId) => {
    // Placeholder for enabling/disabling bot
    console.log('Toggle bot status:', botId);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold">Bot Management</h2>
        <button className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-blue-600">
          Add New Bot
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {bots.map((bot) => (
          <BotCard key={bot.id} bot={bot} onToggle={toggleBotStatus} />
        ))}
      </div>
    </div>
  );
}

function BotCard({ bot, onToggle }) {
  const [expanded, setExpanded] = useState(false);

  const getBotTypeColor = (type) => {
    const colors = {
      market_overview: 'bg-blue-500',
      top_movers: 'bg-green-500',
      news: 'bg-purple-500',
      technical: 'bg-yellow-500',
      sentiment: 'bg-pink-500',
      volume: 'bg-indigo-500',
      breakout: 'bg-red-500',
      dividend: 'bg-teal-500',
    };
    return colors[type] || 'bg-gray-500';
  };

  return (
    <div className="bg-white rounded-lg shadow-lg overflow-hidden">
      <div className={`h-2 ${getBotTypeColor(bot.type)}`}></div>
      <div className="p-6">
        <div className="flex items-start justify-between mb-4">
          <div className="flex items-center">
            <div className="text-4xl mr-3">{bot.avatar}</div>
            <div>
              <h3 className="font-bold text-lg">{bot.name}</h3>
              <p className="text-gray-500 text-sm">{bot.handle}</p>
            </div>
          </div>
          <label className="relative inline-flex items-center cursor-pointer">
            <input
              type="checkbox"
              checked={true}
              onChange={() => onToggle(bot.id)}
              className="sr-only peer"
            />
            <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
          </label>
        </div>

        <p className="text-gray-600 text-sm mb-4">{bot.description}</p>

        <div className="space-y-2 mb-4">
          <div className="flex justify-between text-sm">
            <span className="text-gray-500">Type:</span>
            <span className="font-medium capitalize">{bot.type.replace('_', ' ')}</span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-500">Followers:</span>
            <span className="font-medium">{bot.followers}</span>
          </div>
          <div className="flex justify-between text-sm">
            <span className="text-gray-500">Status:</span>
            <span className="text-green-600 font-medium">Active</span>
          </div>
        </div>

        <button
          onClick={() => setExpanded(!expanded)}
          className="w-full text-center text-primary hover:text-blue-700 text-sm font-medium"
        >
          {expanded ? 'Hide Details' : 'Show Details'}
        </button>

        {expanded && (
          <div className="mt-4 pt-4 border-t space-y-3">
            <div>
              <h4 className="font-semibold text-sm mb-1">Posting Schedule</h4>
              <p className="text-xs text-gray-600">
                {bot.type === 'market_overview' && 'Every 1 minute'}
                {bot.type === 'top_movers' && 'Every 2 minutes'}
                {bot.type === 'news' && 'Every 3 minutes'}
                {bot.type === 'technical' && 'Every 5 minutes'}
                {bot.type === 'sentiment' && 'Every 5 minutes'}
                {bot.type === 'volume' && 'Every 2 minutes'}
                {bot.type === 'breakout' && 'Every 3 minutes'}
                {bot.type === 'dividend' && 'Every 10 minutes'}
              </p>
            </div>
            <div>
              <h4 className="font-semibold text-sm mb-1">Configuration</h4>
              <button className="text-xs text-primary hover:text-blue-700">
                Edit Bot Settings →
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default Bots; 