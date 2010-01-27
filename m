Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068Ab0A0OI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0A0OI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009Ab0A0OI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:08:57 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:41780 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab0A0OI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=dJ9aVxmOm/32GCmHtHgIDK4GoL74/lUSNyLsbBdXsIZMMsjzNq/2POUynyoqJ94Jlq
         n2fgXZVr8HfvvJf8HVPdrJ175KWzqnZvQfLGADOmDbSz/sCtEeit3l4gW2nVuoSnOlUl
         8Df3U/YDXcdUn/vxpAjXB5WJetJ3wTs4Q3p/8=
MIME-Version: 1.0
Date: Wed, 27 Jan 2010 19:38:54 +0530
Message-ID: <b713df2c1001270608m5124d790j2f580cfad0bc631b@mail.gmail.com>
Subject: Creative Ensoniq AudioPCI ENS1371 Can't Listen Sound or Capture Sound 
	bug.
From: Siju George <sgeorge.ml@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This Card is recognized by the Kernel but remains useless since no
sound is got through the speakers. No sound is captured through the
Mic too.

Here are the details

Thanks

--Siju

upload=true&script=true&cardinfo=
!!################################
!!ALSA Information Script v 0.4.58
!!################################

!!Script ran on: Wed Jan 27 05:12:07 UTC 2010


!!Linux Distribution
!!------------------

Ubuntu 9.10 \n \l DISTRIB_ID=Ubuntu DISTRIB_DESCRIPTION="Ubuntu 9.10"


!!DMI Information
!!---------------

Manufacturer:      System manufacturer
Product Name:      System Product Name


!!Kernel Information
!!------------------

Kernel release:    2.6.31-17-generic
Operating System:  GNU/Linux
Architecture:      i686
Processor:         unknown
SMP Enabled:       Yes


!!ALSA Version
!!------------

Driver version:     1.0.20
Library version:    1.0.20
Utilities version:  1.0.20


!!Loaded ALSA modules
!!-------------------

snd_ens1371


!!Sound Servers on this system
!!----------------------------

Pulseaudio:
      Installed - Yes (/usr/bin/pulseaudio)
      Running - Yes

ESound Daemon:
      Installed - Yes (/usr/bin/esd)
      Running - No


!!Soundcards recognised by ALSA
!!-----------------------------

 0 [AudioPCI       ]: ENS1371 - Ensoniq AudioPCI
                      Ensoniq AudioPCI ENS1371 at 0xe800, irq 16


!!PCI Soundcards installed in the system
!!--------------------------------------

05:08.0 Multimedia audio controller: Creative Labs Ectiva EV1938


!!Advanced information - PCI Vendor/Device/Susbsystem ID's
!!--------------------------------------------------------

05:08.0 0401: 1102:8938
        Subsystem: 1102:5938


!!Modprobe options (Sound related)
!!--------------------------------

snd-atiixp-modem: index=-2
snd-intel8x0m: index=-2
snd-via82xx-modem: index=-2
snd-usb-audio: index=-2
snd-usb-us122l: index=-2
snd-usb-usx2y: index=-2
snd-usb-caiaq: index=-2
snd-cmipci: mpu_port=0x330 fm_port=0x388
snd-pcsp: index=-2
snd-hda-intel: power_save=10 power_save_controller=N


!!Loaded sound module options
!!--------------------------

!!Module: snd_ens1371
        enable : Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y,Y
        id : <NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
        index :
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
        joystick_port :
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        lineio : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        spdif : 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

!!AC97 Codec information
!!---------------------------
--startcollapse--

0-0/0: 0x76058384 FÕS

PCI Subsys Vendor: 0x1102
PCI Subsys Device: 0x5938

Flags: 0
Capabilities     : -dedicated MIC PCM IN channel- -bass & treble-
DAC resolution   : 16-bit
ADC resolution   : 20-bit
3D enhancement   : Reserved 29

Current setup
Mic gain         : +0dB [+0dB]
POP path         : post 3D
Sim. stereo      : off
3D enhancement   : off
Loudness         : on
Mono output      : Mic
Mic select       : Mic2
ADC/DAC loopback : off

