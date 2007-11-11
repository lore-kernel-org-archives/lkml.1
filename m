Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbXKKUR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbXKKUR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 15:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbXKKURW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 15:17:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637AbXKKURV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 15:17:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
Date: Sun, 11 Nov 2007 21:34:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200711112058.28043.rjw@sisk.pl> <20071111200935.1384c24d@the-village.bc.nu>
In-Reply-To: <20071111200935.1384c24d@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711112134.37508.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 of November 2007, Alan Cox wrote:
> > Subject		: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi M5229 secondary channel
> > Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> > References	: http://marc.info/?l=linux-kernel&m=119342005216716&w=2
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9252
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Patch		: 
> > Note		: pata_acpi was not present in 2.6.23
> 
> As I said before pata_acpi was not present in 2.6.23 -> Not a regression.

OK, dropped.
