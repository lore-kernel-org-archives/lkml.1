Return-Path: <linux-kernel-owner+w=401wt.eu-S1762759AbYG3PLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762759AbYG3PLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYG3PLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:11:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:50953 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbYG3PLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:11:03 -0400
Date: Wed, 30 Jul 2008 08:10:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, mcs6502@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/31] pci_ids.h, kernel 2.6.27-rc1, sort DEVICE_IDs
 within VENDOR_IDs
Message-ID: <20080730081047.067fd676@infradead.org>
In-Reply-To: <200807300723.14970.jbarnes@virtuousgeek.org>
References: <E1KO7OU-0007BT-Ff@wraith.cs.uow.edu.au>
	<20080730034255.ac5aa6c2.akpm@linux-foundation.org>
	<20080730113538.2a2422ba@lxorguk.ukuu.org.uk>
	<200807300723.14970.jbarnes@virtuousgeek.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 07:23:14 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Wednesday, July 30, 2008 3:35 am Alan Cox wrote:
> > > a) slam it into mainline immediately or
> > >
> > > b) ask you to regenerate it during the 2.6.28 merge window or
> > >
> > > c) forget the whole idea.
> >
> > I vote for (a). At some point it needs doing and the sooner we do
> > it the better. I've scanned all the diffs and they appear correct.
> > As we've seen from the MAINTAINERS file once you get errors they
> > spread rapidly.
> >
> > Acked-by: Alan Cox <alan@redhat.com>
> 
> Yeah, let's just get it over with.
> 


if this was done by a script.. can we just get that script so that you
as PCI maintainer can run that on a very regular basis?