0:00 = 0000
0:02 = 0140
0:04 = 9f1f
0:06 = 8000
0:08 = 801f
0:0a = 9f1f
0:0c = 801e
0:0e = 801f
0:10 = 801f
0:12 = 9f1f
0:14 = 8606
0:16 = 9f1f
0:18 = 9f1f
0:1a = 9e1e
0:1c = 0000
0:1e = 0000
0:20 = 0000
0:22 = 0000
0:24 = 0000
0:26 = 0000
0:28 = 000f
0:2a = ffff
0:2c = ffff
0:2e = ffff
0:30 = ffff
0:32 = ffff
0:34 = ffff
0:36 = ffff
0:38 = ffff
0:3a = ffff

0:3c = ffff
0:3e = ffff
0:40 = ffff
0:42 = ffff
0:44 = ffff
0:46 = ffff
0:48 = ffff
0:4a = ffff
0:4c = ffff
0:4e = ffff
0:50 = ffff
0:52 = ffff
0:54 = ffff
0:56 = ffff
0:58 = ffff
0:5a = ffff
0:5c = 0000
0:5e = 0000
0:60 = 0000
0:62 = 0000
0:64 = 0000
0:66 = 0000
0:68 = 0000
0:6a = 0000
0:6c = 0000
0:6e = 0000
0:70 = 0000
0:72 = 0000
0:74 = ffff
0:76 = ffff
0:78 = ffff
0:7a = ffff
0:7c = ffff
0:7e = 8384
--endcollapse--
!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116, 8 Jan 27 10:39 /dev/snd/controlC0
crw-rw----+ 1 root audio 116, 4 Jan 27 10:39 /dev/snd/midiC0D0
crw-rw----+ 1 root audio 116, 7 Jan 27 10:40 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116, 6 Jan 27 10:40 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116, 5 Jan 27 10:39 /dev/snd/pcmC0D1p
crw-rw----+ 1 root audio 116, 3 Jan 27 10:39 /dev/snd/seq
crw-rw----+ 1 root audio 116, 2 Jan 27 10:39 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jan 27 10:39 .
drwxr-xr-x 3 root root 200 Jan 27 10:39 ..
lrwxrwxrwx 1 root root  12 Jan 27 10:39 pci-0000:05:08.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: AudioPCI [Ensoniq AudioPCI], device 0: ES1371/1 [ES1371 DAC2/ADC]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: AudioPCI [Ensoniq AudioPCI], device 1: ES1371/2 [ES1371 DAC1]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: AudioPCI [Ensoniq AudioPCI], device 0: ES1371/1 [ES1371 DAC2/ADC]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [AudioPCI]

Card hw:0 'AudioPCI'/'Ensoniq AudioPCI ENS1371 at 0xe800, irq 16'
  Mixer name    : '0x76058384 FÕS'
  Components    : 'AC97a:76058384'
  Controls      : 23
  Simple ctrls  : 18
Simple mixer control 'Master',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-46.50dB]
  Front Right: Playback 0 [0%] [-46.50dB]
Simple mixer control 'Master Mono',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-46.50dB]
  Front Right: Playback 0 [0%] [-46.50dB]
Simple mixer control 'Bass',0
  Capabilities: volume volume-joined
  Playback channels: Mono
  Capture channels: Mono
  Limits: 0 - 15
  Mono: 0 [0%]
Simple mixer control 'Treble',0
  Capabilities: volume volume-joined
  Playback channels: Mono
  Capture channels: Mono
  Limits: 0 - 15
  Mono: 0 [0%]
Simple mixer control 'PCM',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 63
  Mono:
  Front Left: Playback 1 [2%] [-33.00dB]
  Front Right: Playback 1 [2%] [-33.00dB]
Simple mixer control 'Center',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 31
  Mono: Playback 9 [29%] [-33.00dB] [off]
Simple mixer control 'LFE',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 31
  Mono: Playback 9 [29%] [-33.00dB] [off]
