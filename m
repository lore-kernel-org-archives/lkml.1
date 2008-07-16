Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYGPMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYGPMGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYGPMGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:06:07 -0400
Received: from r00tworld.com ([212.85.137.21]:58530 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbYGPMGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:06:06 -0400
From: pageexec@freemail.hu
To: David Miller <davem@davemloft.net>
Date: Wed, 16 Jul 2008 13:52:27 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: tiago@assumpcao.org, torvalds@linux-foundation.org, greg@kroah.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Message-ID: <487DFD1B.24879.1F2DFAA2@pageexec.freemail.hu>
In-reply-to: <20080716.040447.249346237.davem@davemloft.net>
References: <487DE856.15132.1EDCDAAF@pageexec.freemail.hu>, <487DEED3.1351.1EF6349A@pageexec.freemail.hu>, <20080716.040447.249346237.davem@davemloft.net>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 13:53:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 Jul 2008 at 4:04, David Miller wrote:

> From: pageexec@freemail.hu
> Date: Wed, 16 Jul 2008 12:51:31 +0200
> 
> > On 16 Jul 2008 at 3:31, David Miller wrote:
> > 
> > > From: pageexec@freemail.hu
> > > Date: Wed, 16 Jul 2008 12:23:50 +0200
> > > 
> > > > On 16 Jul 2008 at 3:08, David Miller wrote:
> > > > 
> > > > > IOW, when we fix security issues, it's simply not even appropriate or 
> > > > > relevant to you.
> > > > 
> > > > i'll ask again: why aren't security fixes that you fix relevant to users
> > > > of older kernels (as that's what the topic was)?
> > > 
> > > Backporting any fix to older kernels is a chore, the further back you
> > > go, the harder and less fun it is.
>  ...
> > > The tipping point is really quick to where someone hacking the kernel
> > > for fun simply isn't going to do it, nor should they be expected to.
> > > 
> > > That's why people who want a stable supported kernel with fixes
> > > constantly backported have grown accustomed to paying for that service.
> > 
> > and how does that imply that you should not mark security fixes as such?
> 
> You asked me why fixes are not relevant to users of older upstream
> non-dist kernels.  And I answered that question.

no you did not because that was not my question actually. i wasn't
asking about 'older upstream non-dist kernels' but 'older kernels',
regardless of their being of vanilla or distro or whatever variety.
here it is again (you even quoted it above btw):

  "why aren't security fixes that you fix relevant to users of older kernels"

it doesn't say 'distro'. in fact, i chose my words carefully as there
seems to be a tendency among you guys where you simply ignore or don't
care about the interests of several user groups. there's a whole world
beyond Red Hat and Novell, and some of those people are very well
capable of backporting fixes, so your 'it is too labourious to backport
therefore we don't mark security fixes' argument is simply wrong (an in
all honesty, it's not up to you guys to decide what people are capable or
willing to backport, your responsibility should be to help them, no make
decisions for them). if you want an inside voice, go ask the 2.4 maintainer.
i quoted him already here already in fact:

  I don't like obfuscation at all WRT security issues, it does far more
  harm than good because it reduces the probability to get them picked
  and fixed by users, maintainers, distro packagers, etc...
  (http://lkml.org/lkml/2008/6/10/452)

so what's the next 'justification' for covering up security bugs?

cheers,
  PaX Team

