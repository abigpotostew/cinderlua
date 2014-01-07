//
//  Audio.h
//  MetatronsGroove
//
//  Created by Stewart Bracken on 9/24/13.
//
//

#ifndef __MetatronsGroove__Audio__
#define __MetatronsGroove__Audio__

#include "cinder/audio/FftProcessor.h"
#include "cinder/audio/PcmBuffer.h"
#include "cinder/audio/Io.h"
#include "cinder/audio/Output.h"
#include <vector>

using namespace ci;
using namespace std;

//frequency set definitions
#define LOWS 200
#define LOW_MIDS 500
#define MIDS 1400
#define HIGH_MIDS 2500
#define HIGHS 4000
#define ULTRA_HIGHS 20000
#define MAX_FREQ 22050


//#define SMOOTHNESS 2 //higher=smoother/LESS responsive

#include "lua.hpp"

class Audio {
private:
    uint16_t mBandCount;
    bool mIsMicInput = true;
    //For track input & analysation:
    audio::TrackRef mTrack;
	audio::PcmBuffer32fRef mPcmBuffer;
    vector<float> fft_smooth;
    float max_val = 0.f,
          min_val = 0.f;
    float smoothing = 0.0f;
    bool use_decibels = false;
    //For mic input:
    
public:
    Audio();
    Audio(uint32_t bandCount);//not accessible to lua
    Audio(const string&); //construct & begin playing track
    
    void beginMicInput(); //todo
    void update();
    vector<float> getSpectrum()const;
    
    uint32_t getBandCount()const{ return mBandCount; }
    void setVolume( float );
    int getSpectrumLua(lua_State*);
    void setLoop(bool);//lua
    void loadTrackLua(const string&);
    float getSmoothing()const{ return smoothing; };
    void setSmoothing( float smooth_val ){ smoothing = smooth_val; }
    void set_dB( bool _use_decibels ){ use_decibels = _use_decibels; }
};

#endif /* defined(__MetatronsGroove__Audio__) */