Simple mixer control 'Line',0
  Capabilities: pvolume pswitch pswitch-joined cswitch cswitch-exclusive
 Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 63
  Front Left: Playback 0 [0%] [-34.50dB] [off] Capture [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off] Capture [off]
Simple mixer control 'CD',0
  Capabilities: pvolume cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Front Left: Playback 25 [81%] [3.00dB] Capture [off]
  Front Right: Playback 25 [81%] [3.00dB] Capture [off]
Simple mixer control 'Mic',0
  Capabilities: pvolume cvolume cvolume-joined cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 63 Capture 0 - 15
  Front Left: Playback 0 [0%] [-34.50dB] Capture 0 [0%] [0.00dB] [on]
  Front Right: Playback 0 [0%] [-34.50dB] Capture 0 [0%] [0.00dB] [on]
Simple mixer control 'Mic Boost (+20dB)',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'Video',0
  Capabilities: pvolume cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 63
  Front Left: Playback 0 [0%] [-34.50dB] Capture [off]
  Front Right: Playback 0 [0%] [-34.50dB] Capture [off]
Simple mixer control 'Phone',0
  Capabilities: pvolume pvolume-joined cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Mono
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono: Playback 0 [0%] [-34.50dB]
  Front Left: Capture [off]
  Front Right: Capture [off]
Simple mixer control 'PC Speaker',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 15
  Mono: Playback 0 [0%] [-45.00dB] [off]
Simple mixer control 'Aux',0
  Capabilities: pvolume cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 63
  Front Left: Playback 0 [0%] [-34.50dB] Capture [off]
  Front Right: Playback 0 [0%] [-34.50dB] Capture [off]
Simple mixer control 'Capture',0
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 15
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]
Simple mixer control 'Mix',0
  Capabilities: cswitch cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Front Left - Front Right
  Front Left: Capture [off]
  Front Right: Capture [off]
Simple mixer control 'Mix Mono',0
  Capabilities: cswitch cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Front Left - Front Right
  Front Left: Capture [off]
  Front Right: Capture [off]


!!Alsactl output
!!-------------

--startcollapse--
state.AudioPCI {
        control.1 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 31'
                comment.dbmin -4650
                comment.dbmax 0
                iface MIXER
                name 'Master Playback Volume'
                value.0 0
                value.1 0
        }
        control.2 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                comment.range '0 - 31'
                comment.dbmin -4650
                comment.dbmax 0
                iface MIXER
                name 'Center Playback Volume'
                value 9
        }
        control.4 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'LFE Playback Switch'
                value false
        }
        control.5 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 31'
                comment.dbmin -4650
                comment.dbmax 0
                iface MIXER
                name 'LFE Playback Volume'
                value 9
        }
        control.6 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 31'
                comment.dbmin -4650
                comment.dbmax 0
                iface MIXER
                name 'Master Mono Playback Volume'
                value.0 0
                value.1 0
        }
        control.7 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 15'
                iface MIXER
                name 'Tone Control - Bass'
                value 0
        }
        control.8 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 15'
                iface MIXER
                name 'Tone Control - Treble'
                value 0
        }
        control.9 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'PC Speaker Playback Switch'
                value false
        }
        control.10 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 15'
                comment.dbmin -4500
                comment.dbmax 0
                iface MIXER
                name 'PC Speaker Playback Volume'
                value 0
        }
        control.11 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 31'
                comment.dbmin -3450
                comment.dbmax 1200
                iface MIXER
                name 'Phone Playback Volume'
                value 0
        }
        control.12 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'Mic Playback Volume'
                value.0 0
                value.1 0
        }
        control.13 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'Mic Boost (+20dB)'
                value false
        }
        control.14 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'Line Playback Switch'
                value false
        }
        control.15 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'Line Playback Volume'
                value.0 0
                value.1 0
        }
        control.16 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 31'
                comment.dbmin -3450
                comment.dbmax 1200
                iface MIXER
                name 'CD Playback Volume'
                value.0 25
                value.1 25
        }
        control.17 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'Video Playback Volume'
                value.0 0
                value.1 0
        }
        control.18 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'Aux Playback Volume'
                value.0 0
                value.1 0
        }
        control.19 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'PCM Playback Volume'
                value.0 1
                value.1 1
        }
        control.20 {
                comment.access 'read write'
                comment.type ENUMERATED
                comment.count 2
                comment.item.0 Mic
                comment.item.1 CD
                comment.item.2 Video
                comment.item.3 Aux
                comment.item.4 Line
                comment.item.5 Mix
                comment.item.6 'Mix Mono'
                comment.item.7 Phone
                iface MIXER
                name 'Capture Source'
                value.0 Mic
                value.1 Mic
        }
        control.21 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 15'
                comment.dbmin 0
                comment.dbmax 2250
                iface MIXER
                name 'Capture Volume'
                value.0 0
                value.1 0
        }
        control.22 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'Mic Capture Switch'
                value true
        }
        control.23 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 15'
                comment.dbmin 0
                comment.dbmax 2250
                iface MIXER
                name 'Mic Capture Volume'
                value 0
        }
}
--endcollapse--


