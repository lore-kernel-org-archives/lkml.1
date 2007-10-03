Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbXJCSTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbXJCSTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXJCSTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:19:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49918 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757195AbXJCSTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:19:45 -0400
Date: Wed, 3 Oct 2007 19:24:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mike Robak" <mrobak@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: libATA error message doc
Message-ID: <20071003192453.0ed967f1@the-village.bc.nu>
In-Reply-To: <2b40bfd30710031039y70252a8bk898b102c993a92af@mail.gmail.com>
References: <2b40bfd30710031039y70252a8bk898b102c993a92af@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> (irq_stat 0x40000001)	

	IRQ status of the chip
> tag 0
	Tag (or zero for non NCQ commands)
> cmd 0xb0
	The ATA command number issued
> emask 0x1
	Internal libata error category (used to decide what to do to
recover)
> stat 0x51
	Status register of drive
> err 0x4
	Error register of drive


You want the ATA specification document from T13 (www.t13.org)

Alan
