Return-Path: <linux-kernel-owner+w=401wt.eu-S1161005AbXBTWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161005AbXBTWy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161049AbXBTWy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:54:28 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:39149 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161005AbXBTWy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:54:28 -0500
X-Originating-Ip: 74.102.209.62
Date: Tue, 20 Feb 2007 17:52:27 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: Tilman Schmidt <tilman@imap.cc>, Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and
 OBSOLETE.
In-Reply-To: <200702201942.50186.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0702201750030.11016@localhost.localdomain>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6>
 <200702181935.07454.bzolnier@gmail.com> <45DB218E.1080106@imap.cc>
 <200702201942.50186.bzolnier@gmail.com>
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

On Tue, 20 Feb 2007, Bartlomiej Zolnierkiewicz wrote:

>
> On Tuesday 20 February 2007 17:27, Tilman Schmidt wrote:

> > Is that really the consensus on these definitions? I thought it was
> > more or less the opposite:
> >
> > * DEPRECATED == no (complete) replacement available yet, but it has
> >   been decided that this code is less than optimal and
> >   alternatives should be preferred

just to clarify this, that's not my idea of "deprecated".
"deprecated" means that there *is* a complete replacement available
*right now* and you should consider switching to it.

if you can't offer someone a completely functional, better alternative
to what they're using now, then you can't say that what they're using
now is deprecated.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
