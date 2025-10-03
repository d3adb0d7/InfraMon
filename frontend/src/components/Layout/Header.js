import React, { useState } from 'react';
import { useAuth } from '../../contexts/AuthContext';
import { Menu, LogOut, User, Bell, Settings, AlertTriangle, X } from 'lucide-react';

const Header = ({ setSidebarOpen, sidebarOpen }) => {
  const { user, logout } = useAuth();
  const [showLogoutModal, setShowLogoutModal] = useState(false);

  const handleLogoutClick = () => {
    setShowLogoutModal(true);
  };

  const handleConfirmLogout = () => {
    setShowLogoutModal(false);
    logout();
  };

  const handleCancelLogout = () => {
    setShowLogoutModal(false);
  };

  return (
    <>
      {/* Logout Confirmation Modal */}
      {showLogoutModal && (
        <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 animate-fade-in">
          <div className="bg-white rounded-2xl max-w-sm w-full animate-scale-in">
            <div className="p-6">
              <div className="flex items-center space-x-3 mb-4">
                <div className="p-2 bg-amber-100 rounded-xl">
                  <AlertTriangle className="h-6 w-6 text-amber-600" />
                </div>
                <div>
                  <h3 className="text-lg font-semibold text-slate-900">Confirm Logout</h3>
                  <p className="text-slate-600 text-sm mt-1">Are you sure you want to logout?</p>
                </div>
              </div>
              
              <div className="flex justify-end space-x-3">
                <button
                  onClick={handleCancelLogout}
                  className="px-4 py-2.5 border border-slate-300 text-slate-700 rounded-xl hover:bg-slate-50 transition-colors font-medium"
                >
                  Cancel
                </button>
                <button
                  onClick={handleConfirmLogout}
                  className="px-4 py-2.5 bg-amber-600 text-white rounded-xl hover:bg-amber-700 transition-colors font-medium"
                >
                  Logout
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      <header className="bg-white/80 backdrop-blur-sm border-b border-slate-200/60 sticky top-0 z-40">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center">
              <button
                className="lg:hidden mr-4 p-2 rounded-xl text-slate-600 hover:text-slate-900 hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors"
                onClick={() => setSidebarOpen(!sidebarOpen)}
                aria-label="Toggle sidebar"
              >
                <Menu className="h-5 w-5" />
              </button>
              <h1 className="text-xl font-semibold text-slate-900 hidden lg:block">NAGAD Infrastructure Monitoring</h1>
            </div>

            <div className="flex items-center space-x-4">
              {/* Notifications */}
              <button className="p-2 text-slate-600 hover:text-slate-900 hover:bg-slate-100 rounded-xl transition-colors relative">
                <Bell className="h-5 w-5" />
                <span className="absolute -top-1 -right-1 h-3 w-3 bg-rose-500 rounded-full border-2 border-white"></span>
              </button>

              {/* Settings */}
              
              {/* User Profile */}
              <div className="flex items-center space-x-3">
                <div className="hidden sm:flex sm:flex-col sm:items-end">
                  <span className="text-sm font-medium text-slate-900">{user?.username}</span>
                  <span className="text-xs text-slate-600 capitalize">{user?.role}</span>
                </div>
                
                <div className="h-9 w-9 bg-gradient-to-r from-blue-500 to-blue-600 rounded-xl flex items-center justify-center">
                  <User className="h-5 w-5 text-white" />
                </div>
                
                <button
                  onClick={handleLogoutClick}
                  className="p-2 text-slate-600 hover:text-slate-900 hover:bg-slate-100 rounded-xl transition-colors"
                  title="Logout"
                >
                  <LogOut className="h-5 w-5" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </header>
    </>
  );
};

export default Header;