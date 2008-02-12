Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYBLWCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYBLWCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYBLWCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:02:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54114 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600AbYBLWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:02:13 -0500
Date: Tue, 12 Feb 2008 21:51:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212215152.1470fe7f@core>
In-Reply-To: <20080212194100.GH27894@ZenIV.linux.org.uk>
References: <20080212044314.GA4888@kroah.com>
	<20080211211751.3e265754@laptopd505.fenrus.org>
	<20080211.221126.230471463.davem@davemloft.net>
	<47B1CB08.4020101@garzik.org>
	<alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	<1202838082.3137.54.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	<1202840682.3137.83.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
	<alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
	<20080212194100.GH27894@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We could simply decide that API changes affecting more than one subsystem
> Must Be Serialized(tm).  Explicitly.  As in "any such change is posted

Welcome to dreamland. The only way I can get serial changes done is to
wait months and eventually simply persuade Andrew to ignore the
"maintainers" who are basically not responding.

Maybe it works for vfs and mm internals but out here in driverspace
forget it - and if I simply break drivers people get cross instead of
fixing them nowdays.
