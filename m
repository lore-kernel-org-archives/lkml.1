Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXFZMNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXFZMNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXFZMNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:13:43 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51904 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751725AbXFZMNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:13:43 -0400
Message-ID: <4680FFB8.8020200@aitel.hist.no>
Date: Tue, 26 Jun 2007 13:59:52 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: =?UTF-8?B?Wm9sdMOhbiBIVUJFUlQ=?= <zoltan.hubert@zzaero.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Please release a stable kernel Linux 3.0
References: <200706212349.54983.zoltan.hubert@zzaero.com> <9a8748490706211529yca0588dgd1f7e0b86f7e4a62@mail.gmail.com> <200706220057.33984.zoltan.hubert@zzaero.com>
In-Reply-To: <200706220057.33984.zoltan.hubert@zzaero.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zoltán HUBERT wrote:
> On Friday 22 June 2007 00:29, Jesper Juhl wrote:
>
>   
>>> You might think it's easy for me to simply "use" Linux
>>> and complain while you're doing the hard stuff. As it
>>> happens, the current development/stable model makes our
>>> life as "users" more and more difficult.
>>>       
>> In what way?
>>     
>
> Well, I'm using SuSE Pro 9.3 (excellent choice by the way), 
> coming with kernel 2.6.10-SuSE, on a ATI laptop, and the 
> drivers privided wouldn't compile (suspend & freinds). The 
> SATA disks were only supported from 2.6.15 (which just came 
> out), so I had to edit the "source code" of a closed source 
> driver to make it all work well. If that's "easy" for you I 
> doubt it is for 99.999% of earth's population. "World 
> domination" is far away.
>
> Also, the 7 National Instruments cards I'm using for a 
> deformable mirror in Adaptive Optics in an industrial PC 
> are "certified" for SuSE 9.3 only. Which, this week, got 
> discontinued. So what now ?
>   
You either stick with SuSE 9.3 forever, or you
*try* something newer to see if it works,
or you pay the manufacturer to certify something newer.

This problem isn't linux specific - hardware vendors tend
to support software that is current at time of sale, then
the world moves on without them.  This happens
for all operating systems.

>   
>> I don't think you'll find very 
>> many people on this list who gives a damn about the
>> troubles of closed source driver developers.
>>     
>
> and what about their users ?
>   
Users of closed-source drivers get their support from
the closed-source vendor - not from the kernel developers.
It is that simple.
Again - this is how all operating systems works.
If you have closed windows 3.1 drivers, then microsoft do
*not* make sure they work with vista either - unless
the device is extremely mainstream.  For all other devices,
the device manufacturer have to provide updated drivers.

If your vendor don't want to support you anymore, try getting
the source. 

Helge Hafting
