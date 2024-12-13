import React from 'react';
import { Box, Paper, Typography, Avatar } from '@mui/material';
import PropTypes from 'prop-types';

function ReviewTab({ reviews }) {
  return (
    <Box sx={{ width: '100%' }}>
      <Typography variant="h4" sx={{ mb: 3, fontWeight: 'bold' }}>
        Reviews
      </Typography>
      {reviews.map((review) => (
        <Paper
          key={review.id}
          sx={{
            p: 2,
            mb: 2,
            width: '100%',
            backgroundColor: 'grey.100',
            boxShadow: 'none',
            borderRadius: 2
          }}
        >
          <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
            <Avatar sx={{ width: 40, height: 40, mr: 2 }} />
            <Box>
              <Typography variant="subtitle1" sx={{ fontWeight: 'bold' }}>
                {review.userName}
              </Typography>
              <Typography variant="body2" color="text.secondary">
                {new Date(review.date).toLocaleDateString()}
              </Typography>
            </Box>
          </Box>
          {review.verified && (
            <Typography 
              variant="body2" 
              color="success.main" 
              sx={{ mb: 1, textTransform: 'uppercase', fontWeight: 'medium' }}
            >
              Verified Review
            </Typography>
          )}
          <Typography variant="body1">
            {review.comment}
          </Typography>
        </Paper>
      ))}
    </Box>
  );
}

ReviewTab.propTypes = {
  reviews: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string.isRequired,
      userName: PropTypes.string.isRequired,
      comment: PropTypes.string.isRequired,
      date: PropTypes.string.isRequired,
      verified: PropTypes.bool,
    })
  ).isRequired,
};

export default ReviewTab; 