Return-Path: <linux-kernel-owner+w=401wt.eu-S1763840AbXGLMA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763840AbXGLMA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbXGLMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:00:15 -0400
Received: from balanced.mail.policyd.dreamhost.com ([208.97.132.119]:50933
	"EHLO randymail-a12.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753156AbXGLMAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:00:14 -0400
Message-ID: <469617C4.4060000@monkeh.net>
Date: Thu, 12 Jul 2007 12:00:04 +0000
From: Alex Maclean <monkeh@monkeh.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, Tim Gardner <tim.gardner@canonical.com>
Subject: Re: acpi regression on some laptops
References: <20070710160056.443ae9ae@i1501.lan.towertech.it>	<46952CC5.6050800@redhat.com>	<20070712000124.22d0c3a7@i1501.lan.towertech.it>	<46955F4D.3090206@monkeh.net>	<20070712020944.446f3828@i1501.lan.towertech.it>	<46957CAC.8060308@monkeh.net> <20070712093757.24cb70ae@i1501.lan.towertech.it>
In-Reply-To: <20070712093757.24cb70ae@i1501.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Zummo wrote:
> On Thu, 12 Jul 2007 00:58:20 +0000
> Alex Maclean <monkeh@monkeh.net> wrote:
> 
>>>  hw is a Dell Inspiron 1501, AMD Turion TL52 based.
>>>  drop me a note if you need dmesg or other info.
> 
>>>  eax in    eax      ebx      ecx      edx
>>> 00000000 00000001 68747541 444d4163 69746e65
>>> 00000001 00040f82 01020800 00002001 178bfbff
>>>
>> What chipset is it? I'm going to guess at nVidia MCP51, in which case.. 
>> That's the third time that's worked on the MCP51.
> 
>  amd sb600/ati rs480.
> 
> 
> 

Hm, rather different from mine.

Does anyone with a clue want to have a look at this?
