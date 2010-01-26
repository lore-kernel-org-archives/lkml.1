Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294Ab0AZMsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab0AZMsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433Ab0AZMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:48:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56416 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0AZMsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:48:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garrett <jeff@jgarrett.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
Date: Tue, 26 Jan 2010 13:48:59 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <hE3x9c-4KZM.A.tpF.EKMXLB@chimera> <20100126071912.GA7543@jgarrett.org>
In-Reply-To: <20100126071912.GA7543@jgarrett.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001261348.59508.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Jeff Garrett wrote:
> On Sun, Jan 24, 2010 at 11:04:38PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15124
> > Subject		: PCI host bridge windows ignored (works with pci=use_crs)
> > Submitter	: Jeff Garrett <jeff@jgarrett.org>
> > Date		: 2010-01-13 5:37 (12 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126336296600307&w=4
> > Handled-By	: Yinghai Lu <yinghai@kernel.org>
> > 		  Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> This regression should still be listed.  No patch to test yet.

Thanks for the update.

IIRC, we already know how to fix this ...

Rafael
