Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbZKLSxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbZKLSxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZKLSxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:53:23 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51042 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZKLSxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:53:22 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ZtYP2gPTX6o29y1B7bNEZ
Date: Thu, 12 Nov 2009 10:53:26 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] omap3-iommu: reorganize
Message-ID: <20091112185325.GZ24837@atomide.com>
References: <1252874472-21089-1-git-send-email-felipe.contreras@gmail.com>
 <20091111235808.GQ24837@atomide.com>
 <94a0d4530911111710p67d1de65obc328b120a549f00@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a0d4530911111710p67d1de65obc328b120a549f00@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [091111 17:10]:
> On Thu, Nov 12, 2009 at 1:58 AM, Tony Lindgren <tony@atomide.com> wrote:
> > * Felipe Contreras <felipe.contreras@gmail.com> [090913 13:41]:
> >> This way it's more object oriented and easier to see what is happening.
> >> No functional changes.
> >
> > Felipe, can you please refresh this against omap for-next branch?
> 
> I just tried and it doesn't require any changes.
> 
> Just do this and it will apply cleanly (not really part of the patch):
> - #include <mach/iommu.h>
> + #include <plat/iommu.h>

Hmm, I already deleted the original, and can't seem to find it in
the archives either. Looks only earlier versions are in the archive.

Maybe it never made it to linux-omap or linux-kernel lists. 
Can you please repost?

Thanks,

Tony
