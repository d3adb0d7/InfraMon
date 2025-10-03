// frontend/src/components/Layout/Sidebar.js
import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { 
  Home, 
  Monitor, 
  BarChart3, 
  Bell, 
  Users,
  X,
  Settings
} from 'lucide-react';

const Sidebar = ({ sidebarOpen, setSidebarOpen }) => {
  const location = useLocation();
  
  const navigation = [
    { name: 'Dashboard', href: '/', icon: Home },
    { name: 'Monitoring', href: '/monitoring', icon: Monitor },
    { name: 'Reports', href: '/reports', icon: BarChart3 },
    { name: 'Alerts', href: '/alerts', icon: Bell },
    { name: 'Users', href: '/users', icon: Users },
    { name: 'Settings', href: '/settings', icon: Settings },
  ];

  const handleLinkClick = () => {
    if (window.innerWidth < 1024) {
      setSidebarOpen(false);
    }
  };

  return (
    <>
      {/* Mobile overlay */}
      {sidebarOpen && (
        <div 
          className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-40 lg:hidden"
          onClick={() => setSidebarOpen(false)}
          aria-hidden="true"
        />
      )}

      {/* Sidebar */}
      <div className={`
        fixed inset-y-0 left-0 z-50 w-80 bg-white/90 backdrop-blur-sm transform transition-transform duration-300 ease-in-out border-r border-slate-200/60
        lg:relative lg:translate-x-0 lg:z-auto
        ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'}
      `}>
        <div className="flex flex-col h-full">
          {/* Sidebar header with new logo */}
          <div className="flex items-center justify-between h-20 px-6 border-b border-slate-200/60">
            <div className="flex items-center">
              <div className="h-10 w-10 rounded-xl flex items-center justify-center overflow-hidden">
                <img 
                  src="/logo.png" 
                  alt="InfraMon" 
                  className="h-8 w-8 object-contain"
                />
              </div>
              <div className="ml-3">
                <span className="text-xl font-bold text-slate-900">InfraMon</span>
                <div className="text-xs text-slate-600">Infrastructure Monitoring</div>
              </div>
            </div>
            <button
              className="lg:hidden p-2 rounded-xl text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-colors"
              onClick={() => setSidebarOpen(false)}
            >
              <X className="h-5 w-5" />
            </button>
          </div>

          {/* Navigation (rest remains the same) */}
          <nav className="flex-1 px-4 py-6 overflow-y-auto">
            <div className="space-y-1">
              {navigation.map((item) => {
                const Icon = item.icon;
                const isActive = location.pathname === item.href;
                
                return (
                  <Link
                    key={item.name}
                    to={item.href}
                    className={`
                      group flex items-center px-4 py-3 text-sm font-medium rounded-xl transition-all duration-200
                      ${isActive
                        ? 'bg-blue-50 text-blue-700 border-r-2 border-blue-600 shadow-sm'
                        : 'text-slate-600 hover:bg-slate-50 hover:text-slate-900'
                      }
                    `}
                    onClick={handleLinkClick}
                  >
                    <Icon className={`mr-3 h-5 w-5 ${isActive ? 'text-blue-600' : 'text-slate-400 group-hover:text-slate-600'}`} />
                    {item.name}
                    {isActive && (
                      <div className="ml-auto w-2 h-2 bg-blue-600 rounded-full"></div>
                    )}
                  </Link>
                );
              })}
            </div>

            {/* Sidebar footer */}
            <div className="mt-8 pt-6 border-t border-slate-200/60">
              <div className="px-4">
                <div className="bg-slate-50/50 rounded-xl p-4 border border-slate-200/60">
                  <div className="text-xs text-slate-600 mb-2">System Status</div>
                  <div className="flex items-center space-x-2">
                    <div className="w-2 h-2 bg-emerald-400 rounded-full animate-pulse"></div>
                    <span className="text-sm font-medium text-slate-900">All Systems Operational</span>
                  </div>
                </div>
              </div>
            </div>
          </nav>
        </div>
      </div>
    </>
  );
};

export default Sidebar;