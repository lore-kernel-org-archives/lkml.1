Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZEZQhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZEZQhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZEZQhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:37:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35079 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbZEZQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:37:09 -0400
Date: Tue, 26 May 2009 17:37:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 00/10] OMAP clock/SDRC patches on v2.6.30-rc5
Message-ID: <20090526163703.GF26713@n2100.arm.linux.org.uk>
References: <20090512235713.10349.49339.stgit@localhost.localdomain> <alpine.DEB.2.00.0905261025350.17019@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905261025350.17019@utopia.booyaka.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 10:29:52AM -0600, Paul Walmsley wrote:
> Hello Russell,
> 
> On Tue, 12 May 2009, Paul Walmsley wrote:
> 
> > This series contains OMAP clock and SDRAM controller patches against
> > v2.6.30-rc5.  If you are happy with these, Tony will merge them into
> > his for-next branch for you to pull.
> > 
> > This series includes the clk_init_one() to clk_preinit() rename that
> > we've discussed recently.  Most of the patches prepare for CORE DPLL
> > M2 rate changing support.
> 
> Any comments on these patches?

All look fine to me.
