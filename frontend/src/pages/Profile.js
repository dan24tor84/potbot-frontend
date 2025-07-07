import React from 'react';
import './Profile.css';

const Profile = () => {
  const user = {
    name: 'Pro User',
    email: 'pro@rankyourdank.com',
    plan: 'Pot Bot Pro',
    uploadsToday: 23,
    maxUploads: 'Unlimited',
  };

  return (
    <div className="profile-container">
      <h2>Your Profile</h2>
      <div className="profile-card">
        <p><strong>Name:</strong> {user.name}</p>
        <p><strong>Email:</strong> {user.email}</p>
        <p><strong>Plan:</strong> {user.plan}</p>
        <p><strong>Uploads Today:</strong> {user.uploadsToday}</p>
        <p><strong>Max Uploads:</strong> {user.maxUploads}</p>
      </div>
    </div>
  );
};

export default Profile;
