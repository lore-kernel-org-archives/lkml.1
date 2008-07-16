Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbYGPBmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbYGPBmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 21:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYGPBlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 21:41:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbYGPBly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 21:41:54 -0400
Date: Tue, 15 Jul 2008 18:41:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tiago Assumpcao <tiago@assumpcao.org>
cc: pageexec@freemail.hu, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
In-Reply-To: <487D4A7B.8090403@assumpcao.org>
Message-ID: <alpine.LFD.1.10.0807151832260.2835@woody.linux-foundation.org>
References: <20080703185727.GA12617@suse.de>, <487D3056.1183.1C0E1C47@pageexec.freemail.hu>, <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org> <487D3C17.31467.1C3C0441@pageexec.freemail.hu> <alpine.LFD.1.10.0807151620450.2867@woody.linux-foundation.org
 <alpine.LFD.1.10.0807151707450.2867@woody.linux-foundation.org> <487D4301.5080609@assumpcao.org> <alpine.LFD.1.10.0807151749570.2867@woody.linux-foundation.org> <487D4A7B.8090403@assumpcao.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Tiago Assumpcao wrote:
> 
> How can I expect one to treat the unknown? If you are not aware of it, you do
> nothing.

Well, some people keep it secret and track it on vendor-sec or similar, 
hidden from us.

But then when they are ready to announce it, they want our help to glorify 
their corrupt process when they finally deign to let us know. And that 
really irritates me.

> All I ask for is to receive the "There are updates available." message as soon
> as one security problem is reported, understood and treated by your
> development part. And that is, the sooner possible, if you please.

Umm. You're talking to _entirely_ the wrong person.

The people who want to track security issues don't run my development 
kernels. They usually don't even run the _stable_ kernels. They tend to 
run the kernels from some commercial distribution, and usually one that is 
more than six months old as far as I - and other kernel developers - are 
concerned.

IOW, when we fix security issues, it's simply not even appropriate or 
relevant to you. More importantly, when we fix them, your vendor probably 
won't have the fix for at least another week or two in most cases anyway.

So ask yourself - what would happen if I actually made a big deal out of 
every bug we find that could possibly be a security issue. HONESTLY now!

We'd basically be announcing a bug that (a) may not be relevant to you, 
but (b) _if_ it is relevant to you, you almost certainly won't actually 
have fixed packages until a week or two later available to you!

Do you see?

I would not actually be helping you. I'd be helping the people you want to 
protect against!

			Linus
