import { useState, useEffect } from 'react';
import { LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import api from '../services/api';

function Dashboard() {
  const [stats, setStats] = useState({
    totalTweets: 0,
    totalBots: 8,
    activeUsers: 0,
    trendingStocks: []
  });
  const [tweetActivity, setTweetActivity] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      // Fetch tweets count
      const tweetsRes = await api.get('/tweets');
      const botsRes = await api.get('/bots');
      const trendingRes = await api.get('/stocks/trending');

      setStats({
        totalTweets: tweetsRes.data.total || 0,
        totalBots: botsRes.data.bots.length,
        activeUsers: 150, // Simulated
        trendingStocks: trendingRes.data.trending.slice(0, 5)
      });

      // Simulate tweet activity data
      const activity = Array.from({ length: 7 }, (_, i) => ({
        day: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i],
        tweets: Math.floor(Math.random() * 100) + 20
      }));
      setTweetActivity(activity);
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
    } finally {
      setLoading(false);
    }
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
      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <StatCard
          title="Total Tweets"
          value={stats.totalTweets}
          icon="💬"
          color="bg-blue-500"
        />
        <StatCard
          title="Active Bots"
          value={stats.totalBots}
          icon="🤖"
          color="bg-green-500"
        />
        <StatCard
          title="Active Users"
          value={stats.activeUsers}
          icon="👥"
          color="bg-purple-500"
        />
        <StatCard
          title="Trending Stocks"
          value={stats.trendingStocks.length}
          icon="📈"
          color="bg-yellow-500"
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Tweet Activity Chart */}
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-semibold mb-4">Tweet Activity (Last 7 Days)</h3>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={tweetActivity}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="day" />
              <YAxis />
              <Tooltip />
              <Line type="monotone" dataKey="tweets" stroke="#1A73E8" strokeWidth={2} />
            </LineChart>
          </ResponsiveContainer>
        </div>

        {/* Trending Stocks Chart */}
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-semibold mb-4">Top Trending Stocks</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={stats.trendingStocks}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="symbol" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="mentions" fill="#34A853" />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Recent Activity */}
      <div className="bg-white rounded-lg shadow p-6">
        <h3 className="text-lg font-semibold mb-4">Recent Activity</h3>
        <div className="space-y-3">
          <ActivityItem
            icon="🤖"
            text="Market Pulse Bot posted an update"
            time="2 minutes ago"
          />
          <ActivityItem
            icon="👤"
            text="New user posted a tweet about RELIANCE"
            time="5 minutes ago"
          />
          <ActivityItem
            icon="📈"
            text="TCS is trending with 25 mentions"
            time="10 minutes ago"
          />
          <ActivityItem
            icon="🚀"
            text="Volume Alert Bot detected unusual activity in INFY"
            time="15 minutes ago"
          />
        </div>
      </div>
    </div>
  );
}

function StatCard({ title, value, icon, color }) {
  return (
    <div className="bg-white rounded-lg shadow p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-gray-600 text-sm">{title}</p>
          <p className="text-2xl font-bold mt-1">{value}</p>
        </div>
        <div className={`${color} bg-opacity-20 rounded-full p-3`}>
          <span className="text-3xl">{icon}</span>
        </div>
      </div>
    </div>
  );
}

function ActivityItem({ icon, text, time }) {
  return (
    <div className="flex items-center space-x-3">
      <span className="text-2xl">{icon}</span>
      <div className="flex-1">
        <p className="text-sm text-gray-800">{text}</p>
        <p className="text-xs text-gray-500">{time}</p>
      </div>
    </div>
  );
}

export default Dashboard; 