Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXIQMTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXIQMTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 08:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbXIQMTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 08:19:38 -0400
Received: from thunk.org ([69.25.196.29]:39592 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXIQMTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 08:19:37 -0400
Date: Mon, 17 Sep 2007 08:19:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Adrian Bunk <bunk@kernel.org>, "Can E. Acar" <can.acar@pro-g.com.tr>,
       misc@openbsd.org, linux-kernel@vger.kernel.org,
       Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917121930.GB9359@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070917111805.GA31443@schlund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917111805.GA31443@schlund.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 01:18:05PM +0200, Hannah Schroeter wrote:
> >So for code which is single-licensed under a BSD license, someone can
> >create a new derived work, and redistribute it under a more
> >restrictive license --- either one as restrictive as NetApp's (where
> >no one is allowed to get binary unless they are a NetApp customer, or
> >source only after signing an NDA), or a GPL license.  It is not a
> >relicencing, per se, since the original version of the file is still
> >available under the original copyright; it is only the derived work
> >which is under the more restrictive copyright.   
> 
> No. The derivative work altogether has a *mixed* license. BSD/ISC for
> the parts that are original, the other (restrictive, GPL, whatever)
> license for the modifications/additions.

Yes, agreed.  I was being sloppy.  In actual practice, the GPL is more
restrictive, aod so the terms of the GPL are what tend to have more
effect, but you are absolutely correct.

> *If* you choose to distribute source along with the binaries, the part
> of the source that's original is BSD/ISC licensed even in the derivative
> work (though one may put *the additions/modifications* under restrictive
> conditions, e.g. of commercial non-disclosure type source licensing).

Yes, although actually, the place where the BSD license must be
honored is in a binary distribution, since the BSD license and
copyright attribution must be distributed as part of the binary
distribution.  (Even Microsoft does this when they use BSD code.)

For a source distribution, retaining the copyright attribution and
permission statement in the comments is sufficient to meet the BSD
license requirements, and since the open source world normally deals
mostly with source, we sometimes get sloppy with how we phrase things.

Regards,

						- Ted
