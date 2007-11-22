Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbXKVIml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbXKVIml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 03:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXKVImd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 03:42:33 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:36247 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbXKVImc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 03:42:32 -0500
Message-ID: <474540EC.9090209@linux.vnet.ibm.com>
Date: Thu, 22 Nov 2007 14:12:20 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: youquan_song@linux.intel.com
CC: linux-kernel@vger.kernel.org, youquan.song@intel.com
Subject: Re: In /proc/cpuinfo, all processor items show "0"
References: <3658.172.16.183.182.1195716874.squirrel@linux.intel.com>
In-Reply-To: <3658.172.16.183.182.1195716874.squirrel@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

youquan_song@linux.intel.com wrote:
> Build kernel 2.6.24-rc3,   cat /proc/cpuinfo,  all processor items show "0":
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 0
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 7465.18
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 2
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.81
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 3
> siblings	: 4
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.80
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 1
> siblings	: 4
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.79
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 2
> siblings	: 4
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.80
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 3
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.80
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 0
> siblings	: 4
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.74
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 1
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.81
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 2
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.81
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 3
> siblings	: 4
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.81
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 0
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.96
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 1
> siblings	: 4
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.82
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 2
> siblings	: 4
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.81
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 3
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.81
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 0
> siblings	: 4
> core id		: 1
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.74
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 6
> model name	:                    Genuine Intel(R) CPU 3.40GHz
> stepping	: 8
> cpu MHz		: 3391.555
> cache size	: 16384 KB
> physical id	: 1
> siblings	: 4
> core id		: 0
> cpu cores	: 2
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 6
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat
> pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
> constant_tsc pebs bts sync_rdtsc pni monitor ds_cpl vmx est tm2 cid cx16
> xtpr lahf_lm
> bogomips	: 6782.79
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 40 bits physical, 48 bits virtual
> power management:

Hi,

This patch should help you http://marc.info/?l=linux-kernel&m=119392088227245.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
