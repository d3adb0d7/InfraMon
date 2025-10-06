// frontend/src/contexts/MonitoringContext.js
import React, { createContext, useContext, useState, useEffect, useCallback, useRef } from 'react';
import { websitesAPI } from '../services/api';

const MonitoringContext = createContext();

export const useMonitoring = () => {
  const context = useContext(MonitoringContext);
  if (!context) {
    throw new Error('useMonitoring must be used within a MonitoringProvider');
  }
  return context;
};

export const MonitoringProvider = ({ children }) => {
  const [statuses, setStatuses] = useState({});
  const [websites, setWebsites] = useState([]);
  const [loading, setLoading] = useState(false);
  const eventSourceRef = useRef(null);
  const initializedRef = useRef(false);

  // Load initial websites with useCallback to prevent recreation
  const loadWebsites = useCallback(async () => {
    try {
      setLoading(true);
      console.log('🔄 Loading websites...');
      const response = await websitesAPI.getAll();
      const websitesData = response.data;
      console.log('✅ Websites loaded:', websitesData.length);
      setWebsites(websitesData);
      
      // Initialize statuses for each website
      const initialStatuses = {};
      websitesData.forEach(website => {
        initialStatuses[website.id] = {
          status: 'unknown',
          responseTime: null,
          statusCode: null,
          message: 'Not checked yet',
          lastChecked: null
        };
      });
      setStatuses(initialStatuses);
    } catch (error) {
      console.error('❌ Error loading websites:', error);
    } finally {
      setLoading(false);
    }
  }, []);

  // Setup Server-Sent Events for real-time updates
  const setupEventSource = useCallback(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      console.log('🔐 No token found for SSE');
      return;
    }

    // Close existing connection
    if (eventSourceRef.current) {
      console.log('🔌 Closing existing SSE connection');
      eventSourceRef.current.close();
    }

    const apiUrl = process.env.REACT_APP_API_URL || 'http://localhost:3001';
    console.log('📡 Setting up SSE connection to:', `${apiUrl}/api/events`);

    try {
      const newEventSource = new EventSource(`${apiUrl}/api/events?token=${token}`);

      newEventSource.onopen = () => {
        console.log('✅ SSE connection established');
      };

      newEventSource.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          console.log('📨 SSE message received:', data);
          
          if (data.type === 'status_update') {
            setStatuses(prev => ({
              ...prev,
              [data.websiteId]: {
                status: data.status,
                responseTime: data.responseTime,
                statusCode: data.statusCode,
                message: data.message,
                lastChecked: data.lastChecked || new Date().toISOString()
              }
            }));
          }
        } catch (error) {
          console.error('❌ Error parsing SSE data:', error);
        }
      };

      newEventSource.onerror = (error) => {
        console.error('❌ SSE error:', error);
        // Don't auto-reconnect on error
        newEventSource.close();
        eventSourceRef.current = null;
      };

      eventSourceRef.current = newEventSource;
    } catch (error) {
      console.error('❌ Failed to create EventSource:', error);
    }
  }, []);

  // Manual check function
  const manualCheck = useCallback(async (websiteId) => {
    try {
      console.log('🔄 Manual check for website:', websiteId);
      const response = await websitesAPI.check(websiteId);
      const result = response.data;
      
      setStatuses(prev => ({
        ...prev,
        [websiteId]: {
          status: result.status,
          responseTime: result.responseTime,
          statusCode: result.statusCode,
          message: result.message,
          lastChecked: new Date().toISOString()
        }
      }));
      
      return result;
    } catch (error) {
      console.error('❌ Manual check failed:', error);
      
      setStatuses(prev => ({
        ...prev,
        [websiteId]: {
          status: 'down',
          responseTime: null,
          statusCode: null,
          message: error.response?.data?.error || 'Check failed',
          lastChecked: new Date().toISOString()
        }
      }));
      
      throw error;
    }
  }, []);

  // Refresh all website statuses
  const refreshAll = useCallback(async () => {
    try {
      await loadWebsites();
    } catch (error) {
      console.error('Error refreshing all websites:', error);
    }
  }, [loadWebsites]);

  // Initial load - run only once when component mounts
  useEffect(() => {
    if (initializedRef.current) return;
    
    console.log('🚀 MonitoringProvider mounted - loading websites');
    initializedRef.current = true;
    loadWebsites();
  }, [loadWebsites]);

  // Setup event source only when websites are loaded and we have data
  useEffect(() => {
    if (websites.length > 0) {
      console.log('📡 Setting up event source for', websites.length, 'websites');
      setupEventSource();
    }

    // Cleanup function
    return () => {
      console.log('🧹 Cleaning up MonitoringProvider');
      if (eventSourceRef.current) {
        eventSourceRef.current.close();
        eventSourceRef.current = null;
      }
      initializedRef.current = false;
    };
  }, [websites.length, setupEventSource]);

  const value = {
    statuses,
    websites,
    loading,
    manualCheck,
    refreshAll,
    loadWebsites
  };

  console.log('🔄 MonitoringProvider rendering with', websites.length, 'websites');

  return (
    <MonitoringContext.Provider value={value}>
      {children}
    </MonitoringContext.Provider>
  );
};