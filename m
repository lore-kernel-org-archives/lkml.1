Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbZEZQvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbZEZQvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZEZQvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:51:04 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:59390 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZEZQvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:51:03 -0400
Date: Tue, 26 May 2009 10:51:02 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/SDRC patches on v2.6.30-rc5
In-Reply-To: <20090526163703.GF26713@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0905261050560.17019@utopia.booyaka.com>
References: <20090512235713.10349.49339.stgit@localhost.localdomain> <alpine.DEB.2.00.0905261025350.17019@utopia.booyaka.com> <20090526163703.GF26713@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, Russell King - ARM Linux wrote:

> On Tue, May 26, 2009 at 10:29:52AM -0600, Paul Walmsley wrote:
> > Hello Russell,
> > 
> > On Tue, 12 May 2009, Paul Walmsley wrote:
> > 
> > > This series contains OMAP clock and SDRAM controller patches against
> > > v2.6.30-rc5.  If you are happy with these, Tony will merge them into
> > > his for-next branch for you to pull.
> > > 
> > > This series includes the clk_init_one() to clk_preinit() rename that
> > > we've discussed recently.  Most of the patches prepare for CORE DPLL
> > > M2 rate changing support.
> > 
> > Any comments on these patches?
> 
> All look fine to me.

Great, thanks.


- Paul
