Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbXLACOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbXLACOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 21:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbXLACOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 21:14:17 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:54774 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbXLACOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 21:14:17 -0500
Date: Fri, 30 Nov 2007 21:14:14 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Simon Arlott <simon@fire.lp0.eu>,
       Francois Romieu <romieu@fr.zoreil.com>,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: Bogus PCI vendor ID
Message-ID: <20071201021414.GA4375@fattire.cabal.ca>
References: <473F0FE0.3010501@tragetaschen.dyndns.org> <20071117184030.GA5541@electric-eye.fr.zoreil.com> <53552.simon.1195474940@5ec7c279.invalid> <20071119092736.7cb21231@freepuppy.rosehill> <20071124202815.fed44890.akpm@linux-foundation.org> <47496C43.4090109@tragetaschen.dyndns.org> <20071126165353.GA24825@fattire.cabal.ca> <474DD274.5060909@tragetaschen.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474DD274.5060909@tragetaschen.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 09:41:24PM +0100, Kai Ruhnau wrote:
> Kyle McMartin wrote:
> > On Sun, Nov 25, 2007 at 01:36:19PM +0100, Kai Ruhnau wrote:
> >   
> >> If this is the same like the kernel option 'pci=conf1', that fixes the
> >> vendor IDs.
> >>     
> >
> > Same effect. Ubuntu and many other distros are shipping kernels with
> > MMCONFIG off by default for reasons like this. Check to see if you have
> > an updated BIOS from your motherboard manufacturer?
> >   
> 
> No, nothing available there. (OEM board, running fine under Vista, I
> don't expect to get support there...)
> 

Ah, that's interesting, as Vista is supposed to require working MMCONFIG
support to be certified.

regards,
	Kyle
