Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbXBDNlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbXBDNlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXBDNlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:41:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbXBDNlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:41:44 -0500
Date: Sun, 4 Feb 2007 08:36:23 -0500
From: Dave Jones <davej@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
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
Message-ID: <20070204133623.GA25817@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
	stable@kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Justin Forbes <jmforbes@linuxtx.org>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
	torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20070203023504.435051000@sous-sol.org> <20070203025913.GL10475@sequoia.sous-sol.org> <20070203220828.f095bb91.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203220828.f095bb91.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 10:08:28PM -0800, Randy Dunlap wrote:
 > On Fri, 2 Feb 2007 18:59:13 -0800 Chris Wright wrote:
 > 
 > > * Chris Wright (chrisw@sous-sol.org) wrote:
 > > > Responses should be made by Mon Feb  3 02:30 UTC 2007
 > > 
 > > Yes, that's Mon Feb 5 (thanks to those on their toes ;-)
 > > 
 > > And the roll-up will be available at:
 > > 
 > > 	http://www.kernel.org/pub/linux/kernel/people/chrisw/stable/patch-2.6.19.3-rc1.{gz,bz2}
 > > 
 > > once mirroring finishes.
 > 
 > Shouldn't this apply cleanly to 2.6.19?  I get
 > 
 > 1 out of 1 hunk FAILED -- saving rejects to file Makefile.rej
 > 1 out of 2 hunks FAILED -- saving rejects to file net/ipv6/addrconf.c.rej

The -rc's usually apply to the previously released -stable (.2 in this case).

		Dave

-- 
http://www.codemonkey.org.uk
