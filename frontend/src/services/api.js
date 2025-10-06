import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001/api';

// Create axios instance with default config
const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Alerts API
export const alertsAPI = {
  getAll: (params = {}) => api.get('/alerts', { params }),
  
  getStats: (params = {}) => api.get('/alerts/stats', { params }),
  
  getSettings: () => api.get('/alerts/settings/preferences'),
  
  updateSettings: (data) => api.put('/alerts/settings/preferences', data),
  
  delete: (id) => api.delete(`/alerts/${id}`),
  
  bulkDelete: (data) => api.post('/alerts/bulk-delete', data),
  
  testAlert: (data) => api.post('/alerts/test', data),
};

// Reports API - FIXED: Proper parameter handling
export const reportsAPI = {
  getOverview: (params = {}) => {
    const queryParams = new URLSearchParams();
    
    if (params.startDate) queryParams.append('startDate', params.startDate);
    if (params.endDate) queryParams.append('endDate', params.endDate);
    
    const queryString = queryParams.toString();
    const url = `/reports/overview${queryString ? `?${queryString}` : ''}`;
    
    return api.get(url);
  },
  
  getWebsiteReport: (websiteId, params = {}) => {
    const queryParams = new URLSearchParams();
    
    if (params.startDate) queryParams.append('startDate', params.startDate);
    if (params.endDate) queryParams.append('endDate', params.endDate);
    
    const queryString = queryParams.toString();
    const url = `/reports/website/${websiteId}${queryString ? `?${queryString}` : ''}`;
    
    return api.get(url);
  },
  
  getAlertsReport: (params = {}) => {
    const queryParams = new URLSearchParams();
    
    if (params.startDate) queryParams.append('startDate', params.startDate);
    if (params.endDate) queryParams.append('endDate', params.endDate);
    if (params.type && params.type !== 'all') queryParams.append('type', params.type);
    
    const queryString = queryParams.toString();
    const url = `/reports/alerts${queryString ? `?${queryString}` : ''}`;
    
    return api.get(url);
  },
  
  exportData: (type, params = {}) => {
    const queryParams = new URLSearchParams();
    queryParams.append('type', type);
    
    if (params.startDate) queryParams.append('startDate', params.startDate);
    if (params.endDate) queryParams.append('endDate', params.endDate);
    
    return api.get(`/reports/export?${queryParams.toString()}`, {
      responseType: 'blob'
    });
  }
};

// Websites API
export const websitesAPI = {
  getAll: () => api.get('/websites'),
  getById: (id) => api.get(`/websites/${id}`),
  create: (data) => api.post('/websites', data),
  update: (id, data) => api.put(`/websites/${id}`, data),
  delete: (id) => api.delete(`/websites/${id}`),
  check: (id) => api.post(`/websites/${id}/check`),
  getStats: (id) => api.get(`/websites/${id}/stats`),
  testCurl: (data) => api.post('/websites/test-curl', data),
};

// Auth API
export const authAPI = {
  login: (credentials) => api.post('/auth/login', credentials),
  changePassword: (data) => api.post('/auth/change-password', data),
  getProfile: () => api.get('/auth/profile'),
  updateProfile: (data) => api.put('/auth/profile', data),
  verify: () => api.get('/auth/verify'),
};

// Users API
export const usersAPI = {
  getAll: () => api.get('/users'),
  create: (data) => api.post('/users', data),
  update: (id, data) => api.put(`/users/${id}`, data),
  delete: (id) => api.delete(`/users/${id}`),
};

export default api;