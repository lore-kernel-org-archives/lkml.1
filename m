Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZBIQwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZBIQwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 11:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZBIQwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 11:52:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:53031 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbZBIQwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 11:52:08 -0500
Date: Mon, 9 Feb 2009 08:49:05 -0800
From: Greg KH <gregkh@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, stable@kernel.org
Subject: Re: patch acpi-remove-locking-from-pm1x_sts-register-reads.patch
	added to 2.6.28-stable tree
Message-ID: <20090209164905.GA5420@suse.de>
References: <20090208211932.4CAB349019@coco.kroah.org> <200902090124.44228.s.L-H@gmx.de> <20090209162402.GA13931@suse.de> <20090209083050.361e997d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209083050.361e997d@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 08:30:50AM -0800, Arjan van de Ven wrote:
> On Mon, 9 Feb 2009 08:24:02 -0800
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Mon, Feb 09, 2009 at 01:24:43AM +0100, Stefan Lippers-Hollmann
> > wrote:
> > > Hi
> > > 
> > > On Sonntag, 8. Februar 2009, gregkh@suse.de wrote:
> > > > 
> > > > This is a note to let you know that we have just queued up the
> > > > patch titled
> > > > 
> > > >     Subject: ACPI: remove locking from PM1x_STS register reads
> 
> 
> why is this -stable material?
> this is a performance improvement....

It is, and not a bugfix?  If so, I'll drop it.

thanks,

greg k-h
