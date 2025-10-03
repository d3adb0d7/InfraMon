// frontend/src/pages/Reports.js
import React, { useState, useEffect } from 'react';
import { 
  BarChart3, 
  Download, 
  RefreshCw,
  Globe,
  AlertTriangle,
  Server,
  Calendar,
  TrendingUp,
  CheckCircle,
  X
} from 'lucide-react';
import { reportsAPI, websitesAPI } from '../services/api';
import DateRangeSelector from '../components/Reports/DateRangeSelector';
import StatCards from '../components/Reports/StatCards';
import UptimeChart from '../components/Reports/UptimeChart';
import ResponseTimeChart from '../components/Reports/ResponseTimeChart';
import ExportButton from '../components/Reports/ExportButton';
import { getTodayDate, getDaysAgo } from '../utils/dateUtils';

const Reports = () => {
  const [activeTab, setActiveTab] = useState('overview');
  const [dateRange, setDateRange] = useState({
  startDate: getDaysAgo(30),
  endDate: getTodayDate(),
  preset: 30
});
  const [overviewData, setOverviewData] = useState(null);
  const [websiteReport, setWebsiteReport] = useState(null);
  const [alertsReport, setAlertsReport] = useState(null);
  const [websites, setWebsites] = useState([]);
  const [selectedWebsite, setSelectedWebsite] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    loadWebsites();
    loadOverviewData();
  }, []);

  useEffect(() => {
    if (dateRange.startDate && dateRange.endDate) {
      loadReportData();
    }
  }, [dateRange, activeTab, selectedWebsite]);

  const loadWebsites = async () => {
    try {
      const response = await websitesAPI.getAll();
      setWebsites(response.data);
      if (response.data.length > 0) {
        setSelectedWebsite(response.data[0].id);
      }
    } catch (error) {
      console.error('Error loading websites:', error);
      setError('Failed to load websites');
    }
  };

  const loadReportData = async () => {
    setLoading(true);
    setError('');
    try {
      const params = {
        startDate: dateRange.startDate,
        endDate: dateRange.endDate
      };

      console.log('Loading report data with params:', params);

      switch (activeTab) {
        case 'overview':
          const overviewResponse = await reportsAPI.getOverview(params);
          console.log('Overview data loaded:', overviewResponse.data);
          setOverviewData(overviewResponse.data);
          break;
          
        case 'website':
          if (selectedWebsite) {
            const websiteResponse = await reportsAPI.getWebsiteReport(selectedWebsite, params);
            console.log('Website report data loaded:', websiteResponse.data);
            setWebsiteReport(websiteResponse.data);
          }
          break;
          
        case 'alerts':
          const alertsResponse = await reportsAPI.getAlertsReport(params);
          console.log('Alerts report data loaded:', alertsResponse.data);
          setAlertsReport(alertsResponse.data);
          break;
          
        default:
          break;
      }
    } catch (error) {
      console.error('Error loading report data:', error);
      const errorMessage = error.response?.data?.error || error.message || 'Failed to load report data';
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  const loadOverviewData = async (params = {}) => {
    try {
      const response = await reportsAPI.getOverview(params);
      setOverviewData(response.data);
    } catch (error) {
      console.error('Error loading overview data:', error);
      setError('Failed to load overview data');
    }
  };

  const handleRefresh = () => {
    loadReportData();
  };

  const tabs = [
    { id: 'overview', label: 'Overview', icon: BarChart3 },
    { id: 'website', label: 'Website Details', icon: Globe },
    { id: 'alerts', label: 'Alerts', icon: AlertTriangle }
  ];

  const renderOverviewTab = () => (
    <div className="space-y-6">
      <StatCards overviewData={overviewData} loading={loading} />
      
      {error && (
        <div className="bg-rose-50 border border-rose-200 text-rose-700 px-4 py-3 rounded-xl">
          <div className="flex items-center">
            <AlertTriangle className="h-5 w-5 mr-3" />
            <span>{error}</span>
          </div>
        </div>
      )}
      
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60">
          <h3 className="text-lg font-semibold text-slate-900 mb-4">Uptime Trend</h3>
          <UptimeChart 
            data={overviewData?.dailyStats || []} 
            height={300} 
          />
        </div>
        
        <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60">
          <h3 className="text-lg font-semibold text-slate-900 mb-4">Status Distribution</h3>
          {overviewData?.statusDistribution ? (
            <div className="space-y-4">
              {Object.entries(overviewData.statusDistribution).map(([status, count]) => (
                <div key={status} className="flex items-center justify-between">
                  <span className="capitalize text-slate-700 text-sm">{status}</span>
                  <div className="flex items-center space-x-3">
                    <div className="w-32 bg-slate-200 rounded-full h-2">
                      <div 
                        className={`h-2 rounded-full ${
                          status === 'up' ? 'bg-emerald-500' :
                          status === 'down' ? 'bg-rose-500' :
                          'bg-slate-500'
                        }`}
                        style={{ 
                          width: `${(count / overviewData.totalWebsites) * 100}%` 
                        }}
                      ></div>
                    </div>
                    <span className="font-medium w-8 text-right text-slate-900">{count}</span>
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <div className="text-center text-slate-500 py-8">No data available</div>
          )}
        </div>
      </div>

      <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
        <div className="px-6 py-4 border-b border-slate-200/60 flex justify-between items-center">
          <h3 className="text-lg font-semibold text-slate-900">Daily Statistics</h3>
          <ExportButton dateRange={dateRange} type="monitoring" disabled={loading} />
        </div>
        
        <div className="p-6">
          {overviewData?.dailyStats && overviewData.dailyStats.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-slate-200">
                <thead className="bg-slate-50">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Date</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Checks</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Up Checks</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Uptime</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Avg Response Time</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200">
                  {overviewData.dailyStats.map((day, index) => (
                    <tr key={index} className="hover:bg-slate-50/50">
                      <td className="px-4 py-3 text-sm text-slate-900">{day.date}</td>
                      <td className="px-4 py-3 text-sm text-slate-600">{day.checks}</td>
                      <td className="px-4 py-3 text-sm text-slate-600">{day.upChecks}</td>
                      <td className="px-4 py-3 text-sm text-slate-600">{day.uptime?.toFixed(2)}%</td>
                      <td className="px-4 py-3 text-sm text-slate-600">{day.avgResponseTime?.toFixed(2)}ms</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="text-center text-slate-500 py-8">No data available for the selected date range</div>
          )}
        </div>
      </div>
    </div>
  );

  const renderWebsiteTab = () => (
    <div className="space-y-6">
      {/* Website Selector */}
      <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60">
        <label htmlFor="website-select" className="block text-sm font-medium text-slate-700 mb-3">
          Select Website
        </label>
        <select
          id="website-select"
          value={selectedWebsite}
          onChange={(e) => setSelectedWebsite(e.target.value)}
          className="block w-full pl-3 pr-10 py-2.5 text-base border-slate-300 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-lg border"
        >
          {websites.map(website => (
            <option key={website.id} value={website.id}>
              {website.name || website.url}
            </option>
          ))}
        </select>
      </div>

      {websiteReport && (
        <>
          {/* Website Statistics */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="bg-white rounded-2xl p-6 text-center shadow-sm border border-slate-200/60">
              <div className="text-2xl font-bold text-slate-900">{websiteReport.statistics?.totalChecks || 0}</div>
              <div className="text-sm text-slate-600">Total Checks</div>
            </div>
            <div className="bg-white rounded-2xl p-6 text-center shadow-sm border border-slate-200/60">
              <div className="text-2xl font-bold text-emerald-600">{websiteReport.statistics?.uptimePercentage || 0}%</div>
              <div className="text-sm text-slate-600">Uptime</div>
            </div>
            <div className="bg-white rounded-2xl p-6 text-center shadow-sm border border-slate-200/60">
              <div className="text-2xl font-bold text-violet-600">{websiteReport.statistics?.avgResponseTime || 0}ms</div>
              <div className="text-sm text-slate-600">Avg Response Time</div>
            </div>
            <div className="bg-white rounded-2xl p-6 text-center shadow-sm border border-slate-200/60">
              <div className="text-2xl font-bold text-rose-600">{websiteReport.statistics?.downChecks || 0}</div>
              <div className="text-sm text-slate-600">Down Checks</div>
            </div>
          </div>

          {/* Response Time Chart */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-slate-200/60">
            <h3 className="text-lg font-semibold text-slate-900 mb-4">Response Time Trends</h3>
            <ResponseTimeChart data={websiteReport.hourlyStats || []} height={300} />
          </div>

          {/* Recent Alerts */}
          <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
            <div className="px-6 py-4 border-b border-slate-200/60 flex justify-between items-center">
              <h3 className="text-lg font-semibold text-slate-900">Recent Alerts</h3>
              <ExportButton dateRange={dateRange} type="alerts" disabled={loading} />
            </div>
            
            <div className="p-6">
              {websiteReport.recentAlerts && websiteReport.recentAlerts.length > 0 ? (
                <div className="space-y-3">
                  {websiteReport.recentAlerts.map((alert, index) => (
                    <div key={index} className="flex items-center justify-between p-3 bg-rose-50 rounded-lg border border-rose-200">
                      <div>
                        <div className="font-medium text-rose-800 text-sm">{alert.type?.toUpperCase()} Alert</div>
                        <div className="text-xs text-rose-600">{alert.message}</div>
                      </div>
                      <div className="text-xs text-rose-600">
                        {new Date(alert.sentAt).toLocaleDateString()}
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center text-slate-500 py-8">No alerts for this period</div>
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );

  const renderAlertsTab = () => (
    <div className="space-y-6">
      {alertsReport && (
        <>
          {/* Alert Statistics */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-white rounded-2xl p-6 text-center shadow-sm border border-slate-200/60">
              <div className="text-2xl font-bold text-slate-900">{alertsReport.statistics?.total || 0}</div>
              <div className="text-sm text-slate-600">Total Alerts</div>
            </div>
            <div className="bg-white rounded-2xl p-6 text-center shadow-sm border border-slate-200/60">
              <div className="text-2xl font-bold text-blue-600">{alertsReport.statistics?.byType?.email || 0}</div>
              <div className="text-sm text-slate-600">Email Alerts</div>
            </div>
            <div className="bg-white rounded-2xl p-6 text-center shadow-sm border border-slate-200/60">
              <div className="text-2xl font-bold text-emerald-600">{alertsReport.statistics?.byType?.telegram || 0}</div>
              <div className="text-sm text-slate-600">Telegram Alerts</div>
            </div>
          </div>

          {/* Alerts List */}
          <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
            <div className="px-6 py-4 border-b border-slate-200/60 flex justify-between items-center">
              <h3 className="text-lg font-semibold text-slate-900">Alert History</h3>
              <ExportButton dateRange={dateRange} type="alerts" disabled={loading} />
            </div>
            
            <div className="p-6">
              {alertsReport.alerts && alertsReport.alerts.length > 0 ? (
                <div className="overflow-x-auto">
                  <table className="min-w-full divide-y divide-slate-200">
                    <thead className="bg-slate-50">
                      <tr>
                        <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Date</th>
                        <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Type</th>
                        <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Website</th>
                        <th className="px-4 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">Message</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-200">
                      {alertsReport.alerts.map((alert, index) => (
                        <tr key={index} className="hover:bg-slate-50/50">
                          <td className="px-4 py-3 text-sm text-slate-900">
                            {new Date(alert.sentAt).toLocaleString()}
                          </td>
                          <td className="px-4 py-3 text-sm">
                            <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${
                              alert.type === 'email' ? 'bg-blue-100 text-blue-800' : 'bg-emerald-100 text-emerald-800'
                            }`}>
                              {alert.type}
                            </span>
                          </td>
                          <td className="px-4 py-3 text-sm text-slate-600">
                            {alert.Website?.name || alert.Website?.url}
                          </td>
                          <td className="px-4 py-3 text-sm text-slate-600 max-w-xs truncate">
                            {alert.message}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              ) : (
                <div className="text-center text-slate-500 py-8">No alerts for the selected date range</div>
              )}
            </div>
          </div>
        </>
      )}
    </div>
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50/30">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        
        {/* Header */}
        <div className="mb-8">
          <div className="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div className="text-center lg:text-left">
              <h1 className="text-4xl font-bold text-slate-900 mb-3">Reports & Analytics</h1>
              <p className="text-lg text-slate-600">Comprehensive monitoring insights and performance analytics</p>
            </div>
            
            <div className="flex items-center space-x-3 justify-center lg:justify-end">
              <button
                onClick={handleRefresh}
                disabled={loading}
                className="bg-blue-600 text-white px-4 py-2.5 rounded-lg font-medium hover:bg-blue-700 disabled:opacity-50 transition-colors flex items-center space-x-2"
              >
                <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                <span>Refresh</span>
              </button>
            </div>
          </div>
        </div>

        {/* Date Range Selector */}
        <DateRangeSelector 
          dateRange={dateRange}
          onDateRangeChange={setDateRange}
          loading={loading}
        />

        {/* Error Display */}
        {error && (
          <div className="bg-rose-50 border border-rose-200 text-rose-700 px-4 py-3 rounded-xl mb-6">
            <div className="flex items-center">
              <AlertTriangle className="h-5 w-5 mr-3" />
              <span>{error}</span>
            </div>
          </div>
        )}

        {/* Tabs */}
        <div className="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
          <div className="border-b border-slate-200/60">
            <nav className="flex space-x-8 px-6">
              {tabs.map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id)}
                    className={`py-4 px-1 border-b-2 font-medium text-sm flex items-center space-x-2 transition-colors ${
                      activeTab === tab.id
                        ? 'border-blue-500 text-blue-600'
                        : 'border-transparent text-slate-500 hover:text-slate-700 hover:border-slate-300'
                    }`}
                  >
                    <Icon className="h-4 w-4" />
                    <span>{tab.label}</span>
                  </button>
                );
              })}
            </nav>
          </div>

          {/* Tab Content */}
          <div className="p-6">
            {loading ? (
              <div className="flex justify-center items-center py-12">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
              </div>
            ) : (
              <>
                {activeTab === 'overview' && renderOverviewTab()}
                {activeTab === 'website' && renderWebsiteTab()}
                {activeTab === 'alerts' && renderAlertsTab()}
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Reports;