Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbXHYJzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbXHYJzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933577AbXHYJyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:54:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59275 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765493AbXHYJyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:54:51 -0400
Date: Sat, 25 Aug 2007 11:02:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>, <jgarzik@pobox.com>
Subject: Re: [PATCH 1/1] Ata: pata_marvell, use ioread* for iomap-ped memory
Message-ID: <20070825110244.794c8fd6@the-village.bc.nu>
In-Reply-To: <14077223792606026025@pripojeni.net>
References: <14077223792606026025@pripojeni.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007 08:54:27 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> pata_marvell, use ioread* for iomap-ped memory
> 
> read* on pci_iomapped memory is incorrect, fix it
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

Acked-by: Alan Cox <alan@redhat.com>
