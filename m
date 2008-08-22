Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYHVTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYHVTmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYHVTmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:42:05 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:42964 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYHVTmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:42:04 -0400
Date: Fri, 22 Aug 2008 16:42:14 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822164214.0ae9eb8f@doriath.conectiva>
In-Reply-To: <48AF10FD.2000209@zytor.com>
References: <20080820162925.75a5e064@doriath.conectiva>
	<48ADDF4F.2020401@zytor.com>
	<48AE5FCF.6030103@zytor.com>
	<20080822065012.GV14110@elte.hu>
	<20080822113941.147a1db0@doriath.conectiva>
	<20080822153451.GA8390@Krystal>
	<20080822132948.57e47076@doriath.conectiva>
	<48AEF457.5020100@zytor.com>
	<20080822161040.27c68cf0@doriath.conectiva>
	<48AF10FD.2000209@zytor.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 22 Aug 2008 12:18:21 -0700
"H. Peter Anvin" <hpa@zytor.com> escreveu:

| Luiz Fernando N. Capitulino wrote:
| > 
| >  I'm running Mandriva's VirtualBox 1.6.4 OSE, my host kernel is 2.6.26-3mnb
| > (patched).
| > 
| 
| What is your host *system* like -- CPU especially, and is your host 
| kernel 32 or 64 bits?

 32 bits, /proc/cpuinfo output:

"""
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 4
model name	: Intel(R) Pentium(R) 4 CPU 2.40GHz
stepping	: 1
cpu MHz		: 2410.462
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe constant_tsc pebs bts pni monitor ds_cpl cid xtpr
bogomips	: 4825.33
clflush size	: 64
power management:
"""

 I have 1G of RAM and a VIA mobo.

-- 
Luiz Fernando N. Capitulino
