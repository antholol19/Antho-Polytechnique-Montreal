#include "_Plugin_Helper.h"
#ifdef USES_P116

#include "src/PluginStructs/P116_data_struct.h"


#define PLUGIN_116
#define PLUGIN_ID_116     116           // plugin id
#define PLUGIN_NAME_116   "Motion - LSM9DS1" // "Plugin Name" is what will be dislpayed in the selection list
#define PLUGIN_VALUENAME1_116_1 "ax" // variable output of the plugin. The label is in quotation marks
#define PLUGIN_VALUENAME1_116_2 "ay"
#define PLUGIN_VALUENAME1_116_3 "az"


boolean Plugin_116(uint8_t function, struct EventStruct *event, String& string)
{
  boolean success = false;

  switch (function)
  {
    case PLUGIN_DEVICE_ADD:
    {
      Device[++deviceCount].Number       = PLUGIN_ID_116;
      Device[deviceCount].Type           = DEVICE_TYPE_I2C;
      Device[deviceCount].VType          = Sensor_VType::SENSOR_TYPE_SINGLE;
      Device[deviceCount].ValueCount     = 3;    // Unfortunatly domoticz has no custom multivalue sensors.
      Device[deviceCount].SendDataOption = true; //   and I use Domoticz ... so there.
      Device[deviceCount].TimerOption    = true;
      Device[deviceCount].TimerOptional  = true;
      Device[deviceCount].FormulaOption  = false;
      Device[deviceCount].DecimalsOnly   = true; 
      break;
    }

    case PLUGIN_GET_DEVICENAME:
    {
      string = F(PLUGIN_NAME_116);
      break;
    }

    case PLUGIN_GET_DEVICEVALUENAMES:
    {
      strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[0], PSTR(PLUGIN_VALUENAME1_116_1));
      strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[1], PSTR(PLUGIN_VALUENAME1_116_2));
      strcpy_P(ExtraTaskSettings.TaskDeviceValueNames[2], PSTR(PLUGIN_VALUENAME1_116_3)); 
      break;
    }

    case PLUGIN_I2C_HAS_ADDRESS:
    case PLUGIN_WEBFORM_SHOW_I2C_PARAMS:
    {
      const uint8_t i2cAddressValues[] = { 0x6B, 0x1E };
      if (function == PLUGIN_WEBFORM_SHOW_I2C_PARAMS) {
        addFormSelectorI2C(F("i2c_addr"), 2, i2cAddressValues, PCONFIG(0));
        addFormNote(F("ADDR 0x6B & 0x1E"));
      } else {
        success = intArrayContains(2, i2cAddressValues, event->Par1); 
      }
      break;
    }

    case PLUGIN_WEBFORM_LOAD:
    {
      uint8_t choice = PCONFIG(1);
      {
        const __FlashStringHelper * options[1];
        options[0] = F("Movement detection");
        addFormSelector(F("Function"), F("p116_function"), 1, options, NULL, choice); 
      }
      success = true;
      break;
    }

    case PLUGIN_WEBFORM_SAVE:
    {
      // Save the vars
      PCONFIG(0) = getFormItemInt(F("i2c_addr"));
      success = true;
      break;
    }

    case PLUGIN_INIT:
    {

      // Initialize the MPU6050. This *can* be done multiple times per instance and device address.
      uint8_t devAddr = PCONFIG(0);

      //if ((devAddr < 0x6B) || (devAddr > 0x6B)) { //  Just in case the address is not initialized, set it anyway.
      devAddr    = 0x6B;
      PCONFIG(0) = devAddr;
      //}

      initPluginTaskData(event->TaskIndex, new (std::nothrow) P116_data_struct());//(static_cast<uint8_t>(devAddr)));
      P116_data_struct *P116_data = static_cast<P116_data_struct *>(getPluginTaskData(event->TaskIndex));
      if (P116_data != nullptr) {
        success = true;
      }

      // Reset vars
      // Switch is off
      for (unsigned int i = 0; i < 3; i++){
        UserVar[event->BaseVarIndex + i] = 0;

      }
      break;
    }
    case PLUGIN_TEN_PER_SECOND: 
    {
      // Use const pointer here, as we don't want to change data, only read it
      P116_data_struct *P116_data = static_cast<P116_data_struct *>(getPluginTaskData(event->TaskIndex));

      if (P116_data != nullptr) {
        // display acceleration values for movement detection
        P116_data->loop(); 
        Scheduler.schedule_task_device_timer(event->TaskIndex, millis());
        delay(0); // Processing a full sentence may take a while, run some
                  // background tasks.   
       }
      success = true; 
      break;
    }

    case PLUGIN_READ:
    {
      // Use const pointer here, as we don't want to change data, only read it
      const P116_data_struct *P116_data = static_cast<const P116_data_struct *>(getPluginTaskData(event->TaskIndex));

      if (P116_data != nullptr) {
        UserVar[event->BaseVarIndex] = float(P116_data->axis[0]);
        UserVar[event->BaseVarIndex + 1] = float(P116_data->axis[1]);
        UserVar[event->BaseVarIndex + 2] = float(P116_data->axis[2]);
    
        success = true;
       }
      break;
    } 

    /*
    case //PLUGIN_ONCE_A_SECOND:  // FIXME TD-er: Is this fast enough? Earlier comments in the code suggest 10x per sec.
    {
      P116_data_struct *P116_data = static_cast<P116_data_struct *>(getPluginTaskData(event->TaskIndex));     

      if (nullptr != P116_data) {
        P116_data->loop();
        success = true;
      }
      break;
    }
    */
  }
  return success;
}

#endif // USES_P116
