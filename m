Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbXJ1XIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbXJ1XIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 19:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbXJ1XIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 19:08:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbXJ1XI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 19:08:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc1-git4: Reported regressions from 2.6.23
Date: Mon, 29 Oct 2007 00:24:43 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710282351.56284.rjw@sisk.pl> <20071028225351.012e7569@the-village.bc.nu>
In-Reply-To: <20071028225351.012e7569@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710290024.44369.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 28 October 2007 23:53, Alan Cox wrote:
> > Subject		: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi M5229 secondary channel
> > Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> > References	: http://marc.info/?l=linux-kernel&m=119342005216716&w=2
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9252
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> 2.6.23 did not have pata_acpi. Its also not clear this is a bug in
> pata_acpi as opposed to pata_ali which knows about the ALi quirks. The
> ACPI and ATA specs sort of disagree here so I'll be trying to fix it
> anyway.

OK, but please let me keep that on the list.  It may cause some people to
experience problems that were not present before functionality-wise.
