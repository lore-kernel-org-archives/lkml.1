Return-Path: <linux-kernel-owner+w=401wt.eu-S1767276AbXDEUY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767276AbXDEUY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767283AbXDEUY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:24:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37512 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767276AbXDEUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:24:57 -0400
Date: Thu, 5 Apr 2007 21:27:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Roland Dreier <rdreier@cisco.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
Message-ID: <20070405212713.10675e27@the-village.bc.nu>
In-Reply-To: <20070405180334.GW24297@atomide.com>
References: <11757088774110-git-send-email-tony@atomide.com>
	<20070404182728.GK29129@atomide.com>
	<20070404113925.da221efc.randy.dunlap@oracle.com>
	<20070404184455.GL29129@atomide.com>
	<20070404224448.0ff60ed2@the-village.bc.nu>
	<20070405132144.GC24297@atomide.com>
	<adar6qybx4y.fsf@cisco.com>
	<20070405180334.GW24297@atomide.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm, yeah I'll see if I could group them a bit. The problem there
> is that the patch series contains multiple rounds of "add and fix"
> cycles. Pretty much all the non-dependant fixes have already been
> applied, BTW.

Bear in mind that it doesn't work now, so merging some stuff and being in
a "more merged but still not yet a tree to build OMAP from" is not a
regression or a problem.

Going back some time the PA-RISC merge occurred over several months until
one day it was all there.

Alan
