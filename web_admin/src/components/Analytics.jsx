import { LineChart, Line, AreaChart, Area, PieChart, Pie, Cell, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Legend } from 'recharts';

function Analytics() {
  // Sample data
  const engagementData = [
    { hour: '00:00', likes: 45, retweets: 23, replies: 12 },
    { hour: '04:00', likes: 32, retweets: 18, replies: 8 },
    { hour: '08:00', likes: 78, retweets: 45, replies: 23 },
    { hour: '12:00', likes: 123, retweets: 67, replies: 34 },
    { hour: '16:00', likes: 98, retweets: 54, replies: 28 },
    { hour: '20:00', likes: 87, retweets: 43, replies: 21 },
  ];

  const stockMentions = [
    { name: 'RELIANCE', value: 45, color: '#1A73E8' },
    { name: 'TCS', value: 38, color: '#34A853' },
    { name: 'HDFCBANK', value: 32, color: '#FBBC04' },
    { name: 'INFY', value: 28, color: '#EA4335' },
    { name: 'Others', value: 57, color: '#9E9E9E' },
  ];

  const botPerformance = [
    { bot: 'Market Pulse', tweets: 48, engagement: 89 },
    { bot: 'Top Movers', tweets: 36, engagement: 78 },
    { bot: 'Technical', tweets: 24, engagement: 92 },
    { bot: 'News', tweets: 32, engagement: 85 },
    { bot: 'Volume Alert', tweets: 28, engagement: 73 },
  ];

  return (
    <div className="space-y-6">
      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <MetricCard
          title="Total Engagement"
          value="1,234"
          change="+12.5%"
          trend="up"
        />
        <MetricCard
          title="Avg. Engagement Rate"
          value="3.8%"
          change="+0.5%"
          trend="up"
        />
        <MetricCard
          title="Active Users Today"
          value="456"
          change="-2.3%"
          trend="down"
        />
        <MetricCard
          title="Bot Efficiency"
          value="87%"
          change="+5.2%"
          trend="up"
        />
      </div>

      {/* Charts */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Engagement Over Time */}
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-semibold mb-4">Engagement Over Time</h3>
          <ResponsiveContainer width="100%" height={300}>
            <AreaChart data={engagementData}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="hour" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Area type="monotone" dataKey="likes" stackId="1" stroke="#1A73E8" fill="#1A73E8" />
              <Area type="monotone" dataKey="retweets" stackId="1" stroke="#34A853" fill="#34A853" />
              <Area type="monotone" dataKey="replies" stackId="1" stroke="#FBBC04" fill="#FBBC04" />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Stock Mentions Distribution */}
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-semibold mb-4">Top Stock Mentions</h3>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                data={stockMentions}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                outerRadius={80}
                fill="#8884d8"
                dataKey="value"
              >
                {stockMentions.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Bot Performance Table */}
      <div className="bg-white rounded-lg shadow p-6">
        <h3 className="text-lg font-semibold mb-4">Bot Performance Analysis</h3>
        <div className="overflow-x-auto">
          <table className="min-w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Bot Name
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Tweets Posted
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Engagement Score
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Performance
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {botPerformance.map((bot) => (
                <tr key={bot.bot}>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    {bot.bot}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {bot.tweets}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {bot.engagement}%
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="flex items-center">
                      <div className="flex-1 bg-gray-200 rounded-full h-2 mr-3">
                        <div
                          className="bg-primary h-2 rounded-full"
                          style={{ width: `${bot.engagement}%` }}
                        ></div>
                      </div>
                      <span className="text-sm font-medium">{bot.engagement}%</span>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

function MetricCard({ title, value, change, trend }) {
  return (
    <div className="bg-white rounded-lg shadow p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-gray-600 text-sm">{title}</p>
          <p className="text-2xl font-bold mt-1">{value}</p>
          <p className={`text-sm mt-2 ${trend === 'up' ? 'text-green-600' : 'text-red-600'}`}>
            {trend === 'up' ? '↑' : '↓'} {change}
          </p>
        </div>
      </div>
    </div>
  );
}

export default Analytics; 