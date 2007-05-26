Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbXEZWIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbXEZWIV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXEZWH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:07:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:42360 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751297AbXEZWH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:07:58 -0400
X-Authenticated: #9839902
X-Provags-ID: V01U2FsdGVkX1+Sr2MLy3eSU22nQtXOSFPt6Tn1PpmvsocYXxhthD
	ZNJF8rkiM6s0IB
Message-ID: <4658AFAA.6000400@gmx.de>
Date: Sun, 27 May 2007 00:07:38 +0200
From: Ulrich Mayer <u14.mayer@gmx.de>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel bug at net/core/skbuf.c:93 [fixed in 2.6.21.2]
References: <46589C14.8030405@gmx.de> <6bffcb0e0705261423s4401cab8x3df4fd13b943b476@mail.gmail.com>
In-Reply-To: <6bffcb0e0705261423s4401cab8x3df4fd13b943b476@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

thanks! Using 2.6.21.3 cured the problem.
The fix was mentioned in the changelog of 2.6.21.2

Uli
-- 
Ulrich Mayer

Michal Piotrowski schrieb:
> Hi Ulrich,
> 
> On 26/05/07, Ulrich Mayer <u14.mayer@gmx.de> wrote:
>> A couple of days ago I sent a note to Ingo Molnar with the following bug
>> report. His response was:
>>
>>  > hm - this doesnt seem to be an apic problem, more of a VDR problem.
>>  > Could you send this report to linux-kernel@vger.kernel.org?
>>  >
>>  >      Ingo
>>
>> Uli
>>
>> -- 
>> Ulrich Mayer
>>
> 
> It looks like a bug in sis900 driver. Please try the latest -stable.
> 
> Regards,
> Michal
> 

