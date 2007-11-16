Return-Path: <linux-kernel-owner+w=401wt.eu-S965040AbXKPX0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965040AbXKPX0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935389AbXKPXPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:15:17 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21640 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935292AbXKPXPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:15:14 -0500
Message-ID: <473E247F.2090101@msgid.tls.msk.ru>
Date: Sat, 17 Nov 2007 02:15:11 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.3
References: <20071116183752.GA9807@kroah.com> <20071116184430.GE9807@kroah.com>
In-Reply-To: <20071116184430.GE9807@kroah.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> We (the -stable team) are announcing the release of the 2.6.23.3 kernel.
> It contains a number of bugfixes for a number of architecture specific
> issues.
[.4, .5, .6 and .7 follows after .2 and .3]

I've seen the bunch of patches posted for review - split to several
series.  But - out of curiocity - what's the reason to roll each
series into each own stable release?  Can't all .2...7 be combined
into a single release (not counting .8 wich contains urgent security
fixes)?  (I mean, not with already rolled out stuff, but the original
reasoning for split-releasing them (as opposed to split-reviewing))

Thanks.

/mjt
