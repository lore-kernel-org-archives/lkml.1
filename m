Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbXBDDXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbXBDDXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 22:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbXBDDXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 22:23:11 -0500
Received: from [198.99.130.12] ([198.99.130.12]:47939 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbXBDDXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 22:23:10 -0500
Date: Sat, 3 Feb 2007 22:11:52 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, akpm@osdl.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Dike <jdike@addtoit.com>, Blaisorblade <blaisorblade@yahoo.it>,
       Pravin <shindepravin@gmail.com>, uml@flonatel.org
Subject: Re: [patch 25/59] Fix UML on non-standard VM split hosts
Message-ID: <20070204031152.GA6376@ccure.user-mode-linux.org>
References: <20070203023504.435051000@sous-sol.org> <20070203024138.485584000@sous-sol.org> <20070203170654.fd0e1d7d.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070203170654.fd0e1d7d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 05:06:54PM -0800, Randy Dunlap wrote:
> The reformatting looks bad to me.  Kconfig help text should be
> indented consistently by 2 spaces under "help".
> 
> This can be fixed later if you don't want to drop it from -stable.

The formatting actually broke the Kconfig option, which was noticed by
Al Viro, who sent a patch, which I forwarded to -stable.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
