Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbXE0Pnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbXE0Pnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbXE0Pno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:43:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53441 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755464AbXE0Pnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:43:43 -0400
Date: Sun, 27 May 2007 16:48:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] SCSI/initio conversion to PCI driver API
Message-ID: <20070527164840.61c9b6d5@the-village.bc.nu>
In-Reply-To: <46599DD9.4020408@garzik.org>
References: <20070527145200.GA17017@havoc.gtf.org>
	<20070527145955.GE17085@havoc.gtf.org>
	<46599DD9.4020408@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007 11:03:53 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Jeff Garzik wrote:
> > Prior simplifications in this patchset now permit a minimal conversion
> > to the new PCI API.
> > 
> > Further improvements and simplifications are certainly possible; those
> > should be presented in a separate patchset.
> > 
> > DO NOT APPLY (yet).  For feedback (and testers?) only.
> 
> 
> This only applies to patch #5.
> 
> Patches 1 through 4 should go upstream, IMO.

NAK all five.

There is a complete overhaul already done.

Alan
