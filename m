Return-Path: <linux-kernel-owner+w=401wt.eu-S937753AbXHMVoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937753AbXHMVoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXHMVnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:43:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3767 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbXHMVns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:43:48 -0400
Subject: Re: [PATCH] [428/2many] MAINTAINERS - SERIAL ATA (SATA) SUBSYSTEM:
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com, akpm@linux-foundation.org
In-Reply-To: <20070813120221.2e70e32f@the-village.bc.nu>
References: <46bffbb6.4FinvGMu+SlIxG24%joe@perches.com>
	 <20070813120221.2e70e32f@the-village.bc.nu>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 14:43:35 -0700
Message-Id: <1187041415.10249.332.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 12:02 +0100, Alan Cox wrote:
> > @@ -4077,6 +4077,7 @@ M:	jgarzik@pobox.com
> >  L:	linux-ide@vger.kernel.org
> >  T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> >  S:	Supported
> > +F:	drivers/ata/sata_*
> 
> NAK
> 	sata_inic is Tejun
> 
> and various others are also different

How does adding

X:	file patterns to exclude

and updating the script sound?