!!All Loaded Modules
!!------------------

Module
xt_TCPMSS
xt_tcpmss
xt_tcpudp
iptable_mangle
via
drm
pppoe
pppox
binfmt_misc
snd_ens1371
gameport
snd_ac97_codec
ac97_bus
snd_pcm_oss
snd_mixer_oss
snd_pcm
snd_seq_dummy
ppdev
iptable_filter
snd_seq_oss
snd_seq_midi
ip_tables
x_tables
psmouse
serio_raw
parport_pc
asus_atk0110
snd_rawmidi
snd_seq_midi_event
snd_seq
snd_timer
snd_seq_device
snd
soundcore
snd_page_alloc
k8temp
shpchp
i2c_viapro
lp
parport
via_rhine
mii
floppy
amd64_agp
agpgart


!!ALSA/HDA dmesg
!!------------------



!!ALSA Device nodes
!!-----------------

crw-rw----+ 1 root audio 116, 8 Jan 27 10:39 /dev/snd/controlC0
crw-rw----+ 1 root audio 116, 4 Jan 27 10:39 /dev/snd/midiC0D0
crw-rw----+ 1 root audio 116, 7 Jan 27 10:40 /dev/snd/pcmC0D0c
crw-rw----+ 1 root audio 116, 6 Jan 27 10:40 /dev/snd/pcmC0D0p
crw-rw----+ 1 root audio 116, 5 Jan 27 10:39 /dev/snd/pcmC0D1p
crw-rw----+ 1 root audio 116, 3 Jan 27 10:39 /dev/snd/seq
crw-rw----+ 1 root audio 116, 2 Jan 27 10:39 /dev/snd/timer

/dev/snd/by-path:
total 0
drwxr-xr-x 2 root root  60 Jan 27 10:39 .
drwxr-xr-x 3 root root 200 Jan 27 10:39 ..
lrwxrwxrwx 1 root root  12 Jan 27 10:39 pci-0000:05:08.0 -> ../controlC0


!!Aplay/Arecord output
!!------------

APLAY

**** List of PLAYBACK Hardware Devices ****
card 0: AudioPCI [Ensoniq AudioPCI], device 0: ES1371/1 [ES1371 DAC2/ADC]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: AudioPCI [Ensoniq AudioPCI], device 1: ES1371/2 [ES1371 DAC1]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

ARECORD

**** List of CAPTURE Hardware Devices ****
card 0: AudioPCI [Ensoniq AudioPCI], device 0: ES1371/1 [ES1371 DAC2/ADC]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

!!Amixer output
!!-------------

!!-------Mixer controls for card 0 [AudioPCI]

Card hw:0 'AudioPCI'/'Ensoniq AudioPCI ENS1371 at 0xe800, irq 16'
  Mixer name    : '0x76058384 FÕS'
  Components    : 'AC97a:76058384'
  Controls      : 23
  Simple ctrls  : 18
Simple mixer control 'Master',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono:
  Front Left: Playback 0 [0%] [-46.50dB]
  Front Right: Playback 0 [0%] [-46.50dB]
