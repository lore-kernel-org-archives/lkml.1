Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYDJLy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYDJLy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 07:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYDJLyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 07:54:18 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33447 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754268AbYDJLyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 07:54:17 -0400
Date: Thu, 10 Apr 2008 12:32:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [BUG] linux-next: Tree for April 10 - kernel panic while
 loading ata driver on powermac
Message-ID: <20080410123230.7203f626@core>
In-Reply-To: <47FDEFC8.9070105@garzik.org>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
	<47FDEAFA.10407@linux.vnet.ibm.com>
	<47FDEFC8.9070105@garzik.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 06:45:28 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Kamalesh Babulal wrote:
> > Hi Stephen,
> > 
> > The next-20080410 kernel panics while bootup over the PowerMac G5 box, while
> > loading the ATA driver.
> 
> IDE driver, you mean.

Jeff - we may in the kernel world use IDE v ATA to distinguish between
the two drivers but both are still ATA drives and I don't think its too
fair to respond this way, especially to someone who has gone to the
trouble of capturing a very good trace.

Alan
