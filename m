Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZFRHtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZFRHtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZFRHtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:49:10 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60263 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZFRHtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:49:09 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/rcAxZUWRAuXQeJBJw4lLr
Date: Thu, 18 Jun 2009 08:48:47 +0300
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for
	post-2.6.30
Message-ID: <20090618054845.GC8482@atomide.com>
References: <20090526220517.25381.75976.stgit@localhost.localdomain> <alpine.DEB.2.00.0906090110580.32281@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906090110580.32281@utopia.booyaka.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [090609 10:14]:
> Hello Russell,
> 
> On Tue, 26 May 2009, Paul Walmsley wrote:
> 
> > here is the next set of OMAP clock patches for review for the
> > post-2.6.30 merge window.  They apply on top of the previous set
> > ("OMAP clock/SDRC patches on v2.6.30-rc5").  If you're happy with
> > these patches, Tony will queue them up into his for-next branch.
> > 
> > This series completes basic support for OMAP3 CORE DVFS.  A few other
> > minor bugs are fixed by the off-by-one patch and the GPIO debounce
> > clock patch.
> 
> Any comments on these patches?

Paul, can you please post a git pull request for Russell on these?
I think these should still go in if possible.

Russell, if you think it's too late, I'll pile them up into omap
for-next branch.

Regards,

Tony
