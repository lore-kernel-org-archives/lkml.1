Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZFWWEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZFWWEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZFWWEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:04:42 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:51208 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZFWWEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:04:41 -0400
Date: Tue, 23 Jun 2009 16:04:43 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Jean Pihet <jpihet@mvista.com>
cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for
 post-2.6.30
In-Reply-To: <200906191836.07462.jpihet@mvista.com>
Message-ID: <alpine.DEB.2.00.0906231603470.6545@utopia.booyaka.com>
References: <20090526220517.25381.75976.stgit@localhost.localdomain> <20090618054845.GC8482@atomide.com> <20090619162342.GP24573@n2100.arm.linux.org.uk> <200906191836.07462.jpihet@mvista.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean,

On Fri, 19 Jun 2009, Jean Pihet wrote:

> On Friday 19 June 2009 18:23:42 Russell King - ARM Linux wrote:
> > On Thu, Jun 18, 2009 at 08:48:47AM +0300, Tony Lindgren wrote:
> > > Paul, can you please post a git pull request for Russell on these?
> > > I think these should still go in if possible.
> > >
> > > Russell, if you think it's too late, I'll pile them up into omap
> > > for-next branch.
> >
> > Let's merge them.
> Also, can you look at '[PATCH 0/2] Allows the SDRAM self refresh to work with 
> 2 chip selects' which apply on top of Paul's SDRC patches?

I'll merge these patches into the next SDRC series for Russell and Tony.

thanks,

- Paul
