Return-Path: <linux-kernel-owner+w=401wt.eu-S1031044AbXDUNLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031044AbXDUNLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031045AbXDUNLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:11:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:53280 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031044AbXDUNLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:11:48 -0400
X-Originating-Ip: 74.109.98.130
Date: Sat, 21 Apr 2007 09:11:48 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Tilman Schmidt <tilman@imap.cc>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>, Karsten Keil <kkeil@suse.de>
Subject: Re: other potentially deletable, dead stuff
In-Reply-To: <462A03D7.4030508@imap.cc>
Message-ID: <Pine.LNX.4.64.0704210911190.6511@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704201901470.2187@CPE00045a9c397f-CM001225dbafb6>
 <462A03D7.4030508@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007, Tilman Schmidt wrote:

> Am 21.04.2007 01:19 schrieb Robert P. J. Day:
> > [...] here's the short list of other stuff that is listed as on
> > its way to being dead, based on the contents of Kconfig files.  any of
> > this stuff candidates for removal, if not scheduling for removal?
>
> [...]
>
> > config ISDN_I4L
> >         tristate "Old ISDN4Linux (obsolete)"
>
> <message type=recorded>
>
> The "obsolete" label on the ISDN_I4L Kconfig option is,
> and has always been, incorrect.
>
> isdn4linux is not obsolete.
>
> isdn4linux is in active use, and there is no replacement.
>
> Removing isdn4linux would constitute a serious regression.

i know.  believe me, i *know that*, since i'm fairly sure it was my
observation that initially started that discussion about isdn4linux.
i did make it clear in that previous post that all i was doing was
listing stuff in the source tree that is currently marked with
"obsolete" or something like that, with no regard to any discussion
that's taken place about it recently.

all i was interested in was feedback along the lines of, "oh, yeah,
*that* feature is thoroughly dead and can be tossed," nothing more.

rday
