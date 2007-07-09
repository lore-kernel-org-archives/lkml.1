Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbXGIUTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbXGIUTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbXGIUTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:19:00 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:34354 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760145AbXGIUS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:18:58 -0400
Message-ID: <4692981E.20303@mandic.com.br>
Date: Mon, 09 Jul 2007 17:18:38 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: clocksource tsc unstable
References: <46924CEB.7080108@mandic.com.br> <46925970.8080602@redhat.com>
In-Reply-To: <46925970.8080602@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo escreveu:
> Renato S. Yamane wrote:
>> On Kernel 2.6.21.6 I see this message in dmesg:
>> Clocksource tsc unstable (delta = 732182695 ns)
>> It's normal?
>
> AMD CPU? SMP? Details, please.

Oh, sorry!
cat /proc/cpuinfo

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.86GHz
stepping        : 8
cpu MHz         : 800.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca 
cmov pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe est tm2
bogomips        : 1596.70
clflush size    : 64

Regards,
Renato