Simple mixer control 'Master Mono',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 31
1
  Mono:
  Front Left: Playback 0 [0%] [-46.50dB]
  Front Right: Playback 0 [0%] [-46.50dB]
Simple mixer control 'Bass',0
  Capabilities: volume volume-joined
  Playback channels: Mono
  Capture channels: Mono
  Limits: 0 - 15
  Mono: 0 [0%]
Simple mixer control 'Treble',0
  Capabilities: volume volume-joined
  Playback channels: Mono
  Capture channels: Mono
  Limits: 0 - 15
  Mono: 0 [0%]
Simple mixer control 'PCM',0
  Capabilities: pvolume
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 63
  Mono:
  Front Left: Playback 1 [2%] [-33.00dB]
  Front Right: Playback 1 [2%] [-33.00dB]
Simple mixer control 'Center',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 31
  Mono: Playback 9 [29%] [-33.00dB] [off]
Simple mixer control 'LFE',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 31
  Mono: Playback 9 [29%] [-33.00dB] [off]
Simple mixer control 'Line',0
  Capabilities: pvolume pswitch pswitch-joined cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 63
  Front Left: Playback 0 [0%] [-34.50dB] [off] Capture [off]
  Front Right: Playback 0 [0%] [-34.50dB] [off] Capture [off]
Simple mixer control 'CD',0
  Capabilities: pvolume cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Front Left: Playback 25 [81%] [3.00dB] Capture [off]
  Front Right: Playback 25 [81%] [3.00dB] Capture [off]
Simple mixer control 'Mic',0
  Capabilities: pvolume cvolume cvolume-joined cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right

  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 63 Capture 0 - 15
  Front Left: Playback 0 [0%] [-34.50dB] Capture 0 [0%] [0.00dB] [on]
  Front Right: Playback 0 [0%] [-34.50dB] Capture 0 [0%] [0.00dB] [on]
Simple mixer control 'Mic Boost (+20dB)',0
  Capabilities: pswitch pswitch-joined
  Playback channels: Mono
  Mono: Playback [off]
Simple mixer control 'Video',0
  Capabilities: pvolume cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 63
  Front Left: Playback 0 [0%] [-34.50dB] Capture [off]
  Front Right: Playback 0 [0%] [-34.50dB] Capture [off]
Simple mixer control 'Phone',0
  Capabilities: pvolume pvolume-joined cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Mono
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 31
  Mono: Playback 0 [0%] [-34.50dB]
  Front Left: Capture [off]
  Front Right: Capture [off]
Simple mixer control 'PC Speaker',0
  Capabilities: pvolume pvolume-joined pswitch pswitch-joined
  Playback channels: Mono
  Limits: Playback 0 - 15
  Mono: Playback 0 [0%] [-45.00dB] [off]
Simple mixer control 'Aux',0
  Capabilities: pvolume cswitch cswitch-exclusive
  Capture exclusive group: 0
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: Playback 0 - 63
  Front Left: Playback 0 [0%] [-34.50dB] Capture [off]
  Front Right: Playback 0 [0%] [-34.50dB] Capture [off]
Simple mixer control 'Capture',0
  Capabilities: cvolume
  Capture channels: Front Left - Front Right
  Limits: Capture 0 - 15
  Front Left: Capture 0 [0%] [0.00dB]
  Front Right: Capture 0 [0%] [0.00dB]
Simple mixer control 'Mix',0
  Capabilities: cswitch cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Front Left - Front Right
  Front Left: Capture [off]
  Front Right: Capture [off]
Simple mixer control 'Mix Mono',0
  Capabilities: cswitch cswitch-exclusive
  Capture exclusive group: 0
  Capture channels: Front Left - Front Right
  Front Left: Capture [off]
  Front Right: Capture [off]


!!Alsactl output
!!-------------

