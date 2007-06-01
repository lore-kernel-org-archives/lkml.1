Return-Path: <linux-kernel-owner+w=401wt.eu-S1762774AbXFARPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762774AbXFARPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761297AbXFARPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:15:10 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53770 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760572AbXFARPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:15:08 -0400
Date: Fri, 1 Jun 2007 05:38:48 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Tilman Schmidt <tilman@imap.cc>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070601123848.GH7426@kroah.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org> <46585953.80200@imap.cc> <20070526090117.dda72286.akpm@linux-foundation.org> <465A033C.3070400@imap.cc> <3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com> <20070529092543.21ccd8ad@gondolin.boeblingen.de.ibm.com> <465C5AF9.20601@imap.cc> <20070529192511.24924171@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529192511.24924171@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 07:25:11PM +0200, Cornelia Huck wrote:
> On Tue, 29 May 2007 18:55:21 +0200,
> Tilman Schmidt <tilman@imap.cc> wrote:
> 
> > Am 29.05.2007 09:25 schrieb Cornelia Huck:
> > > Could those folks that had trouble with this kernel check out whether
> > > the following patch helps?
> > 
> > Yes, that patch fixes my problem.
> > 
> > Thanks,
> > Tilman
> 
> Thanks for testing (to both of you) and again sorry for the breakage.

Can you resend me the new patch, I seem to have lost it in this thread
:(

thanks,

greg k-h
