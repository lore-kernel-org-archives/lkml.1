Return-Path: <linux-kernel-owner+w=401wt.eu-S932827AbXFEPwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbXFEPwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932351AbXFEPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:51:57 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43016 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338AbXFEPv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:51:57 -0400
Date: Tue, 5 Jun 2007 11:51:55 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: david@dgreaves.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.22-rc4
Message-ID: <20070605155155.GI31565@havoc.gtf.org>
References: <200706051041.l55AfiHD025993@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706051041.l55AfiHD025993@harpo.it.uu.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 12:41:44PM +0200, Mikael Pettersson wrote:
> On Tue, 05 Jun 2007 10:29:43 +0100, David Greaves wrote:
> > Linus Torvalds wrote:
> > > [Linus' 2.6.22-rc4 announcement]
> >
> > Compile warnings and a new regression: hang on boot during sata_promise
> > detection... :(
> 
> Please give us some details about your sata_promise problem:
> - describe your hardware (Promise chip version, mainboard, chipset, etc)
> - which was the last kernel version prior to 2.6.22-rc4 that worked
> - the kernel messages up to the hang, if you can capture them

There is a small chance it might be that sata_promise typo fix that went
in, which will definitely change driver behavior for the chips served by
that table entry...

	Jeff



