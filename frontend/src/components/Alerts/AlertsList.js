// frontend/src/components/Alerts/AlertsList.js
import React, { useState, useEffect } from 'react';
import { Mail, MessageSquare, Trash2, Filter, Search, Calendar, Globe, X } from 'lucide-react';

const AlertsList = ({ 
  alerts, 
  pagination, 
  loading, 
  onDelete, 
  onBulkDelete, 
  onPageChange,
  onSearchChange,
  onTypeFilterChange,
  currentFilters,
  loadAlerts 
}) => {
  const [selectedAlerts, setSelectedAlerts] = useState([]);
  const [isDeleting, setIsDeleting] = useState(false);
  const [localSearch, setLocalSearch] = useState(currentFilters.search || '');
  const [localTypeFilter, setLocalTypeFilter] = useState(currentFilters.type || 'all');

  // Sync local state with props
  useEffect(() => {
    setLocalSearch(currentFilters.search || '');
    setLocalTypeFilter(currentFilters.type || 'all');
  }, [currentFilters]);

  const handleSelectAlert = (alertId) => {
    setSelectedAlerts(prev =>
      prev.includes(alertId)
        ? prev.filter(id => id !== alertId)
        : [...prev, alertId]
    );
  };

  const handleSelectAll = () => {
    if (selectedAlerts.length === alerts.length && alerts.length > 0) {
      setSelectedAlerts([]);
    } else {
      setSelectedAlerts(alerts.map(alert => alert.id));
    }
  };

  const handleBulkDeleteClick = () => {
    if (selectedAlerts.length === 0) return;
    setIsDeleting(true);
    onBulkDelete(selectedAlerts);
    setTimeout(() => {
      setSelectedAlerts([]);
      setIsDeleting(false);
    }, 1000);
  };

  const handleDeleteClick = (alertId) => {
    onDelete(alertId);
  };

  const handleSearchSubmit = (e) => {
    e.preventDefault();
    onSearchChange(localSearch);
  };

  const handleTypeFilterSubmit = (e) => {
    e.preventDefault();
    onTypeFilterChange(localTypeFilter);
  };

  const handleSearchChange = (value) => {
    setLocalSearch(value);
    // Debounced search - update after user stops typing
    clearTimeout(window.searchTimeout);
    window.searchTimeout = setTimeout(() => {
      onSearchChange(value);
    }, 500);
  };

  const handleTypeFilterChange = (value) => {
    setLocalTypeFilter(value);
    onTypeFilterChange(value);
  };

  const clearFilters = () => {
    setLocalSearch('');
    setLocalTypeFilter('all');
    onSearchChange('');
    onTypeFilterChange('all');
  };

  const getAlertIcon = (type) => {
    switch (type) {
      case 'email':
        return <Mail className="h-4 w-4 text-blue-600" />;
      case 'telegram':
        return <MessageSquare className="h-4 w-4 text-emerald-600" />;
      default:
        return <Mail className="h-4 w-4 text-slate-600" />;
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    try {
      return new Date(dateString).toLocaleString();
    } catch (error) {
      return 'Invalid Date';
    }
  };

  // Sort alerts by date (most recent first)
  const sortedAlerts = [...alerts].sort((a, b) => {
    const dateA = new Date(a.sentAt || a.createdAt || a.timestamp);
    const dateB = new Date(b.sentAt || b.createdAt || b.timestamp);
    return dateB - dateA;
  });

  const hasActiveFilters = localSearch || localTypeFilter !== 'all';

  if (loading) {
    return (
      <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60">
        <div className="p-6">
          <div className="animate-pulse space-y-4">
            {[...Array(5)].map((_, index) => (
              <div key={index} className="flex items-center space-x-4">
                <div className="h-4 bg-slate-200 rounded w-4"></div>
                <div className="h-4 bg-slate-200 rounded w-1/4"></div>
                <div className="h-4 bg-slate-200 rounded w-1/4"></div>
                <div className="h-4 bg-slate-200 rounded w-1/2"></div>
              </div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
      {/* Header with filters */}
      <div className="px-6 py-5 border-b border-slate-200/60">
        <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
          <div className="flex flex-col sm:flex-row sm:items-center gap-4 flex-1">
            {/* Search */}
            <form onSubmit={handleSearchSubmit} className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-slate-400" />
              <input
                type="text"
                placeholder="Search alerts by message or website..."
                value={localSearch}
                onChange={(e) => handleSearchChange(e.target.value)}
                className="pl-10 pr-4 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm w-full sm:w-64"
              />
            </form>
            
            {/* Type Filter */}
            <select 
              value={localTypeFilter}
              onChange={(e) => handleTypeFilterChange(e.target.value)}
              className="px-4 py-2.5 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-sm"
            >
              <option value="all">All Types</option>
              <option value="email">Email</option>
              <option value="telegram">Telegram</option>
            </select>

            {/* Clear Filters */}
            {hasActiveFilters && (
              <button
                onClick={clearFilters}
                className="flex items-center space-x-2 px-3 py-2.5 text-sm text-slate-600 hover:text-slate-800 border border-slate-300 rounded-lg hover:bg-slate-50 transition-colors"
              >
                <X className="h-4 w-4" />
                <span>Clear Filters</span>
              </button>
            )}
          </div>

          {selectedAlerts.length > 0 && (
            <button
              onClick={handleBulkDeleteClick}
              disabled={isDeleting}
              className="flex items-center space-x-2 px-4 py-2.5 bg-rose-600 text-white rounded-lg hover:bg-rose-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              <Trash2 className="h-4 w-4" />
              <span>
                {isDeleting ? 'Deleting...' : `Delete Selected (${selectedAlerts.length})`}
              </span>
            </button>
          )}
        </div>

        {/* Active filters info */}
        {hasActiveFilters && (
          <div className="mt-4 flex items-center space-x-2 text-sm text-slate-600">
            <Filter className="h-4 w-4" />
            <span>Active filters:</span>
            {localSearch && (
              <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs">
                Search: "{localSearch}"
              </span>
            )}
            {localTypeFilter !== 'all' && (
              <span className="bg-green-100 text-green-800 px-2 py-1 rounded text-xs">
                Type: {localTypeFilter}
              </span>
            )}
          </div>
        )}
      </div>

      {/* Alerts Table */}
      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-slate-200">
          <thead className="bg-slate-50">
            <tr>
              <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">
                <div className="flex items-center">
                  <input
                    type="checkbox"
                    checked={selectedAlerts.length === alerts.length && alerts.length > 0}
                    onChange={handleSelectAll}
                    className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                  />
                </div>
              </th>
              <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Type</th>
              <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Website</th>
              <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Message</th>
              <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Date</th>
              <th className="px-6 py-4 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-200">
            {sortedAlerts.length === 0 ? (
              <tr>
                <td colSpan="6" className="px-6 py-12 text-center text-slate-500">
                  <div className="flex flex-col items-center space-y-3">
                    <Filter className="h-12 w-12 text-slate-300" />
                    <div className="text-lg font-medium">No alerts found</div>
                    <div className="text-sm">Try adjusting your search or filters</div>
                    {hasActiveFilters && (
                      <button
                        onClick={clearFilters}
                        className="mt-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors text-sm font-medium"
                      >
                        Clear all filters
                      </button>
                    )}
                  </div>
                </td>
              </tr>
            ) : (
              sortedAlerts.map((alert) => (
                <tr key={alert.id} className="hover:bg-slate-50/50 transition-colors">
                  <td className="px-6 py-4">
                    <div className="flex items-center">
                      <input
                        type="checkbox"
                        checked={selectedAlerts.includes(alert.id)}
                        onChange={() => handleSelectAlert(alert.id)}
                        className="rounded border-slate-300 text-blue-600 focus:ring-blue-500"
                      />
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center space-x-2">
                      {getAlertIcon(alert.type)}
                      <span className="capitalize font-medium text-sm text-slate-900">{alert.type}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center space-x-2">
                      <Globe className="h-4 w-4 text-slate-400" />
                      <span className="text-sm text-slate-900">
                        {alert.Website?.name || alert.Website?.url || alert.websiteName || 'Unknown'}
                      </span>
                    </div>
                  </td>
                  <td className="px-6 py-4 max-w-md">
                    <div className="text-sm text-slate-900 truncate" title={alert.message}>
                      {alert.message}
                    </div>
                    {alert.details && (
                      <div className="text-xs text-slate-500 mt-1 truncate" title={alert.details}>
                        {alert.details}
                      </div>
                    )}
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center space-x-2 text-sm text-slate-600">
                      <Calendar className="h-4 w-4" />
                      <span>{formatDate(alert.sentAt || alert.createdAt || alert.timestamp)}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <button
                      onClick={() => handleDeleteClick(alert.id)}
                      className="text-rose-600 hover:text-rose-900 transition-colors p-1"
                      title="Delete alert"
                    >
                      <Trash2 className="h-4 w-4" />
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      {pagination && pagination.totalPages > 1 && (
        <div className="px-6 py-4 border-t border-slate-200/60">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div className="text-sm text-slate-700">
              Showing {((pagination.currentPage - 1) * pagination.itemsPerPage) + 1} to{' '}
              {Math.min(pagination.currentPage * pagination.itemsPerPage, pagination.totalItems)} of{' '}
              {pagination.totalItems} alerts
            </div>
            <div className="flex space-x-2">
              <button
                onClick={() => onPageChange(pagination.currentPage - 1)}
                disabled={pagination.currentPage === 1}
                className="px-3 py-1.5 border border-slate-300 rounded-lg text-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-slate-50 transition-colors"
              >
                Previous
              </button>
              <span className="px-3 py-1.5 text-sm text-slate-700">
                Page {pagination.currentPage} of {pagination.totalPages}
              </span>
              <button
                onClick={() => onPageChange(pagination.currentPage + 1)}
                disabled={pagination.currentPage === pagination.totalPages}
                className="px-3 py-1.5 border border-slate-300 rounded-lg text-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-slate-50 transition-colors"
              >
                Next
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default AlertsList;