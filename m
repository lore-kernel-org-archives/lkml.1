Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYGPKZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYGPKZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbYGPKY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:24:57 -0400
Received: from r00tworld.com ([212.85.137.21]:55274 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915AbYGPKY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:24:56 -0400
From: pageexec@freemail.hu
To: David Miller <davem@davemloft.net>
Date: Wed, 16 Jul 2008 12:23:50 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: tiago@assumpcao.org, torvalds@linux-foundation.org, greg@kroah.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Message-ID: <487DE856.15132.1EDCDAAF@pageexec.freemail.hu>
In-reply-to: <20080716.030857.261411379.davem@davemloft.net>
References: <487D4A7B.8090403@assumpcao.org>, <487DE059.15123.1EBDA558@pageexec.freemail.hu>, <20080716.030857.261411379.davem@davemloft.net>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 12:24:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jul 2008 at 3:08, David Miller wrote:

> From: pageexec@freemail.hu
> Date: Wed, 16 Jul 2008 11:49:45 +0200
> 
> > why? what makes you think that a bug fixed in 2.6.26 is not relevant to
> > 2.6.20? do you or anyone else personally verify that? color me impressed
> > if you do that on every single fix you commit.
> 
> Many people who do kernel development do exactly this for the vendor
> they work for.

i know that. but you conveniently skipped what i was replying to, here
it is for proper context:

> IOW, when we fix security issues, it's simply not even appropriate or 
> relevant to you.

i'll ask again: why aren't security fixes that you fix relevant to users
of older kernels (as that's what the topic was)? in other words, Linus was
trying to justify with one more silly reason why security fixe aren't marked
as such. the above basically said 'because they are not relevant to you'
and i asked him why it is so. you're welcome to explain it as well. and no,
vendors having people go through every single commit doesn't answer why you
couldn't make *their* life easier as well by not withholding information.
and not to mentiond a whole world of interested users beyond the commercial
companies that can afford this kind of cost.

> The SCTP socket option overflow fix got into various dist releases not
> by chance and not because of some utterly pointless "security" tag in
> the commit message.

why do you call a security tag 'utterly pointless'? i've heard Linus's
opinion and deconstructed every single one of his 'justifications' so far.
what's yours gonna be?

cheers,
  PaX Team

