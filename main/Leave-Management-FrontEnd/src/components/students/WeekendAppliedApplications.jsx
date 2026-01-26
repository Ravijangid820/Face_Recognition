import React, { useContext, useEffect, useState } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { AuthContext, AxiosPost } from "../../context/AuthContext";
import toast from "react-hot-toast";
import { ClipLoader } from "react-spinners";
import { Calendar, MapPin, Clock, Badge } from 'lucide-react'; 
import { Chip, Tooltip, Box, Typography, Avatar } from '@mui/material';
import { format } from 'date-fns';
import { CheckCircle, Hourglass, XCircle, RotateCcw } from 'lucide-react';

const getStatusColor = (status) => {
  const statusMap = {
    'approved': { color: '#4CAF50', bg: '#E8F5E9', icon: <CheckCircle size={16} /> },
    'applied': { color: '#FB8C00', bg: '#FFF3E0', icon: <Hourglass size={16} /> },
    'rejected': { color: '#E53935', bg: '#FFEBEE', icon: <XCircle size={16} /> },
    'in_progress': { color: '#1E88E5', bg: '#E3F2FD', icon: <RotateCcw size={16} /> },
  };

  return statusMap[status.toLowerCase()] || { color: '#757575', bg: '#FAFAFA', icon: <CheckCircle size={16} /> }; 
};


const columns = [
  {
    flex: 0.15,
    field: "date",
    minWidth: 150,
    headerName: (
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
        <Calendar size={20} />
        <Typography>Date</Typography>
      </Box>
    ),
    renderCell: ({ row }) => {
      return (
        <Tooltip title={format(new Date(row.date), 'PPP')} arrow>
          <Box sx={{ 
            display: "flex", 
            alignItems: "center", 
            gap: 1,
            '&:hover': { '& svg': { color: '#2196F3' } }
          }}>
            <Typography sx={{ 
              color: "text.secondary",
              transition: 'color 0.2s',
              '&:hover': { color: 'primary.main' }
            }}>
              {format(new Date(row.date), 'dd MMM yyyy')}
            </Typography>
          </Box>
        </Tooltip>
      );
    },
  },
  {
    flex: 0.1,
    minWidth: 120,
    field: "status",
    headerName: (
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
        <Typography>Status</Typography>
      </Box>
    ),
    renderCell: ({ row }) => {
      const statusConfig = getStatusColor(row.status);
      
      return (
        <Chip
          icon={<Badge size={16} />}
          label={row.status}
          sx={{
            backgroundColor: statusConfig.bg,
            color: statusConfig.color,
            borderRadius: '16px',
            '& .MuiChip-icon': { color: statusConfig.color },
            transition: 'transform 0.2s',
            '&:hover': {
              transform: 'scale(1.05)',
              boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
            }
          }}
        />
      );
    },
  },
  {
    field: "place_of_visit",
    headerName: (
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
        <Typography>Place of Visit</Typography>
      </Box>
    ),
    width: 200,
    renderCell: ({ row }) => {
      return (
        <Box sx={{ 
          display: 'flex', 
          alignItems: 'center', 
          gap: 1,
          '&:hover': { '& svg': { color: '#2196F3' } }
        }}>
          <MapPin size={18} />
          <Box sx={{ display: 'flex', flexDirection: 'column' }}>
            <Typography sx={{ color: 'text.primary' }}>
              {row.place_of_visit}
            </Typography>
            {row.place_details && (
              <Typography variant="caption" sx={{ color: 'text.secondary' }}>
                {row.place_details}
              </Typography>
            )}
          </Box>
        </Box>
      );
    },
  },
];


// StudentsTable Component
const WeekendAppliedApplications = () => {
  const [paginationModel, setPaginationModel] = useState({
    page: 0,
    pageSize: 10,
  });
  const [studentApplications, setStudentApplications] = useState();
  const [isLoading, setIsLoading] = useState(false);
  const { user } = useContext(AuthContext);

  const fetchStudentApplications = async () => {
    setIsLoading(true);
    try {
      const data = await AxiosPost("fetchStudentWeekendApplications.php", {
        reg_no: user.reg_no,
      });
      // console.log(data)
      if (data.success) {
        setStudentApplications(data.student_applications);
      } else toast.error(data.error);
    } catch (err) {
      toast.error("Server Error!");
      console.log(err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchStudentApplications();
  }, []);

  const getRowId = (row) => {
    return row.id;
  };

  if (!studentApplications) {
    return (
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          height: "100vh",
          width: "100vw",
        }}
      >
        <ClipLoader
          color={"#36D7B7"}
          loading={true}
          size={50}
          aria-label="Loading Spinner"
          data-testid="loader"
        />
      </div>
    );
  } else {
    return (
      <>
        <DataGrid
          rows={studentApplications}
          autoHeight
          columns={columns}
          loading={isLoading}
          getRowId={getRowId}
          pageSizeOptions={[10, 25, 50]}
          paginationModel={paginationModel}
          onPaginationModelChange={setPaginationModel}
          slots={{ toolbar: GridToolbar }}
          sx={{
            "& .MuiDataGrid-columnHeaders": { borderRadius: 0, width: "100%" },
          }}
        />
      </>
    );
  }
};

export default WeekendAppliedApplications;
