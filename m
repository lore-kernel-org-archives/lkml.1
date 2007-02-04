Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbXBDRif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbXBDRif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXBDRif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:38:35 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54161 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbXBDRie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:38:34 -0500
Date: Sun, 4 Feb 2007 09:30:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/59] -stable review
Message-Id: <20070204093032.730f4598.randy.dunlap@oracle.com>
In-Reply-To: <20070204133623.GA25817@redhat.com>
References: <20070203023504.435051000@sous-sol.org>
	<20070203025913.GL10475@sequoia.sous-sol.org>
	<20070203220828.f095bb91.randy.dunlap@oracle.com>
	<20070204133623.GA25817@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007 08:36:23 -0500 Dave Jones wrote:

> On Sat, Feb 03, 2007 at 10:08:28PM -0800, Randy Dunlap wrote:
>  > On Fri, 2 Feb 2007 18:59:13 -0800 Chris Wright wrote:
>  > 
>  > > * Chris Wright (chrisw@sous-sol.org) wrote:
>  > > > Responses should be made by Mon Feb  3 02:30 UTC 2007
>  > > 
>  > > Yes, that's Mon Feb 5 (thanks to those on their toes ;-)
>  > > 
>  > > And the roll-up will be available at:
>  > > 
>  > > 	http://www.kernel.org/pub/linux/kernel/people/chrisw/stable/patch-2.6.19.3-rc1.{gz,bz2}
>  > > 
>  > > once mirroring finishes.
>  > 
>  > Shouldn't this apply cleanly to 2.6.19?  I get
>  > 
>  > 1 out of 1 hunk FAILED -- saving rejects to file Makefile.rej
>  > 1 out of 2 hunks FAILED -- saving rejects to file net/ipv6/addrconf.c.rej
> 
> The -rc's usually apply to the previously released -stable (.2 in this case).

Oh.  Thanks, that works.   "usually"?   but not always?  :)

---
~Randy
