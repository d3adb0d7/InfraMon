// frontend/src/App.js
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './contexts/AuthContext';
import { MonitoringProvider } from './contexts/MonitoringContext';
import ErrorBoundary from './components/Common/ErrorBoundary';
import Layout from './components/Layout/Layout';
import Login from './components/Auth/Login';
import Dashboard from './pages/Dashboard';
import Monitoring from './pages/Monitoring';
import Reports from './pages/Reports';
import Alerts from './pages/Alerts';
import Users from './pages/Users';
import Settings from './pages/Settings';

function ProtectedRoute({ children }) {
  const { user, loading, tokenVerified } = useAuth();
  
  if (loading || !tokenVerified) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading...</p>
        </div>
      </div>
    );
  }
  
  return user ? children : <Navigate to="/login" replace />;
}

function PublicRoute({ children }) {
  const { user, loading, tokenVerified } = useAuth();
  
  if (loading || !tokenVerified) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading...</p>
        </div>
      </div>
    );
  }
  
  return !user ? children : <Navigate to="/" replace />;
}

function AppContent() {
  const { user, tokenVerified } = useAuth();
  
  if (!tokenVerified) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading...</p>
        </div>
      </div>
    );
  }

  return (
    <Routes>
      <Route path="/login" element={
        <PublicRoute>
          <Login />
        </PublicRoute>
      } />
      <Route path="/*" element={
        <ProtectedRoute>
          <MonitoringProvider>
            <Layout>
              <Routes>
                <Route path="/" element={<Dashboard />} />
                <Route path="/monitoring" element={<Monitoring />} />
                <Route path="/reports" element={<Reports />} />
                <Route path="/alerts" element={<Alerts />} />
                <Route path="/users" element={<Users />} />
                <Route path="/settings" element={<Settings />} />
                {/* Catch all route - redirect to dashboard */}
                <Route path="*" element={<Navigate to="/" replace />} />
              </Routes>
            </Layout>
          </MonitoringProvider>
        </ProtectedRoute>
      } />
    </Routes>
  );
}

function App() {
  return (
    <ErrorBoundary>
      <AuthProvider>
        <Router>
          <div className="App">
            <AppContent />
          </div>
        </Router>
      </AuthProvider>
    </ErrorBoundary>
  );
}

export default App;