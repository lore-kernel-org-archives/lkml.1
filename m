Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbZFBIem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbZFBIem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbZFBIef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:34:35 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:39681 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759429AbZFBIee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:34:34 -0400
X-Greylist: delayed 1515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2009 04:34:34 EDT
Date: Tue, 2 Jun 2009 10:09:27 +0200
From: Marc Zyngier <maz@misterjones.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Marc Zyngier <maz@wild-wind.fr.eu.org>, linux-kernel@vger.kernel.org,
       Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: [PATCH] eisa.ids: Add Network Peripherals FDDI boards
Message-ID: <20090602100927.1fbdd090@life-in-the-fast-lane>
In-Reply-To: <20090601192823.68befe31.akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0905310041200.15490@ftp.linux-mips.org>
	<20090601192823.68befe31.akpm@linux-foundation.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.210.249.81
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, macro@linux-mips.org, maz@wild-wind.fr.eu.org, linux-kernel@vger.kernel.org, Andries.Brouwer@cwi.nl
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 19:28:23 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 31 May 2009 00:54:26 +0100 (BST) "Maciej W. Rozycki"
> <macro@linux-mips.org> wrote:
> 
> >  Add EISA IDs for Network Peripherals FDDI boards.  Descriptions
> > taken from the respective EISA configuration files.
> > 
> > Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> > ---
> >  It's unlikely we'll ever support these cards, the problem being
> > the lack of documentation.  Assuming the policy for the EISA ID
> > database is the same as for PCI I'm sending these entries for the
> > sake of completeness.
> > 
> >  Please apply.
> > 
> >   Maciej
> > 
> > patch-mips-2.6.27-rc8-20081004-npi-eisa-0
> > Index: linux-mips-2.6.27-rc8-20081004-dolch/drivers/eisa/eisa.ids
> > ===================================================================
> > --- linux-mips-2.6.27-rc8-20081004-dolch.orig/drivers/eisa/eisa.ids
> > +++ linux-mips-2.6.27-rc8-20081004-dolch/drivers/eisa/eisa.ids
> 
> Gee.  Nobody has altered that file in six years.  Then again, few new
> EISA cards have been designed in that time...
> 

Oh well, maybe it is worth it, if only for the archaeological value...

Signed-off-by: Marc Zyngier <maz@misterjones.org>

	M.
-- 
We don't mess around.
