Return-Path: <linux-kernel-owner+w=401wt.eu-S1161081AbXBTXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161081AbXBTXZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161088AbXBTXZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:25:24 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:40224 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161082AbXBTXZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:25:21 -0500
X-Originating-Ip: 74.102.209.62
Date: Tue, 20 Feb 2007 18:23:22 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Tilman Schmidt <tilman@imap.cc>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and
 OBSOLETE.
In-Reply-To: <45DB805C.5010808@imap.cc>
Message-ID: <Pine.LNX.4.64.0702201820400.11849@localhost.localdomain>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6>
 <200702181935.07454.bzolnier@gmail.com> <45DB218E.1080106@imap.cc>
 <200702201942.50186.bzolnier@gmail.com> <Pine.LNX.4.64.0702201750030.11016@localhost.localdomain>
 <45DB805C.5010808@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Tilman Schmidt wrote:

> Am 20.02.2007 23:52 schrieb Robert P. J. Day:
> > "deprecated" means that there *is* a complete replacement available
> > *right now* and you should consider switching to it.
> >
> > if you can't offer someone a completely functional, better alternative
> > to what they're using now, then you can't say that what they're using
> > now is deprecated.
>
> So, to take a specific example (incidentally the one I am
> personally interested in):
>
> isdn4linux (CONFIG_ISDN_I4L), currently marked as "obsolete"
> (which is undoubtedly incorrect), would not even qualify as
> "deprecated" as long as its successor, the CAPI 2.0 subsystem
> (CONFIG_ISDN_CAPI) doesn't support all the hardware currently
> supported by old i4l.
>
> Or did I misunderstand something there?

IMHO, unless you have a fully-functional replacement ready to go, you
can't call something "deprecated" much less "obsolete".  so, yes,
calling isdn4linux "obsolete" is hideously premature.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
