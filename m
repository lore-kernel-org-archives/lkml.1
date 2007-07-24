Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXGXPNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXGXPNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXGXPNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:13:16 -0400
Received: from vena.lwn.net ([206.168.112.25]:53577 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXGXPNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:13:15 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rob Landley <rob@landley.net>, "Randy.Dunlap" <rdunlap@xenotime.net>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Mon, 23 Jul 2007 17:12:38 PDT."
             <20070723171238.1a832b31.akpm@linux-foundation.org> 
Date: Tue, 24 Jul 2007 09:13:14 -0600
Message-ID: <5659.1185289994@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Items for consideration would be:
> 
> - if this stuff is good, shouldn't other code be using it?  If so, is
>   this new infrastructure in the correct place?
> 
> - if, otoh, this infrastructure is _not_ suitable for other code, well,
>   what was wrong with it?
> 
> - if the requirement is good, perhaps alternative implementations should
>   be explored (dunno what).

Well, we could just rewrite the whole kernel in Web and judge all future
patches on how literate they are...

Seriously, though, even if the (small) infrastructure is not going to
take over the driver tree anytime soon, it's hard to imagine why we
would not want to incorporate this sort of documentation.  It's good
stuff, something which can really help people get a sense for how this
whole virtualization thing works.  And it makes the code fun to read.

jon

P.S. I am currently considering a no-limericks policy for the LWN quote
of the week.
