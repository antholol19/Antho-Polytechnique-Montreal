#include "../PluginStructs/P116_data_struct.h"

#ifdef USES_P116

#define LSM9DS1_M   0x1E // Would be 0x1C if SDO_M is LOW
#define LSM9DS1_AG  0x6B // Would be 0x6A if SDO_AG is LOW

P116_data_struct::P116_data_struct() : imu(nullptr)
{
  imu = new (std::nothrow) LSM9DS1();
  imu->begin(LSM9DS1_AG, LSM9DS1_M, Wire);
  if (!isInitialized()){
    String log = F("LSM9DS1 failed to communicate");
    addLog(LOG_LEVEL_INFO, log);
  }
  imu->setAccelScale(16);  // Set accel scale to +/-16g. (accel scale can be 2, 4, 8, or 16)
  imu->setGyroScale(2000); // Set gyro scale to +/-2000dps. (scale can be set to either 245, 500, or 2000)
  //Initialise axes
  for (unsigned int i = 0; i < 6; i++){
     axis[i] = 0.0f;
  }
}

P116_data_struct::~P116_data_struct() {
  if (imu != nullptr) {
    delete imu;
    imu = nullptr;
  }
}

bool P116_data_struct::isInitialized()
{
  return imu != nullptr;
}

void P116_data_struct::loop()
{
  getMotions(&axis[0], &axis[1], &axis[2], &axis[3], &axis[4], &axis[5]);
}

void P116_data_struct::getMotions(float *ax, float *ay, float *az, float *gx, float *gy, float *gz)
{
  imu->readAccel();
  *ax = imu->calcAccel(imu->ax);  //convert to g
  *ay = imu->calcAccel(imu->ay);
  *az = imu->calcAccel(imu->az);
  /*
  imu->readGyro();
  *gx = imu->calcGyro(imu->gx);   //convert to DPS
  *gy = imu->calcGyro(imu->gy);
  *gz = imu->calcGyro(imu->gz);
  */

  String log = F("LSM9DS1 : axis values: ");
  log += *ax;
  log += F(", ");
  log += *ay;
  log += F(", ");
  log += *az;
  /*
  log += F(", ");
  log += *gx;
  log += F(", ");
  log += *gy;
  log += F(", ");
  log += *gz;
  */
  addLog(LOG_LEVEL_INFO, log);
}


#endif 