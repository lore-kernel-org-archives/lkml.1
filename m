Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbXICNVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbXICNVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbXICNVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:21:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42278 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXICNVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:21:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46DC0A0D.1030207@s5r6.in-berlin.de>
Date: Mon, 03 Sep 2007 15:20:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Natalie Protasevich <protasnb@gmail.com>, David Rees <drees76@gmail.com>,
       Daniel Walker <dwalker@mvista.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Bj=F6rn_Stei?= =?ISO-8859-1?Q?nbrink?= 
	<B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Who wants to maintain KR list for stable releases?
References: <20070827005131.b93f5935.akpm@linux-foundation.org> <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com> <1188227585.2435.192.camel@dhcp193.mvista.com> <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com> <1188229197.2435.207.camel@dhcp193.mvista.com> <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com> <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com> <20070829222344.GV26410@stusta.de> <32209efe0708291659w1f75adbcrf72e61a9325903da@mail.gmail.com> <46D6E135.8000203@s5r6.in-berlin.de> <20070903122940.GU16016@stusta.de>
In-Reply-To: <20070903122940.GU16016@stusta.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Aug 30, 2007 at 05:24:37PM +0200, Stefan Richter wrote:
[on whether to track missing features]
>> Where I am around, there are always far too few people who fix things
>> and build things.  But very, very occasionally there is someone new who
>> wonders if there is an interesting TODO item which is perhaps in the
>> reach of his abilities.  Contributing a cleanup or an actual feature is
>> typically much easier than fixing an open, tracked bug.  (The bugs which
>> end up in the bugtracker are usually the difficult ones.)  The
>> contributor learns something and, in a rare turn of events, may
>> eventually become able and willing to join the bugfixing.
> 
> "Contributing a cleanup" is what the Kernel Janitor Project
> already offers.
> 
> But "Contributing an actual feature" is much harder:
> 
> You need a feature:
> - with a realistic chance of being included and
> - hard enough that the person suggesting it doesn't simply implement it
>   himself instead of requesting it

    or there is simply nobody else who takes the time to implement it

>   and
> - easy enough that a newbie can implement it.
> 
> And the code should then be in a reasonable shape for being merged.

Helping to bring it into shape may be one of the easier pastimes of a
gateway person.  (Can be done after mindnumbing day job.)

> IMHO that's nearly impossible.
> 
> Realistically, offering a TODO item for a feature would require the one 
> proposing it to do an amount of mentoring work that is not smaller than 
> the amount of work he had to spend if implementing it himself.
> 
> This might be worth it if you know for sure the person you are mentoring 
> stays active after completion of the feature - but this assumption is 
> too often not true.

Adding a feature is not just a matter of amount of work, it is also a
matter of motivation and inspiration.  So, even if it remains a one-off
project, at least that feature came into life.

But besides these remarks I have to agree with your view, overall.
-- 
Stefan Richter
-=====-=-=== =--= ---==
http://arcgraph.de/sr/
