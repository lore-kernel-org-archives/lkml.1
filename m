Return-Path: <linux-kernel-owner+w=401wt.eu-S1030682AbXCCQyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030682AbXCCQyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 11:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030684AbXCCQyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 11:54:22 -0500
Received: from nijmegen.renzel.net ([195.243.213.130]:49075 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030682AbXCCQyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 11:54:21 -0500
Message-ID: <45E9A707.9070508@linuxtv.org>
Date: Sat, 03 Mar 2007 17:49:11 +0100
From: Marcel Siegert <mws@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-dvb@linuxtv.org, akpm@linux-foundation.org, eranian@hpl.hp.com,
       bunk@stusta.de, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, jirislaby@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [linux-dvb] 2.6.21-rc1-git2 is incompilable
References: <20070301143407.29950@gmx.net> <200703011831.26520.mws@linuxtv.org> <20070303154737.65380@gmx.net>
In-Reply-To: <20070303154737.65380@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla schrieb:
> -------- Original-Nachricht --------
> Datum: Thu, 1 Mar 2007 18:31:25 +0100
> Von: Marcel Siegert <mws@linuxtv.org>
> An: linux-dvb@linuxtv.org
> CC: "Uwe Bugla" <uwe.bugla@gmx.de>, torvalds@linux-foundation.org, Slaby <jirislaby@gmail.com>, venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org, bunk@stusta.de, Stephane Eranian <eranian@hpl.hp.com>, akpm@linux-foundation.org
> Betreff: Re: [linux-dvb] 2.6.21-rc1-git2 is incompilable
> 
>> On Thursday 01 March 2007, Uwe Bugla wrote:
>>> Hi folks,
>>> trying to compile kernel 2.6.21-rc1-git2 is impossible. The broken
>> module where the compiler gives up is /arch/i386/kernel/io_apic.c.
>>> Regards
>>>
>>> Uwe
>>>
>>> P. S.: Wouldn't it be a good idea to test at least error-free
>> compilation before stuff like this is being published?
>> hi uwe,
>>
>> according to kernel.org 
>> 2.6.21-rc2-git1 is an actual snapshot
>>
>> but, those are iirc auto generated. thus not being able to compile can
>> happen.
>> it also depends on your special .config
>>
>> best regards
>> marcel
>>
>> p.s. wouldn't it be a good idea to check your mail recipients instead of
>> sending mails to e.g. linux-dvb that do 
>>       have no use with fixes of floppy drivers and or compile status in
>> io_apic? :)
>>
>> dont take it too hard man...
> But I take it very hard as I want quality!
> 
> Ciao
> 
> Uwe
> 
hi,

i can see your point - but then you shouldn't take snapshots of
development environments.

if you want quality take released vanilla versions of the kernel.
they will normally be of that quality an enduser wants.

regards
marcel


