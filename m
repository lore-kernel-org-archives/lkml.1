Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbXLPAfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbXLPAfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 19:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbXLPAfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 19:35:12 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:51833 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbXLPAfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 19:35:11 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+wJwYMLIVe1oqt052F7dcg
Date: Sat, 15 Dec 2007 16:35:06 -0800
From: Tony Lindgren <tony@atomide.com>
To: Dirk Behme <dirk.behme@googlemail.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: Change mailing list for OMAP in MAINTAINERS
Message-ID: <20071216003505.GG7388@atomide.com>
References: <47637892.1000102@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47637892.1000102@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dirk Behme <dirk.behme@googlemail.com> [071214 22:48]:
>
> OMAP has now a list at vger.
>
> Signed-off-by: Dirk Behme <dirk.behme@gmail.com>
>

> Index: linux-osk/MAINTAINERS
> ===================================================================
> --- linux-osk.orig/MAINTAINERS
> +++ linux-osk/MAINTAINERS
> @@ -3683,7 +3683,7 @@ S:      Maintained
>  
>  TI OMAP MMC INTERFACE DRIVER
>  P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
> -M:	linux-omap-open-source@linux.omap.com (subscribers only)
> +M:	linux-omap@vger.kernel.org
>  W:	http://linux.omap.com
>  W:	http://www.muru.com/linux/omap/
>  S:	Maintained
> 
> 

Pushing today. Carlos, can you please add this to your upstream MMC
patch series also?

Regards,

Tony
