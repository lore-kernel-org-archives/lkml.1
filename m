Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbXKANKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbXKANKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXKANKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:10:30 -0400
Received: from il.qumranet.com ([82.166.9.18]:60018 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbXKANK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:10:29 -0400
Message-ID: <4729D051.5040508@qumranet.com>
Date: Thu, 01 Nov 2007 15:10:41 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] kvm: fix !SMP build error
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de> <471E79E2.2090204@garzik.org> <471F03F5.7090608@qumranet.com> <20071024123258.GA28653@elte.hu> <20071024123650.GA31562@elte.hu> <20071024181107.GA15250@elte.hu> <20071031203442.7e161692.rdunlap@xenotime.net> <20071101083139.GB8459@elte.hu>
In-Reply-To: <20071101083139.GB8459@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Randy Dunlap <rdunlap@xenotime.net> wrote:
>
>   
>>>> and this followup patch is needed too if my patch is applied.
>>>>         
>>> plus the patch below is needed too in addition.
>>>
>>> 	Ingo
>>>       
>> Hi,
>> I'm still hitting this build error.  Are these 3 patches not yet
>> merged??
>>     
>
> i thought we agreed it would go in via KVM. Can send it as part of the 
> scheduler git tree too, these patches are working fine for me. Avi?
>
>   

I thought you were handling it, as they aren't part of kvm proper.  But 
I can send them, sure.


-- 
Any sufficiently difficult bug is indistinguishable from a feature.

