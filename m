Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYGPAC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYGPAC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYGPACv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:02:51 -0400
Received: from ax54.genwebserver.com ([72.18.156.50]:43129 "EHLO
	ax54.genwebserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbYGPACu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:02:50 -0400
Message-ID: <487D3A13.3040507@assumpcao.org>
Date: Tue, 15 Jul 2008 21:00:19 -0300
From: Tiago Assumpcao <tiago@assumpcao.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: pageexec@freemail.hu, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
References: <20080703185727.GA12617@suse.de>, <487D3056.1183.1C0E1C47@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ax54.genwebserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - assumpcao.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 16 Jul 2008, pageexec@freemail.hu wrote:
>> you should check out the last few -stable releases then and see how
>> the announcement doesn't ever mention the word 'security' while fixing
>> security bugs
> 
> Umm. What part of "they are just normal bugs" did you have issues with?
> 
> I expressly told you that security bugs should not be marked as such, 
> because bugs are bugs. 
> 
>> in other words, it's all the more reason to have the commit say it's
>> fixing a security issue.
> 
> No.
> 
>>> I'm just saying that why mark things, when the marking have no meaning? 
>>> People who believe in them are just _wrong_.
>> what is wrong in particular?
> 
> You have two cases:
> 
>  - people think the marking is somehow trustworthy.
> 
>    People are WRONG, and are misled by the partial markings, thinking that 
>    unmarked bugfixes are "less important". They aren't.
> 
>  - People don't think it matters
> 
>    People are right, and the marking is pointless.
> 
> In either case it's just stupid to mark them. I don't want to do it, 
> because I don't want to perpetuate the myth of "security fixes" as a 
> separate thing from "plain regular bug fixes".
> 
> They're all fixes. They're all important. As are new features, for that 
> matter.
> 
>> when you know that you're about to commit a patch that fixes a security 
>> bug, why is it wrong to say so in the commit?
> 
> It's pointless and wrong because it makes people think that other bugs 
> aren't potential security fixes.
> 
> What was unclear about that?
> 
> 		Linus

For all the above: no. And this is the point of divergence.
For you, as a person who "writes software", every bug is equivalent. You 
need to resolve problems, not classify them.

However, as I previously explained [http://lkml.org/lkml/2008/7/15/654], 
security issues are identified and communicated through what can be a 
long and complicated (due to DNAs, etc.) process. If it culminates at 
implementation, without proper information forwarding from the 
development team, it will never reach the "upper layers" -- vendors, 
distributors, end users, et al.

Therefore, yes, it is of major importance that you people, too, buy the 
problem and support the process as a whole. Otherwise... well, 
otherwise, we're back to where we started, 20 years ago. Good luck Linux 
users.

--t

