Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbXBDE1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbXBDE1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 23:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXBDE1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 23:27:42 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:36874 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbXBDE1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 23:27:41 -0500
Date: Sat, 3 Feb 2007 20:19:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, akpm@osdl.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Blaisorblade <blaisorblade@yahoo.it>, Pravin <shindepravin@gmail.com>,
       uml@flonatel.org
Subject: Re: [patch 25/59] Fix UML on non-standard VM split hosts
Message-Id: <20070203201914.d67c80cf.randy.dunlap@oracle.com>
In-Reply-To: <20070204031152.GA6376@ccure.user-mode-linux.org>
References: <20070203023504.435051000@sous-sol.org>
	<20070203024138.485584000@sous-sol.org>
	<20070203170654.fd0e1d7d.randy.dunlap@oracle.com>
	<20070204031152.GA6376@ccure.user-mode-linux.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 22:11:52 -0500 Jeff Dike wrote:

> On Sat, Feb 03, 2007 at 05:06:54PM -0800, Randy Dunlap wrote:
> > The reformatting looks bad to me.  Kconfig help text should be
> > indented consistently by 2 spaces under "help".
> > 
> > This can be fixed later if you don't want to drop it from -stable.
> 
> The formatting actually broke the Kconfig option, which was noticed by
> Al Viro, who sent a patch, which I forwarded to -stable.

I think that's different lines of text.  What is currently in
http://www.kernel.org/pub/linux/kernel/people/chrisw/stable/patch-2.6.19.3-rc1.{gz,bz2}
still looks like is contains bad indentation.

---
~Randy
