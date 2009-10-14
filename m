Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbZJNM0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbZJNM0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759632AbZJNM0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:26:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60775 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759287AbZJNM0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:26:19 -0400
Date: Wed, 14 Oct 2009 13:25:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       "Alexandros C. Couloumbis" <alex@ozo.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_sc1200: Fix crash on boot
Message-ID: <20091014132518.5dce81be@lxorguk.ukuu.org.uk>
In-Reply-To: <200910141412.29467.bzolnier@gmail.com>
References: <20091006150737.9610.81541.stgit@localhost.localdomain>
	<20091013185637.870369c8.akpm@linux-foundation.org>
	<20091014130046.0aa13166@lxorguk.ukuu.org.uk>
	<200910141412.29467.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW do you happen to know who is the current maintainer of this driver
> (ditto for other PATA drivers)?
> 
> MAINTAINERS lists only:
> 
> 	SERIAL ATA (SATA) SUBSYSTEM
> 	P:      Jeff Garzik
> 	M:      jgarzik@pobox.com
> 	L:      linux-ide@vger.kernel.org
> 	T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 	S:      Supported
> 	F:      drivers/ata/
> 	F:      include/linux/ata.h
> 	F:      include/linux/libata.h
> 
> but this driver surely ain't SATA.

The subsystem wants renaming. Patches go to Jeff who though he rarely
appears on listy and stuff keeps the tree and is doing all the submission
stuff.

Alan
