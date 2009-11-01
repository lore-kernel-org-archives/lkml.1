Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZKAQLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZKAQLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 11:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZKAQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 11:11:41 -0500
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:37000 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbZKAQLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 11:11:41 -0500
Message-ID: <4AEDB33F.6060205@blueyonder.co.uk>
Date: Sun, 01 Nov 2009 16:11:43 +0000
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4 ThunderBrowse/3.2.6.5
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32-rc5 omap build error
References: <4AE7BA65.6070502@blueyonder.co.uk> <94a0d4530911010353n38d0627ev69bf891005365e9@mail.gmail.com>
In-Reply-To: <94a0d4530911010353n38d0627ev69bf891005365e9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/09 11:53, Felipe Contreras wrote:
> On Wed, Oct 28, 2009 at 5:28 AM, Sid Boyce <g3vbv@blueyonder.co.uk> wrote:
>> [root@localhost linux-omap-2.6]# ARCH=arm make
>> CROSS_COMPILE=/opt/arm-2009q1/bin/arm-none-linux-gnueabi- uImage modules
>> Â CHK Â  Â  include/linux/version.h
>> make[1]: `include/asm-arm/mach-types.h' is up to date.
>> Â CHK Â  Â  include/linux/utsrelease.h
>> Â SYMLINK include/asm -> include/asm-arm
>> Â CALL Â  Â scripts/checksyscalls.sh
>> Â CHK Â  Â  include/linux/compile.h
>> Â CHK Â  Â  include/linux/version.h
>> make[2]: `scripts/unifdef' is up to date.
>> Â Kernel: arch/arm/boot/Image is ready
>> Â Kernel: arch/arm/boot/zImage is ready
>> Â UIMAGE Â arch/arm/boot/uImage
>> Image Name: Â  Linux-2.6.32-rc5-06331-g0bbf533-
>> Created: Â  Â  Â Wed Oct 28 01:57:13 2009
>> Image Type: Â  ARM Linux Kernel Image (uncompressed)
>> Data Size: Â  Â 2236872 Bytes = 2184.45 kB = 2.13 MB
>> Load Address: 0x80008000
>> Entry Point: Â 0x80008000
>> Â Image arch/arm/boot/uImage is ready
>> Â Building modules, stage 2.
>> Â MODPOST 355 modules
>> ERROR: "omap_ctrl_writel" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
>> ERROR: "omap_ctrl_readl" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>> make: *** [modules] Error 2
> 
> Why don't you send this to the linux-omap mailing list?
> 

I realised that after I sent this out and I have had responses from
linux-omap.
Apologies & Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

