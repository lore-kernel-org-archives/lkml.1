Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbXIER7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbXIER7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXIER7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:59:31 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37656 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbXIER7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:59:30 -0400
Message-ID: <46DEEE41.6090309@oracle.com>
Date: Wed, 05 Sep 2007 10:58:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tim Teulings <rael@edge.ping.de>, michal.k.k.piotrowski@gmail.com,
       rbrito@gmail.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>	<6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com>	<20070827065246.GA21220@ime.usp.br>	<46D279E8.10001@edge.ping.de>	<46D72BC6.3020809@edge.ping.de>	<20070905100754.57ab4e3e.akpm@linux-foundation.org> <20070905102824.a481060c.randy.dunlap@oracle.com> <46DEEAC1.7020900@s5r6.in-berlin.de>
In-Reply-To: <46DEEAC1.7020900@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Randy Dunlap wrote:
>> On Wed, 5 Sep 2007 10:07:54 -0700 Andrew Morton wrote:
>>>> So here is the output from dmesg that suggested to me that firewire 
>>>> might be a problem:
>>> Straightforward regression, two reporters, nothing happening.
>> (material for ksummit discussion, e.g.)
> 
> It's a simple thing in this incident:  I don't read all posts on LKML.
> But I typically catch everything where I am in the CC list thanks to the
> wonders of sieve.  Andrew, thanks for putting me in the CCs.

I understand.  I just meant the general trend, nothing specific
to this thread.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
