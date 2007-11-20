Return-Path: <linux-kernel-owner+w=401wt.eu-S1763951AbXKTWsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763951AbXKTWsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758888AbXKTWsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:48:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45820 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758651AbXKTWsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:48:09 -0500
Date: Tue, 20 Nov 2007 22:30:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: "Jonathan McDowell" <noodles@earth.li>,
       "James Smart" <James.Smart@Emulex.Com>, <linux-scsi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Greg Kroah-Hartman" <gregkh@suse.de>,
       <Matt_Domsch@dell.com>
Subject: Re: [PATCH] Unify sysfs filenames for firmware version
Message-ID: <20071120223003.70b9e37d@the-village.bc.nu>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAD01@otce2k301.adaptec.com>
References: <20071120133824.GD31112@earth.li>
	<47430CCE.50701@emulex.com>
	<20071120171454.GH31112@earth.li>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01FEAC9B@otce2k301.adaptec.com>
	<20071120200212.GI31112@earth.li>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01FEAD01@otce2k301.adaptec.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Management stuff always seems to be tied to a single card. It's one of
> > the things that puts me off hardware RAID.
> 
> There are 113 cards this driver works for in concert. Maybe my tail
> feathers are showing ;->

You might want to mention the card firmware in question run on 3 or 4
entirely different processors too

> > Do the management folks actually have some ideas about what sort of
> > interface they'd like in sysfs?
> 
> Simple answer:
> 	No
> 
> Detailed answer (I digress):

Linuxy answer:

Something like netlink

Alan
