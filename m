Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZAaOWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZAaOWn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZAaOWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:22:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54557 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZAaOWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:22:31 -0500
Date: Sat, 31 Jan 2009 14:22:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <paul@pwsan.com>
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH B 06/10] OMAP3 pwrdm: add CORE SAR handling (for USBTLL module)
Message-ID: <20090131142213.GL1394@n2100.arm.linux.org.uk>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024421.27240.95450.stgit@localhost.localdomain> <13B9B4C6EF24D648824FF11BE89671620376DEB7A5@dlee02.ent.ti.com> <alpine.DEB.2.00.0901290042020.32081@utopia.booyaka.com> <alpine.DEB.2.00.0901290212360.18004@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901290212360.18004@utopia.booyaka.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 02:15:44AM -0700, Paul Walmsley wrote:
> Hi Richard,
> 
> On Thu, 29 Jan 2009, Paul Walmsley wrote:
> 
> > > TLLSAR is not functional till ES3.1 (and beyound).  Is it possible to flag it this way?
> > 
> > Yes, it's easy in this case.  Thanks for the note.  I will send along an 
> > updated patch for this.
> 
> N.B. - fixxing this required a separate change to the omap_chip flag 
> system, so I'll send the two necessary patches to the linux-omap mailing 
> list for further testing.

I'll hold off on this patch then.
