Return-Path: <linux-kernel-owner+w=401wt.eu-S1422833AbXCOGHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422833AbXCOGHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422838AbXCOGHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:07:32 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3953 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422833AbXCOGHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:07:30 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc3-mm1
Date: Thu, 15 Mar 2007 07:09:40 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <200703142006.04547.m.kozlowski@tuxland.pl> <20070314170738.d5d35c06.akpm@linux-foundation.org>
In-Reply-To: <20070314170738.d5d35c06.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703150709.40967.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

> > 	Today after +- 24h of uptime I found some more page allocation
> > failures ('eth1: Can't allocate skb for Rx'). You'll find more here:
> > 
> > http://tuxland.pl/misc/2.6.21-rc3-mm1-page-allocation-failure.txt
> > 
> > System wasn't doing anything unusual, as usual ;-) X, some p2p 
> > software, firefox+flash playing music.
> > 
> 
> Do other kernels do this, or is 2.6.21-rc3-mm1 worse?

I've never seen page allocation failures before 2.6.21-rc3-mm1 (first
khubd with the mouse thing now this).
 
> It is of course a non-fatal problem and will inevitably happen sometimes,
> but we would like the VM to be able to minimise the occurrence of this
> problem.

True. System runs as nothing happened. It just pops out from time to time.

> I think we were rather hoping that Mel's anti-fragmentation work would
> improve things.

Thanks,

	Mariusz Kozlowski
