Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbZIPSKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbZIPSKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbZIPSK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:10:29 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59198 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751845AbZIPSK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:10:29 -0400
Date: Wed, 16 Sep 2009 20:10:18 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joe Perches <joe@perches.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-owner@lists.infradead.org
Subject: Re: [PATCH] MAINTAINERS: Move ARM lists to infradead
Message-ID: <20090916181018.GA19728@Chamillionaire.breakpoint.cc>
References: <1253117388.2567.17.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1253117388.2567.17.camel@Joe-Laptop.home>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joe Perches | 2009-09-16 09:09:48 [-0700]:

>Signed-off-by: Joe Perches <joe@perches.com>
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 9117b65..d5a14ff 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -497,7 +497,7 @@ F:	arch/arm/include/asm/floppy.h
> 
> ARM PORT
> M:	Russell King <linux@arm.linux.org.uk>
>-L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
>+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> W:	http://www.arm.linux.org.uk/

As far as I remember David moved the list over to infradead and the list no
longer moderated. Did this change?

Sebastian
