Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXGDJPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXGDJPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbXGDJPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:15:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44151 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758750AbXGDJPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:15:21 -0400
Date: Wed, 4 Jul 2007 10:21:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: Libata PATA status
Message-ID: <20070704102129.44945ea8@the-village.bc.nu>
In-Reply-To: <1D2B5126-1238-48F8-B841-E8F77C9A0F1B@mac.com>
References: <20070703185116.59c8f5f5@the-village.bc.nu>
	<1D2B5126-1238-48F8-B841-E8F77C9A0F1B@mac.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd love to try to poke holes in the libata PATA support, but sadly  
> it doesn't look like any of my systems built-in ATA chipsets are  
> supported yet.  Has anyone started a rewrite of the PPC/PowerMac IDE  
> driver?  The current one is in "drivers/ide/ppc/pmac.c", and supports  
> these chipsets:

I'm not aware of anyone having done any PPC ports yet, although a couple
of people have asked and said they would look at it. Currently our
coverage is incomplete for some embedded and obscure platforms, of which
the macintrash is probably the least 'obscure'.

Alan
