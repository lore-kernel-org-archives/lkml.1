Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbZA2JQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbZA2JQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 04:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZA2JPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 04:15:46 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:40383 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZA2JPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 04:15:46 -0500
Date: Thu, 29 Jan 2009 02:15:44 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Subject: RE: [PATCH B 06/10] OMAP3 pwrdm: add CORE SAR handling (for USBTLL
 module)
In-Reply-To: <alpine.DEB.2.00.0901290042020.32081@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.0901290212360.18004@utopia.booyaka.com>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024421.27240.95450.stgit@localhost.localdomain> <13B9B4C6EF24D648824FF11BE89671620376DEB7A5@dlee02.ent.ti.com> <alpine.DEB.2.00.0901290042020.32081@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Thu, 29 Jan 2009, Paul Walmsley wrote:

> > TLLSAR is not functional till ES3.1 (and beyound).  Is it possible to flag it this way?
> 
> Yes, it's easy in this case.  Thanks for the note.  I will send along an 
> updated patch for this.

N.B. - fixxing this required a separate change to the omap_chip flag 
system, so I'll send the two necessary patches to the linux-omap mailing 
list for further testing.

- Paul
