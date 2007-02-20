Return-Path: <linux-kernel-owner+w=401wt.eu-S1161050AbXBTXHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161050AbXBTXHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161051AbXBTXHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:07:06 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:39708 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161050AbXBTXHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:07:04 -0500
X-Originating-Ip: 74.102.209.62
Date: Tue, 20 Feb 2007 18:01:32 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Tilman Schmidt <tilman@imap.cc>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and
 OBSOLETE.
In-Reply-To: <20070220225622.GA8347@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0702201757530.11185@localhost.localdomain>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6>
 <200702181935.07454.bzolnier@gmail.com> <45DB218E.1080106@imap.cc>
 <Pine.LNX.4.64.0702201746050.11016@localhost.localdomain>
 <20070220225622.GA8347@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Sam Ravnborg wrote:

> On Tue, Feb 20, 2007 at 05:47:43PM -0500, Robert P. J. Day wrote:

> > in a nutshell, my idea of deprecated is: perhaps still supported,
> > still being used, but there is a better alternative available right
> > now and you should consider switching at your convenience.
> >
> > obsolete means dead/unsupported/use at own risk.  might still work but
> > no guarantees and could be removed at any time.
>
> This is also my understanding. In MIB's the terms are sued more-or-less
> as defined by Robert.
>
> 	Sam (non-native)

see:  http://www.w3.org/TR/WD-html40-970917/convent.html, particularly
how deprecated is defined "outdated by newer constructs," meaning that
there is a better alternative available *now* and not just on the way.

i can always change the wording in the patch, but if we get any more
pedantic, we're going to be counting how many angels you can get on
a split hair.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
