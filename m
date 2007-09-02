Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbXIBRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbXIBRdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXIBRdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:33:07 -0400
Received: from sidhe.atheme.org ([204.15.224.234]:57862 "EHLO sidhe.atheme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbXIBRdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:33:06 -0400
Message-ID: <46DAF43E.8030407@partiallystapled.com>
Date: Sun, 02 Sep 2007 13:34:54 -0400
From: Michael Tharp <gxti@partiallystapled.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070619)
MIME-Version: 1.0
To: espie@nerim.net
CC: linux-kernel@vger.kernel.org
Subject: Re: GPL weasels and the atheros stink
References: <20070902140306.GA27317@lain.home>
In-Reply-To: <20070902140306.GA27317@lain.home>
X-Enigmail-Version: 0.95.3
OpenPGP: id=94C1C841
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Espie wrote:
> Let's extend the story a wee little bit. It seems that these days, some
> parts of the opensource community have gotten confident enough that they
> do not need the other part. We all know the situation is already fairly
> disymetric. The GPL is less free than the ISC licence for instance (for
> some definition of free), [...]

It does indeed depend on your definition of free. I, for one, find
BSD/ISC "more free" since it grants rights to any potential user or
contributor, not just those using a compatible license. Others may find
the GPL "more free" since it encourages contributors to give their code
back to the original project, or at least allows the original project to
consume those changes, meaning that the project can benefit from changes
made by a third party and still remain usable by all.

> So, now, it's down to dirty fighting. Absorbing and `relicensing' and 
> evolving code.  Have you all been bitten my RMS paranoia (that leads to
> this `interesting GPLv3) ? Do you intend to keep grabbing BSD code and
> putting it exclusively under the GPL ?

That's the bittersweet side of BSD licensing - others have every right
to take your code and use it for their own projects without having to
give their changes back to you.

> Well, if that's truely the case, I may reconsider my good faith for future
> contributions. Heck, instead of giving away my code under the GPL, I could
> keep my contributions in the form of patches. Ironically, with tools such
> as git, this is no longer as cumbersome as this used to be. So, instead
> of new gcc code sent to the FSF (and given to the FSF), we could explicitly
> keep patches under the ISC licence, and explain loudly why this is so.

Technologically quite easy, yes, and while I'm sure no-one would really
challenge you for doing so. it'd be interesting to know how legal it
would be to distribute an ISC patchset on top of GPL code.

> Nice going, GPL fan-boys...
> --
> 	Marc Espie

-- m. tharp, BSD fanboy, devil's advocate
