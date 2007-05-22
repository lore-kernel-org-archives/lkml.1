Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXEVGVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXEVGVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 02:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762139AbXEVGVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 02:21:20 -0400
Received: from ms.trustica.cz ([82.208.32.68]:44542 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762086AbXEVGVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 02:21:18 -0400
Message-ID: <46528B6F.3050701@assembler.cz>
Date: Tue, 22 May 2007 08:19:27 +0200
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070520)
MIME-Version: 1.0
To: Luca <kronos.it@gmail.com>
CC: lm-sensors@lm-sensors.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [RFC] ACPI based hwmon driver for ASUS
References: <20070513223329.GA29207@dreamland.darkstar.lan>	 <46520F36.4080006@assembler.cz> <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com>
In-Reply-To: <68676e00705211453n69de6868lc5da2cad64f65699@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have following readings:

w83627ehf-isa-0290
Adapter: ISA adapter
VCore:     +1.52 V  (min =  +0.00 V, max =  +1.74 V)
in1:      +12.30 V  (min = +13.46 V, max = +13.04 V) ALARM
AVCC:      +3.36 V  (min =  +4.08 V, max =  +3.95 V) ALARM
3VCC:      +3.36 V  (min =  +4.05 V, max =  +3.06 V) ALARM
in4:       +2.04 V  (min =  +1.78 V, max =  +2.04 V)
in5:       +1.60 V  (min =  +2.04 V, max =  +2.02 V) ALARM
in6:       +5.12 V  (min =  +6.12 V, max =  +6.53 V) ALARM
VSB:       +3.36 V  (min =  +4.08 V, max =  +4.08 V) ALARM
VBAT:      +3.30 V  (min =  +4.08 V, max =  +3.04 V) ALARM
in9:       +1.65 V  (min =  +0.98 V, max =  +2.04 V)
Case Fan:    0 RPM  (min =    0 RPM, div = 8)
CPU Fan:  1638 RPM  (min =    0 RPM, div = 4)
Aux Fan:  1436 RPM  (min = 4272 RPM, div = 4) ALARM
fan5:        0 RPM  (min =    0 RPM, div = 16)
Sys Temp:    +28°C  (high =   -65°C, hyst =   -34°C)   ALARM
CPU Temp:  +34.0°C  (high = +80.0°C, hyst = +75.0°C)
AUX Temp:  +38.5°C  (high = +80.0°C, hyst = +75.0°C)

Fan4 is disabled in the chip. I think the board has 4 connectors. I dont have 
time right now to check the manual.

Rudolf

