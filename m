Return-Path: <linux-kernel-owner+w=401wt.eu-S946110AbXHMOCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946110AbXHMOCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934820AbXHMKzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:55:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47643 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S938682AbXHMKzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:55:37 -0400
Date: Mon, 13 Aug 2007 12:02:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com, akpm@linux-foundation.org
Subject: Re: [PATCH] [428/2many] MAINTAINERS - SERIAL ATA (SATA) SUBSYSTEM:
Message-ID: <20070813120221.2e70e32f@the-village.bc.nu>
In-Reply-To: <46bffbb6.4FinvGMu+SlIxG24%joe@perches.com>
References: <46bffbb6.4FinvGMu+SlIxG24%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -4077,6 +4077,7 @@ M:	jgarzik@pobox.com
>  L:	linux-ide@vger.kernel.org
>  T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>  S:	Supported
> +F:	drivers/ata/sata_*

NAK
	sata_inic is Tejun

and various others are also different
