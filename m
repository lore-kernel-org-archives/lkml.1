Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbZEZWEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbZEZWEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZEZWEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:04:45 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52321 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZEZWEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:04:44 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19+ArvYZkdrMukAiChRDumz
Date: Tue, 26 May 2009 15:04:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/SDRC patches on v2.6.30-rc5
Message-ID: <20090526220431.GF11865@atomide.com>
References: <20090512235713.10349.49339.stgit@localhost.localdomain> <alpine.DEB.2.00.0905261025350.17019@utopia.booyaka.com> <20090526163703.GF26713@n2100.arm.linux.org.uk> <alpine.DEB.2.00.0905261050560.17019@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905261050560.17019@utopia.booyaka.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [090526 09:53]:
> On Tue, 26 May 2009, Russell King - ARM Linux wrote:
> 
> > On Tue, May 26, 2009 at 10:29:52AM -0600, Paul Walmsley wrote:
> > > Hello Russell,
> > > 
> > > On Tue, 12 May 2009, Paul Walmsley wrote:
> > > 
> > > > This series contains OMAP clock and SDRAM controller patches against
> > > > v2.6.30-rc5.  If you are happy with these, Tony will merge them into
> > > > his for-next branch for you to pull.
> > > > 
> > > > This series includes the clk_init_one() to clk_preinit() rename that
> > > > we've discussed recently.  Most of the patches prepare for CORE DPLL
> > > > M2 rate changing support.
> > > 
> > > Any comments on these patches?
> > 
> > All look fine to me.
> 
> Great, thanks.

I've pulled these to the omap for-next branch to wait for the merge window.

Tony
