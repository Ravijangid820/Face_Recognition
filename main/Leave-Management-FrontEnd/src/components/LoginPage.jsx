import React, { useState, useContext } from 'react';
import './LoginPage.css'
import { Button, Box, Container, FormControl, InputLabel, Grid, OutlinedInput, InputAdornment, IconButton, FormHelperText } from '@mui/material';
import { mdiEye, mdiEyeOff } from '@mdi/js';
import Icon from '@mdi/react';
import * as yup from 'yup';
import { useForm, Controller } from 'react-hook-form';
import { yupResolver } from '@hookform/resolvers/yup';
import { AuthContext } from '../context/AuthContext';

const LoginPage = () => {
    const defaultValues = {
        reg_no: '',
        password: ''
    };

    const schema = yup.object().shape({
        reg_no: yup.string().required('reg_no is required'),
        password: yup.string().min(5, 'Password must be at least 5 characters').required('Password is required')
    });

    const [showPassword, setShowPassword] = useState(false);

    const { control, handleSubmit, formState: { errors } } = useForm({
        defaultValues,
        resolver: yupResolver(schema)
    });

    const { loginUser } = useContext(AuthContext);

    const onSubmit = data => {
        loginUser(data);
    };

    return (
        <Box sx={{ display: 'flex', height: '100vh' }}>
            <div className='left-division'>
                <h1>Welcome!</h1>
                <h2>Leave Info Portal</h2>
            </div>
            <Grid item display={'flex'} flexDirection={'column'} className='right-division'>
                <Container maxWidth="xs">
                    <Box
                        sx={{
                            display: 'flex',
                            flexDirection: 'column',
                            alignItems: 'center',
                            mt: 8,
                            p: 3,
                            boxShadow: 3,
                            borderRadius: 2,
                            backgroundColor: '#fff'
                        }}
                    >
                        <form noValidate autoComplete='off' onSubmit={handleSubmit(onSubmit)}>
                            <Grid sx={{ display: 'flex', alignItems: 'center', justifyContent: 'center', mb: 8, mt: 4 }}>
                                <img width={'250px'} src={'./logo.png'} alt='logo'></img>
                            </Grid>
                            <FormControl fullWidth sx={{ mb: 4 }}>
                                <InputLabel htmlFor='auth-login-reg_no' error={Boolean(errors.reg_no)}>Registration Number</InputLabel>
                                <Controller
                                    name='reg_no'
                                    control={control}
                                    render={({ field }) => (
                                        <OutlinedInput
                                            id='auth-login-reg_no'
                                            {...field}
                                            label='Registration Number'
                                            error={Boolean(errors.reg_no)}
                                        />
                                    )}
                                />
                                {errors.reg_no && <FormHelperText sx={{ color: 'error.main' }}>{errors.reg_no.message}</FormHelperText>}
                            </FormControl>
                            <FormControl fullWidth>
                                <InputLabel htmlFor='auth-login-password' error={Boolean(errors.password)}>Password</InputLabel>
                                <Controller
                                    name='password'
                                    control={control}
                                    render={({ field }) => (
                                        <OutlinedInput
                                            id='auth-login-password'
                                            {...field}
                                            type={showPassword ? 'text' : 'password'}
                                            label='Password'
                                            error={Boolean(errors.password)}
                                            endAdornment={
                                                <InputAdornment position='end'>
                                                    <IconButton onClick={() => setShowPassword(!showPassword)}>
                                                        <Icon path={showPassword ? mdiEye : mdiEyeOff} size={1} />
                                                    </IconButton>
                                                </InputAdornment>
                                            }
                                        />
                                    )}
                                />
                                {errors.password && <FormHelperText sx={{ color: 'error.main' }}>{errors.password.message}</FormHelperText>}
                            </FormControl>
                            <Button
                                type="submit"
                                fullWidth
                                variant="contained"
                                sx={{ mt: 3, mb: 7, backgroundColor: '#2148z0', color: '#fff' }}
                            >
                                Login
                            </Button>
                        </form>
                    </Box>
                </Container>
            </Grid>
        </Box>
    );
};

export default LoginPage;
