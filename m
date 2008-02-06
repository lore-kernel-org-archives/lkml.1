Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYBFWob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYBFWob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbYBFWoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:44:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56699 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756528AbYBFWoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:44:22 -0500
Date: Wed, 6 Feb 2008 23:44:41 +0100
From: Pavel Machek <pavel@ucw.cz>
To: gregory.haskins@gmail.com
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: any cpu hotplug changes in 2.6.24-current-git?
Message-ID: <20080206224441.GC1630@elf.ucw.cz>
References: <20080206125807.GB26817@elf.ucw.cz> <47A9D14C.8000002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A9D14C.8000002@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> Are there any recent changes in cpu hotplug? I have suspend (random)
>> problems, nosmp seems to fix it, and last messages in the "it hangs"
>> case are from cpu hotplug...

>   Can you send along your cpuinfo?

It happened on more than one machine, one cpuinfo is:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 14
model name      : Genuine Intel(R) CPU           T2400  @ 1.83GHz
stepping        : 8
cpu MHz         : 1000.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
bogomips        : 3657.58
clflush size    : 64

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
