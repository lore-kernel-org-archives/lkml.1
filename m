Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbYA1LVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbYA1LVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYA1LUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:20:53 -0500
Received: from www.tglx.de ([62.245.132.106]:40317 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYA1LUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:20:52 -0500
Date: Mon, 28 Jan 2008 12:20:34 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: ManojKwal <kmanojcse23@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel is not booting.............
Message-ID: <20080128122034.73bc9fdb@dilbert.local>
In-Reply-To: <15132032.post@talk.nabble.com>
References: <15132032.post@talk.nabble.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mon, 28 Jan 2008 02:13:09 -0800 (PST)
schrieb ManojKwal <kmanojcse23@gmail.com>:

> 
> Greetings! 
> 
> System details: 
> Board: DTSP-ARM926Ej-S(new board) 
> Cross-toolchain: ELDK4.1 
> Linux kernel: 2.6.18 
> u-boot: 1.1.6 
> 
> 
> I sucessfully port u-boot on board...........But when i boot the
> kernel it stuck in mid.........The complete log is following:
> 
> 
> 
> 
> DRM-Engine # bootm 0x80000
> ## Booting image at 00080000 ...
>    Image Name:   Linux-2.6.18-DRM
>    Image Type:   ARM Linux Kernel Image (uncompressed)
>    Data Size:    623896 Bytes = 609.3 kB
>    Load Address: 0b008000
>    Entry Point:  0b008000
>    Verifying Checksum ... OK
> OK
> No initrd
> ## Transferring control to Linux (at address 0b008000) ...
> 
> Starting kernel ...
> 
> Uncompressing Linux........................................... done,
> booting the kernel.
>                                                                                        
> Linux version 2.6.18-DRM (khandelwal@HotelTV-Server) (gcc version
> 4.0.0 (DENX ELDK 4.1 4.0.0)) #34 Mon Jan 28 17:35:46 KST 2008
> CPU: ARM926EJ-S [41069263] revision 3 (ARMv5TEJ), cr=00053177
> Machine: DTSP
> Memory policy: ECC disabled, Data cache writeback
> CPU0: D VIVT write-back cache
> CPU0: I cache: 32768 bytes, associativity 4, 32 byte lines, 256 sets
> CPU0: D cache: 32768 bytes, associativity 4, 32 byte lines, 256 sets
> Built 1 zonelists.  Total pages: 16128
> Kernel command line: root=/dev/ram0 mem=63M initrd=0xd000000,6M
> ramdisk=16384 console=ttyS0,38400 init=/linuxrc
> PID hash table entries: 256 (order: 8, 1024 bytes)
> Console: colour dummy device 80x30
> [cskim]:serial_dtsp_set_termios
> [cskim] : [baud,quot] = 38400, 26
> Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
> Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
> Memory: 63MB = 63MB total
> Memory: 56448KB available (980K code, 248K data, 68K
> init)-------------------------->"HERE KERNEL STUCK"
> 
> 
> 
> 
> Can anybody help me? I am a beginer on this type of work

In general, you should post questions concerning ARM systems on
the linux-arm-kernel mailing list. See http://www.arm.linux.org.uk/ for
details.

And, as a hint, you should use a more descriptive subject for your
mail ;-)

Hans


> 
> 
> 
> Thanks in advance!
> 
> Regards
> Manoj Khandelwal
> Software Engineer
> 
