#ifndef PLUGINSTRUCTS_P116_DATA_STRUCT_H
#define PLUGINSTRUCTS_P116_DATA_STRUCT_H

#include "../../_Plugin_Helper.h"
#include <SparkFunLSM9DS1.h>

#ifdef USES_P116

struct P116_data_struct : public PluginTaskData_base {
public:

  P116_data_struct();
  ~P116_data_struct();
  bool isInitialized();
  void loop();
  void getMotions(float *ax, float *ay, float *az, float *gx, float *gy, float *gz);
  float axis[6]; // [ax, ay, az, gx, gy, gz] stock the value

private:
  /** Get raw 6-axis motion sensor readings (accel/gyro) (do not include magnet and temp)
   * Retrieves all currently available motion sensor values.
   * @param ax 16-bit signed integer converted to float container for accelerometer X-axis value
   * @param ay 16-bit signed integer converted to float container for accelerometer Y-axis value
   * @param az 16-bit signed integer converted to float container for accelerometer Z-axis value
   * @param gx 16-bit signed integer converted to float container for gyroscope X-axis value
   * @param gy 16-bit signed integer converted to float container for gyroscope Y-axis value
   * @param gz 16-bit signed integer converted to float container for gyroscope Z-axis value
   */
  LSM9DS1* imu;
};

#endif // ifdef USES_P116
#endif // ifndef PLUGINSTRUCTS_P116_DATA_STRUCT_H