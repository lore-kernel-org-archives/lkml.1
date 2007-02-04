Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbXBDGQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbXBDGQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 01:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXBDGQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 01:16:19 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:59089 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbXBDGQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 01:16:19 -0500
Date: Sat, 3 Feb 2007 22:08:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/59] -stable review
Message-Id: <20070203220828.f095bb91.randy.dunlap@oracle.com>
In-Reply-To: <20070203025913.GL10475@sequoia.sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
	<20070203025913.GL10475@sequoia.sous-sol.org>
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

On Fri, 2 Feb 2007 18:59:13 -0800 Chris Wright wrote:

> * Chris Wright (chrisw@sous-sol.org) wrote:
> > Responses should be made by Mon Feb  3 02:30 UTC 2007
> 
> Yes, that's Mon Feb 5 (thanks to those on their toes ;-)
> 
> And the roll-up will be available at:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/chrisw/stable/patch-2.6.19.3-rc1.{gz,bz2}
> 
> once mirroring finishes.

Shouldn't this apply cleanly to 2.6.19?  I get

1 out of 1 hunk FAILED -- saving rejects to file Makefile.rej
1 out of 2 hunks FAILED -- saving rejects to file net/ipv6/addrconf.c.rej

---
~Randy
