Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbXKVHf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbXKVHf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 02:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXKVHfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 02:35:51 -0500
Received: from mga06.intel.com ([134.134.136.21]:55501 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751353AbXKVHfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 02:35:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,450,1188802800"; 
   d="scan'208";a="235369014"
Message-ID: <3658.172.16.183.182.1195716874.squirrel@linux.intel.com>
Date: Wed, 21 Nov 2007 23:34:34 -0800 (PST)
Subject: In /proc/cpuinfo, all processor items show "0"  
From: youquan_song@linux.intel.com
To: linux-kernel@vger.kernel.org
Cc: youquan.song@intel.com
User-Agent: SquirrelMail/1.4.8-4.0.1.el4.centos
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Build kernel 2.6.24-rc3,   cat /proc/cpuinfo,  all processor items show "0":

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 7465.18
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 2
siblings	: 4
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.81
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 3
siblings	: 4
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.80
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 1
siblings	: 4
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.79
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 2
siblings	: 4
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.80
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 3
siblings	: 4
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.80
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.74
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 1
siblings	: 4
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.81
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 2
siblings	: 4
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.81
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 3
siblings	: 4
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.81
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.96
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 1
siblings	: 4
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.82
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 2
siblings	: 4
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.81
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 3
siblings	: 4
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.81
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.74
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 6
model name	:                    Genuine Intel(R) CPU 3.40GHz
stepping	: 8
cpu MHz		: 3391.555
cache size	: 16384 KB
physical id	: 1
siblings	: 4
core id		: 0
cpu cores	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 6
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
xtpr lahf_lm
bogomips	: 6782.79
clflush size	: 64
cache_alignment	: 128
address sizes	: 40 bits physical, 48 bits virtual
power management:
