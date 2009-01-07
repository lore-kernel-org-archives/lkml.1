Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZAGKS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZAGKS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZAGKSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:18:18 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:63306 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbZAGKSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:18:17 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+zuJUj3OhX1203I3Qj41Sr
Date: Wed, 7 Jan 2009 12:18:13 +0200
From: Tony Lindgren <tony@atomide.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org, Madhusudhan Chikkature <madhu.cr@ti.com>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 5/5] omap mmc: Add new omap hsmmc controller for 2430
	and 34xx
Message-ID: <20090107101812.GD27566@atomide.com>
References: <20081207213617.10456.43951.stgit@localhost> <20081207215139.10456.46405.stgit@localhost> <20081221171700.3efc0c3a@mjolnir.drzeus.cx> <20081229165531.GG22065@atomide.com> <20081230083624.GD7850@atomide.com> <20081231185928.2ba325e6@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231185928.2ba325e6@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pierre Ossman <drzeus-mmc@drzeus.cx> [081231 19:59]:
> On Tue, 30 Dec 2008 10:36:26 +0200
> Tony Lindgren <tony@atomide.com> wrote:
> 
> > 
> > Here's one more version that leaves out the unnecessary TWL4030
> > dependency in the Kconfig as pointed out by David Brownell.
> > 
> 
> Looks ok.
> 
> Acked-by: Pierre Ossman <drzeus@drzeus.cx>

Thanks, I'll queue it up with Russell with one change
to include <mach/dma.h> instead of <asm/dma.h>.

All further patches to this driver will come to you via
LKML.

Regards,

Tony

> 
> -- 
>      -- Pierre Ossman
> 
>   Linux kernel, MMC maintainer        http://www.kernel.org
>   rdesktop, core developer          http://www.rdesktop.org
> 
>   WARNING: This correspondence is being monitored by the
>   Swedish government. Make sure your server uses encryption
>   for SMTP traffic and consider using PGP for end-to-end
>   encryption.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
