Return-Path: <linux-kernel-owner+w=401wt.eu-S964794AbXBYKnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbXBYKnE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964792AbXBYKnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:43:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40299 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbXBYKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:43:00 -0500
Date: Sun, 25 Feb 2007 11:42:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tilman Schmidt <tilman@imap.cc>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
Message-ID: <20070225104255.GD2045@elf.ucw.cz>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6> <200702181935.07454.bzolnier@gmail.com> <45DB218E.1080106@imap.cc> <200702201942.50186.bzolnier@gmail.com> <Pine.LNX.4.64.0702201750030.11016@localhost.localdomain> <45DB805C.5010808@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DB805C.5010808@imap.cc>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-02-21 00:12:28, Tilman Schmidt wrote:
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

It probably never will. Some hardware is so obsolete that noone will
care :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
