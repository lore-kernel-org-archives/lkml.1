Return-Path: <linux-kernel-owner+w=401wt.eu-S1763454AbXJZTXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763454AbXJZTXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760714AbXJZTX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:23:29 -0400
Received: from [81.2.110.250] ([81.2.110.250]:38985 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760198AbXJZTX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:23:27 -0400
Date: Fri, 26 Oct 2007 20:25:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi
 M5229 secondary channel
Message-ID: <20071026202559.01161aa9@the-village.bc.nu>
In-Reply-To: <200710262130.03567.arvidjaar@mail.ru>
References: <200710262130.03567.arvidjaar@mail.ru>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 21:30:02 +0400
Andrey Borzenkov <arvidjaar@mail.ru> wrote:

> Running legacy IDE drivers apparently works in DMA mode for both:

Thanks - can you send me an lspci -vvxxx off list

Alan
