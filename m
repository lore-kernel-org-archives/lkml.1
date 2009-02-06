Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZBFDw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZBFDw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZBFDwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:52:19 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:59957 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZBFDwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:52:18 -0500
Date: Thu, 5 Feb 2009 20:52:17 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH B 06/10] OMAP3 pwrdm: add CORE SAR handling (for USBTLL
 module)
In-Reply-To: <20090131142213.GL1394@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902052050220.8131@utopia.booyaka.com>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024421.27240.95450.stgit@localhost.localdomain> <13B9B4C6EF24D648824FF11BE89671620376DEB7A5@dlee02.ent.ti.com> <alpine.DEB.2.00.0901290042020.32081@utopia.booyaka.com>
 <alpine.DEB.2.00.0901290212360.18004@utopia.booyaka.com> <20090131142213.GL1394@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sat, 31 Jan 2009, Russell King - ARM Linux wrote:

> On Thu, Jan 29, 2009 at 02:15:44AM -0700, Paul Walmsley wrote:
> > Hi Richard,
> > 
> > On Thu, 29 Jan 2009, Paul Walmsley wrote:
> > 
> > > > TLLSAR is not functional till ES3.1 (and beyound).  Is it possible to flag it this way?
> > > 
> > > Yes, it's easy in this case.  Thanks for the note.  I will send along an 
> > > updated patch for this.
> > 
> > N.B. - fixxing this required a separate change to the omap_chip flag 
> > system, so I'll send the two necessary patches to the linux-omap mailing 
> > list for further testing.
> 
> I'll hold off on this patch then.

The patches that obsolete patch B 06 have lasted a week on linux-omap@vger 
without any comment, so am passing them along in subsequent E-mails.


- Paul
