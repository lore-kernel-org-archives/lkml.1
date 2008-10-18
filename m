Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYJRDVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYJRDVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 23:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYJRDVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 23:21:34 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:38121 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYJRDVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 23:21:34 -0400
Cc: Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Message-Id: <EB857BA8-ACBD-4090-9C55-9B975C27279F@freescale.com>
From: Becky Bruce <becky.bruce@freescale.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [git pull] core kernel updates for v2.6.28
Date: Fri, 17 Oct 2008 21:58:43 -0500
References: <20081015125023.GA6702@elte.hu> <alpine.LFD.2.00.0810161518320.3288@nehalem.linux-foundation.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 16, 2008, at 5:32 PM, Linus Torvalds wrote:

>
>
> On Wed, 15 Oct 2008, Ingo Molnar wrote:
>>
>> Please pull the latest core-v28-for-linus git tree from:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6- 
>> tip.git core-v28-for-linus
>>
>> this is a combination of the following topics:
>>   ...
>>   core/resources
>
> Ok, the resource_size_t -> generic phys_addr_t changes conflicted  
> with the
> PowerPC changes I had merged yesterday. The resolution wasn't overly
> complex, but I'm sure I screwed something up anyway. Can the involved
> Power people take a look (looks like BenH, Kumar, Becky to me), and
> Jeremy/Ingo on the generic resource side?

I don't see any issues, and it builds/boots on 85xx and 86xx.

Cheers,
Becky
