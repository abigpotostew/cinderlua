//
//  Audio.cpp
//  MetatronsGroove
//
//  Created by Stewart Bracken on 9/24/13.
//
//

#include "Audio.h"

#include "CCGLView.h" //console()

#include "cinder/audio/Io.h"
#include "cinder/audio/Output.h"
#include "cinder/audio/FftProcessor.h"
#include "cinder/audio/PcmBuffer.h"
#include "cinder/CinderMath.h"

#include "lua.hpp"
#include "LuaBridge.h"

using namespace luabridge;

Audio::Audio():Audio(32){
    mBandCount=32;
}

Audio::Audio(const string& audioResourcePath):Audio(32){
    this->loadTrackLua(audioResourcePath);
}

Audio::Audio(uint32_t bandCount):mBandCount(bandCount),
 fft_smooth(bandCount,0.f){
}

void Audio::beginMicInput(){
    mIsMicInput=true;
    //TODO
}

void Audio::loadTrackLua(const string& absAudioPath){
    cinder::audio::SourceRef s = audio::load( absAudioPath );
    if( s.get() != NULL){
        mTrack = audio::Output::addTrack( s );
        mTrack->enablePcmBuffering( true );
        mIsMicInput=false;
    }else{
        console()<<
            "Error loading track '"<<absAudioPath<<"'"<<endl;
        exit(EXIT_FAILURE);
    }
}

void Audio::setVolume(float v){
    mTrack->setVolume(v);
}

void Audio::setLoop(bool isLooping){
    mTrack->setLooping(isLooping);
}

float dB(float x){
    if( x ==0 ){
        return 0;
    }else{
        return 10 * log10(x);
    }
}

void Audio::update(){
    if ( mIsMicInput ){
        
    }else{
        mPcmBuffer = mTrack->getPcmBuffer();
        
#if defined(CINDER_MAC)
        if( !mPcmBuffer )return;

        std::shared_ptr<float> fftRef = audio::calculateFft( mPcmBuffer->getChannelData( audio::CHANNEL_FRONT_LEFT ), mBandCount );
        
        if( ! fftRef ) {
            return;
        }
        float* tmpBuffer = fftRef.get();
        
        for(int i=0; i<mBandCount;++i){
            float fft_curr = (use_decibels)? dB(tmpBuffer[i]) : tmpBuffer[i];
            fft_smooth[i] = (smoothing) * fft_smooth[i] + ((1 - smoothing) * fft_curr);
            
            //calc max fft spectrum val
            if (fft_smooth[i] > max_val) {
                max_val = fft_smooth[i];
            }
            if (fft_smooth[i] < min_val) {
                min_val = fft_smooth[i];
            }
        }
        
        float scale_factor = max_val - min_val + 0.00001f; //prevent div by 0
        for( int i = 0; i < mBandCount; ++i){
            float scaled_fft = ((fft_smooth[i] - min_val) / scale_factor);
            scaled_fft = max(0.0f, scaled_fft);
            fft_smooth[i] = scaled_fft;
        }
        (void)tmpBuffer[0];
    }
#endif
}

vector<float> Audio::getSpectrum()const{
    return fft_smooth;
}

int Audio::getSpectrumLua(lua_State* L){
    LuaRef t = newTable(L);
    for( int i=0; i<fft_smooth.size(); ++i ){
        t.append( fft_smooth[i] ); //array style table
    }
    t.push(L);
    return 1;
}

