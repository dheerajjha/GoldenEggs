# Stock Pulse - Web Admin Panel

A modern web-based admin panel for managing the Stock Pulse social media platform. Built with React, Vite, and Tailwind CSS.

## Features

### Dashboard
- Real-time statistics overview
- Tweet activity charts
- Trending stocks visualization
- Recent activity feed

### Tweet Management
- View all tweets in a paginated table
- Search tweets by content
- Bulk selection and actions
- View engagement metrics
- Delete inappropriate content

### Bot Management
- View and manage all market bots
- Enable/disable bots
- View bot performance metrics
- Configure posting schedules
- Monitor bot followers

### User Management
- View registered users
- Search users
- View user statistics
- Suspend/activate accounts
- Monitor user activity

### Analytics
- Engagement metrics over time
- Stock mention distribution
- Bot performance analysis
- User growth trends
- Content performance insights

## Tech Stack

- **Frontend Framework**: React 18
- **Build Tool**: Vite
- **Styling**: Tailwind CSS
- **Charts**: Recharts
- **Routing**: React Router DOM
- **HTTP Client**: Axios
- **Real-time**: Socket.IO Client
- **Date Handling**: date-fns

## Setup

### Prerequisites
- Node.js 16+ and npm
- Backend server running on `http://localhost:5500`

### Installation

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run dev
```

The admin panel will be available at `http://localhost:5173`

### Build for Production

```bash
npm run build
```

The built files will be in the `dist` directory.

## Project Structure

```
src/
├── components/          # React components
│   ├── Layout.jsx      # Main layout with sidebar
│   ├── Dashboard.jsx   # Dashboard with stats
│   ├── Tweets.jsx      # Tweet management
│   ├── Bots.jsx        # Bot management
│   ├── Users.jsx       # User management
│   └── Analytics.jsx   # Analytics dashboard
├── services/           # API services
│   └── api.js         # Axios configuration
├── App.jsx            # Main app component
├── main.jsx           # App entry point
└── index.css          # Tailwind CSS imports
```

## API Integration

The admin panel connects to the backend API at `http://localhost:5500/api` with the following endpoints:

- `/tweets` - Tweet management
- `/bots` - Bot management
- `/stocks/trending` - Trending stocks data
- `/feed` - Feed management

## Key Features Implementation

### Real-time Updates
- Socket.IO integration for live tweet updates
- Auto-refresh for statistics

### Data Visualization
- Line charts for trends
- Bar charts for comparisons
- Pie charts for distributions
- Area charts for engagement

### Responsive Design
- Mobile-friendly layout
- Adaptive grid system
- Touch-friendly interactions

## Configuration

### Change API URL
Update the API base URL in `src/services/api.js`:
```javascript
const API_BASE_URL = 'http://your-api-url/api';
```

### Customize Theme
Modify colors in `tailwind.config.js`:
```javascript
colors: {
  primary: '#1A73E8',
  secondary: '#34A853',
  danger: '#EA4335',
  warning: '#FBBC04',
}
```

## Security Considerations

- Implement proper authentication
- Add role-based access control
- Validate all inputs
- Implement CSRF protection
- Use HTTPS in production

## Future Enhancements

- Real-time notifications
- Advanced filtering options
- Export functionality
- Batch operations
- API key management
- Audit logs
- Custom bot creation
- A/B testing features
- Advanced analytics
- Multi-language support
