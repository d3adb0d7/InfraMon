import React from 'react';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
} from 'chart.js';
import { Bar } from 'react-chartjs-2';

ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

const ResponseTimeChart = ({ data, height = 300 }) => {
  const chartData = {
    labels: data?.map(item => {
      const hour = new Date(item.hour);
      return hour.toLocaleTimeString('en-US', { hour: '2-digit', hour12: true });
    }) || [],
    datasets: [
      {
        label: 'Average Response Time (ms)',
        data: data?.map(item => item.avgResponseTime) || [],
        backgroundColor: 'rgba(59, 130, 246, 0.8)',
        borderColor: 'rgb(59, 130, 246)',
        borderWidth: 1,
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: false
      },
      tooltip: {
        callbacks: {
          label: function(context) {
            return `Avg Response Time: ${context.parsed.y.toFixed(2)}ms`;
          }
        }
      }
    },
    scales: {
      y: {
        beginAtZero: true,
        title: {
          display: true,
          text: 'Response Time (ms)'
        },
        grid: {
          color: 'rgba(0, 0, 0, 0.1)'
        }
      },
      x: {
        grid: {
          display: false
        }
      }
    }
  };

  if (!data || data.length === 0) {
    return (
      <div className="flex items-center justify-center h-64 bg-gray-50 rounded-lg">
        <div className="text-center text-gray-500">
          <div className="text-lg mb-2">No data available</div>
          <div className="text-sm">Select a date range to see response time statistics</div>
        </div>
      </div>
    );
  }

  return (
    <div style={{ height: `${height}px` }}>
      <Bar data={chartData} options={options} />
    </div>
  );
};

export default ResponseTimeChart;