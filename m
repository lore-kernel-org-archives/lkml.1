Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbZFARTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbZFARTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbZFARSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:18:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60461 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbZFARST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:18:19 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18XYNBV4e0eqcj70rrNih2w
Date: Mon, 1 Jun 2009 10:18:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/powerdomain/SDRC patches for
	post-2.6.30
Message-ID: <20090601171806.GC4825@atomide.com>
References: <20090526220517.25381.75976.stgit@localhost.localdomain> <20090601165623.GB4825@atomide.com> <20090601170856.GF16580@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601170856.GF16580@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [090601 10:09]:
> On Mon, Jun 01, 2009 at 09:56:24AM -0700, Tony Lindgren wrote:
> > * Paul Walmsley <paul@pwsan.com> [090526 15:27]:
> > > Hello Russell,
> > > 
> > > here is the next set of OMAP clock patches for review for the
> > > post-2.6.30 merge window.  They apply on top of the previous set
> > > ("OMAP clock/SDRC patches on v2.6.30-rc5").  If you're happy with
> > > these patches, Tony will queue them up into his for-next branch.
> > 
> > Looks like Russell now has all the omap for-next merged to his
> > devel branch. Only this series is missing and the omap4 SMP patches.
> 
> This series I've avoided looking at due to lack of time.  I only just
> got around to sorting through your patches from the last two weeks
> last Thursday/Friday, and I've spent Sunday evening and today boot
> testing and debugging what's been merged on my LDP platform.

Yeah it's been busy with omap patches again. The good news is that
after 2.6.30 we should be able to have linux-omap tree just contain
patches for the upcoming merge windows!
 
> It'll be a week or so before I look at OMAP again.

Thanks for the update. Sounds like we still have some time to deal
with the remaining two patch sets.

Regards,

Tony
