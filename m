Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYAYOqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYAYOqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 09:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYAYOq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 09:46:29 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:45469 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYAYOq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 09:46:27 -0500
Date: Fri, 25 Jan 2008 15:46:24 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jochen Friedrich <jochen@scram.de>
cc: "Garzik, Jeff" <jgarzik@pobox.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, linux-m68k@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>, uClinux list <uclinux-dev@uclinux.org>
Subject: Re: [PATCH] [NET]: Remove PowerPC code from fec.c
In-Reply-To: <4799F349.9090102@scram.de>
Message-ID: <Pine.LNX.4.64.0801251544480.13060@anakin>
References: <4799F349.9090102@scram.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008, Jochen Friedrich wrote:
> fec.c is only used on M68k Coldfire CPUs. Remove leftover
> PowerPC code from this driver.

As per MAINTAINERS, m68knommu is handled by:

UCLINUX (AND M68KNOMMU)
P:	Greg Ungerer
M:	gerg@uclinux.org
L:	uclinux-dev@uclinux.org  (subscribers-only)

I already forwarded a copy of your email to Greg.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
