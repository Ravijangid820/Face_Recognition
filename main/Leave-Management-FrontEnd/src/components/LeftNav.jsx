

import { useNavigate } from 'react-router-dom';
import { useContext, useState } from 'react';
import { AuthContext } from '../context/AuthContext';

import Box from '@mui/material/Box';
import InputLabel from '@mui/material/InputLabel';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import MenuItem from '@mui/material/MenuItem';
import { Grid } from '@mui/material';

const NativeSelectDemo = () => {
    const navigate = useNavigate();
    const { user } = useContext(AuthContext);

    const [outingType, setOutingType] = useState('');

    const handleChange = (event) => {
        setOutingType(event.target.value);
    };

    const onClickApply = () => {
        if(outingType === '') {
            return;
        } else if(outingType === 'general') {
            navigate('/GeneralApplication');
        } else if(outingType === 'urgent') {
          navigate('/UrgentApplication');
        } else {
            navigate('/WeekendApplication');
        }
    }
  
    return (
        <>
        {user && user.privilege === 'student' && (
            <Box sx={{ minWidth: 150 }}>
            <FormControl variant="standard" fullWidth>
              <InputLabel
                id="demo-simple-select-standard-label"
                sx={{ 
                  color: '#fff',  // This sets the default color to white
                  '&.Mui-focused': {
                    color: '#fff'  // This keeps the color white when focused
                  }
                }}
              >
                Outing Type
              </InputLabel>
              <Select
            value={outingType}
            onChange={handleChange}
            id="demo-simple-select-standard"
            labelId="demo-simple-select-standard-label"
            inputProps={{
              name: 'outingType',
            }}
            sx={{ 
              color: "#fff", 
              // backgroundColor: '#101214',
              '&:before': {
                borderColor: '#fff',
              },
              '&:after': {
                borderColor: '#fff',
              },
              '&:hover:not(.Mui-disabled):before': {
                borderColor: '#fff',
              },
              '& .MuiSvgIcon-root': {
                color: '#fff',
              },
            }}
          >
            <MenuItem value="weekend" style={{ color: '#101214' }}>Weekend Outing</MenuItem>
            <MenuItem value="general" style={{ color: '#101214' }}>General Outing</MenuItem>
            <MenuItem value="urgent" style={{ color: '#101214' }}>Urgent General Outing</MenuItem>
          </Select>
              
                  <Grid container justifyContent="center" sx={{ mt: 2 }}>
                      <button style={{ width:'85%', fontSize: '1.3rem' }} onClick={onClickApply}>Apply</button>
                  </Grid>
            </FormControl>
          </Box>
        )}
        </>
    );
  };

const LeftNav = () => {

    const { logoutUser } = useContext(AuthContext);    
      
    return (
        <div className="left-side">
          <img src={`${process.env.PUBLIC_URL}/vit_logo.jpeg`} alt='logo' className='logo-img'></img>
            <p className="menu-item">DASHBOARD</p>
            <NativeSelectDemo />
            <div className="menu-item-group">
              <p className="menu-item1">SETTING</p>
              <button style={{ width:'75%', fontSize: '1.3rem', px:'1.5rem' }} onClick={logoutUser}>LOGOUT ?</button>
            </div>
          </div>
    )
}

export default LeftNav;