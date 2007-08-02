Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbXHBLxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbXHBLxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbXHBLxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:53:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34892 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752108AbXHBLxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:53:20 -0400
Date: Thu, 2 Aug 2007 13:00:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pata_isapnp: use MODULE_DEVICE_TABLE()
Message-ID: <20070802130031.29cbdbd1@the-village.bc.nu>
In-Reply-To: <20070802110606.GA26087@havoc.gtf.org>
References: <20070802110606.GA26087@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007 07:06:07 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> 
> I found this while doing ISDN PCI API conversions...  I presume this
> omission was not intentional?
> 
> Signed-off-by: Jeff Garzik <jeff@garzik.org>

Looks fine to me 

Alan
