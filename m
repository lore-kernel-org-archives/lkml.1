Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbYGPART@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbYGPART (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYGPARJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:17:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYGPARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:17:08 -0400
Date: Tue, 15 Jul 2008 17:16:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tiago Assumpcao <tiago@assumpcao.org>
cc: pageexec@freemail.hu, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487D3A13.3040507@assumpcao.org>
Message-ID: <alpine.LFD.1.10.0807151707450.2867@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D3056.1183.1C0E1C47@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org>
 <487D3A13.3040507@assumpcao.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Tiago Assumpcao wrote:
> 
> However, as I previously explained [http://lkml.org/lkml/2008/7/15/654],
> security issues are identified and communicated through what can be a long and
> complicated (due to DNAs, etc.) process. If it culminates at implementation,
> without proper information forwarding from the development team, it will never
> reach the "upper layers" -- vendors, distributors, end users, et al.

Umm. That shouldn't be our worry. If others had a long and involved (and 
broken) process, they should be the ones that track the fixes too. We 
weren't involved, we didn't see that, we simply _cannot_ care.

> Therefore, yes, it is of major importance that you people, too, buy the
> problem and support the process as a whole. Otherwise... well, otherwise,
> we're back to where we started, 20 years ago. Good luck Linux users.

Umm. What was wrong with 20 years ago exactly?

Are you talking about all the wonderful work that the DNS people did for 
that new bug, and how they are heroes for synchronizing a fix and keeping 
it all under wraps?

And isn't that the same bug that djb talked about and fixed in djbdns from 
the start? Which he did about ten YEARS ago?

Excuse me for not exactly being a huge fan of "security lists" and best 
practices. They seem to be _entirely_ be based on PR and how much you can 
talk up a specific bug. No thank you,

			Linus
