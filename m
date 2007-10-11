Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbXJKKOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbXJKKOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbXJKKO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:14:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43556 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755371AbXJKKO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:14:26 -0400
Date: Thu, 11 Oct 2007 11:19:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Philipp Wollermann <philipp@igowo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: IDE DMA doesn't work with pata_via and compact flash card
Message-ID: <20071011111911.0d322827@the-village.bc.nu>
In-Reply-To: <470DCB24.8090500@igowo.de>
References: <470DCB24.8090500@igowo.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ones, when using DMA. Turning off DMA for the old IDE drivers or 
> patching ata_generic to handle my IDE controller and then deactivating 
> DMA in the BIOS works, but then disk I/O is unbelievable slow.. do you 
> have any idea how to fix it, so that DMA works?

Does your CF/IDE adapter support DMA ?
