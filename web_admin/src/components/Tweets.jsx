import { useState, useEffect } from 'react';
import api from '../services/api';
import { format } from 'date-fns';

function Tweets() {
  const [tweets, setTweets] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedTweets, setSelectedTweets] = useState(new Set());

  useEffect(() => {
    fetchTweets();
  }, []);

  const fetchTweets = async () => {
    try {
      setLoading(true);
      const response = await api.get('/tweets?limit=100');
      setTweets(response.data.tweets);
    } catch (error) {
      console.error('Error fetching tweets:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = async () => {
    if (!searchQuery.trim()) {
      fetchTweets();
      return;
    }

    try {
      setLoading(true);
      const response = await api.get(`/tweets/search?q=${searchQuery}`);
      setTweets(response.data.tweets);
    } catch (error) {
      console.error('Error searching tweets:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSelectTweet = (tweetId) => {
    const newSelected = new Set(selectedTweets);
    if (newSelected.has(tweetId)) {
      newSelected.delete(tweetId);
    } else {
      newSelected.add(tweetId);
    }
    setSelectedTweets(newSelected);
  };

  const handleSelectAll = () => {
    if (selectedTweets.size === tweets.length) {
      setSelectedTweets(new Set());
    } else {
      setSelectedTweets(new Set(tweets.map(t => t.id)));
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
      {/* Header */}
      <div className="flex justify-between items-center">
        <div className="flex items-center space-x-4">
          <input
            type="text"
            placeholder="Search tweets..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSearch()}
            className="px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-primary"
          />
          <button
            onClick={handleSearch}
            className="px-4 py-2 bg-primary text-white rounded-lg hover:bg-blue-600"
          >
            Search
          </button>
        </div>
        {selectedTweets.size > 0 && (
          <button
            className="px-4 py-2 bg-danger text-white rounded-lg hover:bg-red-600"
          >
            Delete Selected ({selectedTweets.size})
          </button>
        )}
      </div>

      {/* Tweets Table */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        <table className="min-w-full">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left">
                <input
                  type="checkbox"
                  checked={selectedTweets.size === tweets.length && tweets.length > 0}
                  onChange={handleSelectAll}
                  className="rounded"
                />
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Author
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Content
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Stocks
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Engagement
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Posted
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {tweets.map((tweet) => (
              <tr key={tweet.id} className="hover:bg-gray-50">
                <td className="px-6 py-4">
                  <input
                    type="checkbox"
                    checked={selectedTweets.has(tweet.id)}
                    onChange={() => handleSelectTweet(tweet.id)}
                    className="rounded"
                  />
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <div className="flex items-center">
                    <div className="text-2xl mr-3">{tweet.authorAvatar}</div>
                    <div>
                      <div className="text-sm font-medium text-gray-900">
                        {tweet.authorName}
                      </div>
                      <div className="text-sm text-gray-500">
                        {tweet.authorHandle}
                      </div>
                    </div>
                    {tweet.isBot && (
                      <span className="ml-2 px-2 py-1 text-xs bg-primary text-white rounded">
                        BOT
                      </span>
                    )}
                  </div>
                </td>
                <td className="px-6 py-4">
                  <div className="text-sm text-gray-900 max-w-xs truncate">
                    {tweet.content}
                  </div>
                </td>
                <td className="px-6 py-4">
                  <div className="flex flex-wrap gap-1">
                    {tweet.stocks.map((stock) => (
                      <span
                        key={stock}
                        className="px-2 py-1 text-xs bg-gray-100 text-gray-700 rounded"
                      >
                        ${stock}
                      </span>
                    ))}
                  </div>
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm">
                  <div className="space-y-1">
                    <div>❤️ {tweet.likes}</div>
                    <div>🔁 {tweet.retweets}</div>
                    <div>💬 {tweet.replies}</div>
                  </div>
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {format(new Date(tweet.timestamp), 'MMM d, yyyy HH:mm')}
                </td>
                <td className="px-6 py-4 whitespace-nowrap text-sm">
                  <button className="text-primary hover:text-blue-700 mr-3">
                    View
                  </button>
                  <button className="text-danger hover:text-red-700">
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Tweets; 