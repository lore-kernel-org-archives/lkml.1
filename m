Return-Path: <linux-kernel-owner+w=401wt.eu-S1765369AbXHXRm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765369AbXHXRm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbXHXRmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:42:05 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:20897 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217AbXHXRmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:42:01 -0400
Date: Fri, 24 Aug 2007 10:42:00 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt Mackall <mpm@selenic.com>, Bryan Wu <bryan.wu@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, joe@perches.com,
       yi.li@analog.com, vivi.li@analog.com, torvalds@linux-foundation.org,
       sonic.zhang@analog.com, roy.huang@analog.com, robin.getz@analog.com,
       michael.hennerich@analog.com, michael.frysinger@analog.com,
       marc.hoffman@analog.com, linux-kernel@vger.kernel.org,
       jie.zhang@analog.com, grace.pan@analog.com, bernd.schmidt@analog.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH take #2] MAINTAINTERS: use our mail list as Blackfin arch maintainters.
Message-ID: <20070824174200.GA15824@hexapodia.org>
References: <46bff904.ANPWrqncsP8VpmBH%joe@perches.com> <1187777706.24914.2.camel@roc-desktop> <6bffcb0e0708220323w5592df25n9c21c7e3aca1dbfb@mail.gmail.com> <8bd0f97a0708220345g26c35288g5e96b6f1f8491f0e@mail.gmail.com> <1187794511.6805.3.camel@roc-laptop> <20070824002413.GB20266@waste.org> <1187928287.5949.2.camel@roc-desktop> <20070824045635.GK21720@waste.org> <20070824100943.4e81932a@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824100943.4e81932a@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 10:09:43AM +0100, Alan Cox wrote:
> > > As Mike said, "it is moderated which means you do not need to subscribe,
> > > we will
> > > forward any relevant messages"
> > 
> > And as I said, "does your list generate a complaint message back to
> > the sender?" It's the moderation message that's the problem.
> 
> It doesn't send a complaint, it sends a useful note that your message is
> pending moderation.

It's another waste of space in my inbox due to poorly-implemented
software.

If their mailman installation uses a whitelist, so I get *one* message
per list rather than a bounce for every message I send, then that's
somewhat acceptable.  If I get mailbombed just for participating in a
thread on lkml, that's definitely not acceptable (and I will remove such
lists from the Cc).

It would be vastly better if mailman were smart enough to autoapprove
threaded replies -- it's not as if the spammers are any more likely to
forge In-Reply-To: than From: (which they already do).  Or even to not
waste my time by sending a "held for moderation" message until it's
processed by the listowner.

> The rest appears to be your personal issue Matt, perhaps caused by not
> setting up smart enough mail filters ?

Not sure what ad hominem attacks have to do with this situation.  It's
not as if I can reasonably /dev/null all mailman gunk; if there's a real
exception condition, I want to see it.

-andy
