Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454Ab0ALQan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0ALQan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231Ab0ALQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:30:42 -0500
Received: from thinktradellc.com ([66.17.177.171]:26050 "EHLO
	old.thinktradellc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754227Ab0ALQal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:30:41 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 11:30:41 EST
Message-ID: <4B4CA27F.1060102@memeplex.com>
Date: Tue, 12 Jan 2010 11:25:35 -0500
From: Andrew Athan <aathan@memeplex.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Athan <linux_kernel_aathan@memeplex.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Gong Cheng <chengg11@yahoo.com>
Subject: Re: Futex hang/lockup problem in 2.6.30+ on AMD64
References: <4B4C3E4F.9060001@memeplex.com> <20100112145213.GB3925@hack>	 <1263308127.4244.142.camel@laptop> <2375c9f91001120700r4c2e1e05l5e5be3ddc6a13da2@mail.gmail.com>
In-Reply-To: <2375c9f91001120700r4c2e1e05l5e5be3ddc6a13da2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Tue, Jan 12, 2010 at 10:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>   
>> On Tue, 2010-01-12 at 22:52 +0800, Américo Wang wrote:
>>
>>     
>>>> $ uname -a
>>>> Linux UK22 2.6.30-2-amd64 #1 SMP Fri Sep 25 22:16:56 UTC 2009 x86_64
>>>> GNU/Linux
>>>>         
>> Does a recent kernel work?
>>
>>
>>     
>
> Ah, I just wanted to ask the same question, adding the original reporter
> Gong Cheng into Cc...
>
> Gong, could you reproduce it on the latest kernel? And what is your .config?
>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
Due to remote location of the hardware and I haven't been able to test a 
more recent (or older) kernel.  Remote hands have put a KVM on the box 
as of an hour ago, so I hope to have some information for you in a day 
or two.

A.

