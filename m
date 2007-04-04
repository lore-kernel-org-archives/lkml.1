Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbXDDVmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbXDDVmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbXDDVmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:42:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57676 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752000AbXDDVmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:42:22 -0400
Date: Wed, 4 Apr 2007 22:44:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
Message-ID: <20070404224448.0ff60ed2@the-village.bc.nu>
In-Reply-To: <20070404184455.GL29129@atomide.com>
References: <11757088774110-git-send-email-tony@atomide.com>
	<20070404182728.GK29129@atomide.com>
	<20070404113925.da221efc.randy.dunlap@oracle.com>
	<20070404184455.GL29129@atomide.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > That's only a problem when there are <too many> patches to be
> > reviewed.  Hence, do more frequent postings of fewer patches per series.
> > That will likely also get you more reviewers.
> 
> Yeah, I agree.. We've already missed two merge windows because of the
> large patch set :( The problem is that patch set just keeps growing.

The other problem is that GIT patch sets are completely useless for
merging and reviewing if you simply fire off a blast of 70 changesets.
Each time you do it at least one gets queried or a NAK and the lot go in
the bin again. Repeat 50 times...

It would be enormously helpful if instead we got say 15 small patch sets
which are independant so that a query or NAK means 14 sets get applied
this time around not zero.

Alan
