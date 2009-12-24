Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZLXUF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZLXUF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 15:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZLXUF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 15:05:26 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:60372 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbZLXUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 15:05:25 -0500
Date: Thu, 24 Dec 2009 15:05:06 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mattia Dongili <malattia@linux.it>
Subject: Re: linux-next: manual merge of the acpi tree with Linus' tree
In-reply-to: <20091224232656.dafb0b1d.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.00.0912241502190.4159@localhost.localdomain>
References: <20091224091141.fa1cea64.sfr@canb.auug.org.au>
 <20091224093913.4f29f37b.sfr@canb.auug.org.au>
 <alpine.LFD.2.00.0912240000530.6541@localhost.localdomain>
 <20091224232656.dafb0b1d.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Simpler to just drop the offending patch:
> > 
> > a287e9f941cf4bb8c167802c0f1cf04a93bc4e4c
> > sony-laptop: remove private workqueue, use keventd instead
> > 
> > and get a properly refreshed version of that from Dmitry/Mattia later.
> 
> Yep, that would work, thanks.

FYI, I dropped that patch yesterday, and then just now included
a refreshed patch from Dmitry.  So linux-next should be conflict free now.

thanks,
Len Brown, Intel Open Source Technology Center