--startcollapse--
state.AudioPCI {
        control.1 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 31'
                comment.dbmin -4650
                comment.dbmax 0
                iface MIXER
                name 'Master Playback Volume'
                value.0 0
                value.1 0
        }
        control.2 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'Center Playback Switch'
                value false
        }
        control.3 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 31'
                comment.dbmin -4650
                comment.dbmax 0
                iface MIXER
                name 'Center Playback Volume'
                value 9
        }
        control.4 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'LFE Playback Switch'
                value false
        }
        control.5 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 31'
                comment.dbmin -4650
                comment.dbmax 0
                iface MIXER
                name 'LFE Playback Volume'
                value 9
        }
        control.6 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 31'
                comment.dbmin -4650
                comment.dbmax 0
                iface MIXER
                name 'Master Mono Playback Volume'
                value.0 0
                value.1 0
        }
        control.7 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 15'
                iface MIXER
                name 'Tone Control - Bass'
                value 0
        }
        control.8 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 15'
                iface MIXER
                name 'Tone Control - Treble'
                value 0
        }
        control.9 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'PC Speaker Playback Switch'
                value false
        }
        control.10 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 15'
                comment.dbmin -4500
                comment.dbmax 0
                iface MIXER
                name 'PC Speaker Playback Volume'
                value 0
        }
        control.11 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 31'
                comment.dbmin -3450
                comment.dbmax 1200
                iface MIXER
                name 'Phone Playback Volume'
                value 0
        }
        control.12 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'Mic Playback Volume'
                value.0 0
                value.1 0
        }
        control.13 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'Mic Boost (+20dB)'
                value false
        }
        control.14 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'Line Playback Switch'
                value false
        }
        control.15 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'Line Playback Volume'
                value.0 0
                value.1 0
        }
        control.16 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 31'
                comment.dbmin -3450
                comment.dbmax 1200
                iface MIXER
                name 'CD Playback Volume'
                value.0 25
                value.1 25
        }
        control.17 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'Video Playback Volume'
                value.0 0
                value.1 0
        }
        control.18 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'Aux Playback Volume'
                value.0 0
                value.1 0
        }
        control.19 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 63'
                comment.dbmin -3450
                comment.dbmax 6000
                iface MIXER
                name 'PCM Playback Volume'
                value.0 1
                value.1 1
        }
        control.20 {
                comment.access 'read write'
                comment.type ENUMERATED

                comment.count 2
                comment.item.0 Mic
                comment.item.1 CD
                comment.item.2 Video
                comment.item.3 Aux
                comment.item.4 Line
                comment.item.5 Mix
                comment.item.6 'Mix Mono'
                comment.item.7 Phone
                iface MIXER
                name 'Capture Source'
                value.0 Mic
                value.1 Mic
        }
        control.21 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 2
                comment.range '0 - 15'
                comment.dbmin 0
                comment.dbmax 2250
                iface MIXER
                name 'Capture Volume'
                value.0 0
                value.1 0
        }
        control.22 {
                comment.access 'read write'
                comment.type BOOLEAN
                comment.count 1
                iface MIXER
                name 'Mic Capture Switch'
                value true
        }
        control.23 {
                comment.access 'read write'
                comment.type INTEGER
                comment.count 1
                comment.range '0 - 15'
                comment.dbmin 0
                comment.dbmax 2250
                iface MIXER
                name 'Mic Capture Volume'
                value 0
        }
}
--endcollapse--

!!All Loaded Modules
!!------------------

Module
xt_TCPMSS
xt_tcpmss
xt_tcpudp
iptable_mangle
via
drm
pppoe
pppox
binfmt_misc
snd_ens1371
gameport
snd_ac97_codec
ac97_bus
snd_pcm_oss
snd_mixer_oss
snd_pcm
snd_seq_dummy
ppdev
iptable_filter
snd_seq_oss
snd_seq_midi
ip_tables
x_tables
psmouse
serio_raw
parport_pc
asus_atk0110
snd_rawmidi
snd_seq_midi_event
snd_seq
snd_timer
snd_seq_device
snd
soundcore
snd_page_alloc
k8temp
shpchp
i2c_viapro
lp
parport
via_rhine
mii
floppy
amd64_agp
agpgart
