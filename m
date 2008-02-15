Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYBOPld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYBOPld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYBOPlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:41:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54361 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751490AbYBOPlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:41:24 -0500
Date: Fri, 15 Feb 2008 15:31:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: device-mapper development <dm-devel@redhat.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single
 device DM devices
Message-ID: <20080215153148.1db2137f@core>
In-Reply-To: <20080215153439.GB30504@one.firstfloor.org>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
	<20080215153439.GB30504@one.firstfloor.org>
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

> And don't RH distributions install with LVM by default these days?
> For those it should be the standard case too on all systems with
> only a single disk.

Yes - I make a point of turning it off ;)

Alan
