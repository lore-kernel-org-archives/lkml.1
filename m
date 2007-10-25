Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbXJYWYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbXJYWYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbXJYWYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:24:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37526 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753267AbXJYWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:24:20 -0400
Date: Thu, 25 Oct 2007 23:21:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Chris Wright" <chrisw@sous-sol.org>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Simon Arlott" <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
 static interface)
Message-ID: <20071025232150.25d6e5bd@the-village.bc.nu>
In-Reply-To: <2c0942db0710251117k37c30b2ex5cc6d8cd8c9ea029@mail.gmail.com>
References: <20071024223124.GI30533@stusta.de>
	<446110.89443.qm@web36608.mail.mud.yahoo.com>
	<20071025002356.GB3660@sequoia.sous-sol.org>
	<2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	<20071025024131.6082e4a8@the-village.bc.nu>
	<2c0942db0710251117k37c30b2ex5cc6d8cd8c9ea029@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > There is a ton of evidence both in computing and outside of it which
> > shows that poor security can be very much worse than no security at all.
> 
> (So, I take it that you *don't* lock your bike up, as poor security is
> worse than none?)

On the contrary because I know it is not secure I would

a) Insure it
b) Not waste vast amounts of money on a useless expensive lock
c) Make sure the bike looked not worth stealing
d) Take the saddle with me

(or the software versions of that

a) Keep backups
b) Not waste vast amounts of money on bogus security software
c) Keep the system looking uninteresting
d) Encrypt the data)

> 'Inappropriate risks' nowadays is surfing the web and opening up mail
> attachments that claim to be movies of dancing bears. I'd argue that
> users have a reasonable expectation that these are things that should
> 'just work,' and be safe, much as normal humans have an expectation
> that their car isn't going to explode when they turn the ignition.

Yes and its very clear from the things said by politicians that if the
computer software people don't do this soon, the legislators will make
very sure they do by stripping away all the techniques used to hide from
liability for failure.

> Perfect is the enemy of good, or words to that effect, right? My point
> is that requiring perfection out of a security framework is a bar
> that's going to be awfully difficult to reach (and when it supposedly
> has been achieved, as in SELinux, mere mortals find it too troublesome
> to run with as it's far too difficult to configure). Security can and
> should be done in layers, and what one may miss, another may catch.

Absolutely - but those layers should do whatever they do *right* and
really do it, whether they are complex whole system controls like SELinux
or simple network security tools.

Alan
