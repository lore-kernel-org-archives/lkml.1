Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZAaOwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZAaOwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZAaOwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:52:03 -0500
Received: from eastrmmtao102.cox.net ([68.230.240.8]:45528 "EHLO
	eastrmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbZAaOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:51:59 -0500
X-Greylist: delayed 2123 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 Jan 2009 09:51:59 EST
X-Authority-Analysis: v=1.0 c=1 a=jdKykyfqUfYA:10 a=-5BRaeWoJ5gA:10
 a=zt0Ag_wKyes1Sr-ePQcA:9 a=RdjFXp_EYafn40Ohh40A:7
 a=0Y2BYk2CzSzuNyPwCpXt5nTVR3MA:4 a=oH_WKSxD8ioA:10
X-CM-Score: 0.00
Message-ID: <4983B499.7070507@cox.net>
Date: Fri, 30 Jan 2009 20:16:57 -0600
From: Benny Acosta <bacosta5@cox.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Spontaneous Shutdown/Reboot on AMD x86_64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My computer spontaneously reboots or just shuts down for some reason. 
I've looked on the internet and have found some posts on the subject but 
it's way beyond my ability to understand. I tried to compile a new 
kernel to see if this would solve the issue but my system reboots every 
time. I can't finish the compile process. I can't play any graphically 
intensive games or the system will reboot. And if the computer is on for 
more than a week or so it will also just shut down. I had a bad hard 
drive and ended up having to re-install slackware on a new drive. So I 
took the opportunity to upgrade to the AMD Dual core. That's when all 
this started. Below is my system information. I would really appreciate 
any help you can render. These reboots will eventually destroy my hard 
drive if I can't get this fixed.

Respectfully
Benny Acosta
Wichita KS

uname -a
Linux shaolin 2.6.27.7-smp #2 SMP Thu Nov 20 22:32:43 CST 2008 i686 AMD 
Athlon(tm) 64 X2 Dual Core Processor 5000+ AuthenticAMD GNU/Linux

cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 5000+
stepping        : 2
cpu MHz         : 2599.942
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm 
extapic cr8_legacy 3dnowprefetch
bogomips        : 5199.88
clflush size    : 64
power management: ts fid vid ttp tm stc 100mhzsteps

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 5000+
stepping        : 2
cpu MHz         : 2599.942
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm 
extapic cr8_legacy 3dnowprefetch
bogomips        : 5200.34
clflush size    : 64
power management: ts fid vid ttp tm stc 100mhzsteps

lspci
00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
00:01.2 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
00:06.1 Audio device: nVidia Corporation MCP55 High Definition Audio 
(rev a2)
00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:0a.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0c.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0d.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:08.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A 
IEEE-1394a-2000 Controller (PHY/Link)
01:09.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 0a)
01:09.1 Input device controller: Creative Labs SB Live! Game Port (rev 0a)
06:00.0 VGA compatible controller: nVidia Corporation G73GL [Quadro FX 
560] (rev a1)


