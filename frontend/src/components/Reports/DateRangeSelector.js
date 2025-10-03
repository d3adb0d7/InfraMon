// frontend/src/components/Reports/DateRangeSelector.js
import React from 'react';
import { Calendar, ChevronDown } from 'lucide-react';
import { getTodayDate, getDaysAgo, formatDateForInput } from '../../utils/dateUtils';

const DateRangeSelector = ({ dateRange, onDateRangeChange, loading = false }) => {
  const presetRanges = [
    { label: 'Last 7 days', value: 7 },
    { label: 'Last 30 days', value: 30 },
    { label: 'Last 90 days', value: 90 },
    { label: 'Last 6 months', value: 180 },
    { label: 'Last 1 year', value: 365 },
    { label: 'Custom', value: 'custom' }
  ];

  // Initialize with proper dates if not set
  React.useEffect(() => {
    if (!dateRange.startDate || !dateRange.endDate) {
      onDateRangeChange({
        startDate: getDaysAgo(30),
        endDate: getTodayDate(),
        preset: 30
      });
    }
  }, []);

  const handlePresetChange = (days) => {
    if (days === 'custom') {
      onDateRangeChange({
        ...dateRange,
        preset: 'custom'
      });
      return;
    }
    
    onDateRangeChange({
      startDate: getDaysAgo(days),
      endDate: getTodayDate(),
      preset: days
    });
  };

  const handleDateChange = (field, value) => {
    try {
      // Validate the date value
      if (value) {
        const testDate = new Date(value);
        if (isNaN(testDate.getTime())) {
          console.error('Invalid date value:', value);
          return;
        }
      }
      
      onDateRangeChange({
        ...dateRange,
        [field]: value,
        preset: 'custom'
      });
    } catch (error) {
      console.error('Error handling date change:', error);
    }
  };

  // Safely get current values with defaults
  const currentStartDate = dateRange?.startDate ? formatDateForInput(dateRange.startDate) : getDaysAgo(30);
  const currentEndDate = dateRange?.endDate ? formatDateForInput(dateRange.endDate) : getTodayDate();
  const currentPreset = dateRange?.preset || 30;

  return (
    <div className="bg-white rounded-lg border border-gray-200 p-4 mb-6">
      <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div className="flex items-center space-x-2">
          <Calendar className="h-5 w-5 text-gray-500" />
          <h3 className="text-lg font-medium text-gray-900">Date Range</h3>
        </div>
        
        <div className="flex flex-col sm:flex-row gap-3">
          {/* Preset Selector */}
          <div className="relative">
            <select
              value={currentPreset}
              onChange={(e) => {
                const value = e.target.value;
                handlePresetChange(value === 'custom' ? 'custom' : Number(value));
              }}
              disabled={loading}
              className="appearance-none bg-white border border-gray-300 rounded-lg pl-3 pr-8 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 disabled:opacity-50"
            >
              {presetRanges.map(range => (
                <option key={range.value} value={range.value}>
                  {range.label}
                </option>
              ))}
            </select>
            <ChevronDown className="absolute right-2 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400 pointer-events-none" />
          </div>

          {/* Custom Date Inputs */}
          <div className="flex gap-2">
            <input
              type="date"
              value={currentStartDate}
              onChange={(e) => handleDateChange('startDate', e.target.value)}
              disabled={loading}
              max={currentEndDate || getTodayDate()}
              className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 disabled:opacity-50"
            />
            <span className="flex items-center text-gray-500">to</span>
            <input
              type="date"
              value={currentEndDate}
              onChange={(e) => handleDateChange('endDate', e.target.value)}
              disabled={loading}
              min={currentStartDate}
              max={getTodayDate()}
              className="border border-gray-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 disabled:opacity-50"
            />
          </div>
        </div>
      </div>
      
      {currentStartDate && currentEndDate && (
        <div className="mt-3 text-sm text-gray-600">
          Showing data from <strong>{currentStartDate}</strong> to <strong>{currentEndDate}</strong>
          {currentPreset && currentPreset !== 'custom' && (
            <span className="ml-2 text-gray-400">
              ({presetRanges.find(r => r.value === currentPreset)?.label})
            </span>
          )}
        </div>
      )}
    </div>
  );
};

export default DateRangeSelector;