Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYCPXBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYCPXBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 19:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYCPXBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 19:01:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39158 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609AbYCPXBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:01:13 -0400
Date: Sun, 16 Mar 2008 22:46:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080316224633.140a5c99@core>
In-Reply-To: <200803161536.20128.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803161457.04580.phillips@phunq.net>
	<20080316215547.07824de7@core>
	<200803161536.20128.phillips@phunq.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hostility does not equate to accuracy.  Galileo comes to mind.

I see no attempt to even discuss the use of two sets
of physical storage to maintain coherent snapshots, just comments about
hostility. That's a fairly poor way to repay people who spend a lot of
time working with enterprise customers and are interested in solutions
using things like giant ramdisks and are putting in time to discuss
alternative ways of achieving the desired result.

> I see people arguing that a server+linux+batteries+mirroring+replication
> cannot achieve enterprise grade reliability.  Balderdash.

I look forward to seeing your constructive detailed analysis of failure
modes based upon actual statistical data from real data centres. Unless
you can produce that nobody is going to take you seriously, which is bad
luck for the poor folks at violin if they are relying on you.

Alan
