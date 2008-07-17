Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbYGQXFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbYGQXFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYGQXFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:05:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753740AbYGQXFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:05:37 -0400
Date: Thu, 17 Jul 2008 16:04:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Zyngier <maz@misterjones.org>
Cc: green@crimea.edu, wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Compile fix for sa1100_wdt
Message-Id: <20080717160438.d707826b.akpm@linux-foundation.org>
In-Reply-To: <487C664A.2020606@misterjones.org>
References: <487C664A.2020606@misterjones.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 10:56:42 +0200
Marc Zyngier <maz@misterjones.org> wrote:

> --- a/drivers/watchdog/sa1100_wdt.c
> +++ b/drivers/watchdog/sa1100_wdt.c
> @@ -29,6 +29,7 @@
> 
>   #ifdef CONFIG_ARCH_PXA
>   #include <asm/arch/pxa-regs.h>
> +#include <asm/arch/pxa2xx-regs.h>

Your email client is performing space-stuffing.

http://mbligh.org/linuxdocs/Email/Clients/Thunderbird used to have the
repair instructions, but that server has been down for a while.

http://web.archive.org/web/20070528114159/http://mbligh.org/linuxdocs/Email/Clients/Thunderbird

has a copy.
