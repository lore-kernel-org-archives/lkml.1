Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbXGOHzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbXGOHzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 03:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbXGOHzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 03:55:07 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48562 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbXGOHzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 03:55:05 -0400
Subject: Re: [PATCH] MAINTAINERS: Add maintainers for power supply
	subsystem and drivers (was [PATCH] pda_power: clean up irq, timer, return
	usage)
From: David Woodhouse <dwmw2@infradead.org>
To: cbou@mail.ru
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <20070715010256.GA6167@zarina>
References: <20070714231204.GA23582@havoc.gtf.org>
	 <20070715010256.GA6167@zarina>
Content-Type: text/plain
Date: Sun, 15 Jul 2007 08:54:56 +0100
Message-Id: <1184486096.2860.1.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 05:02 +0400, Anton Vorontsov wrote:
> On Sat, Jul 14, 2007 at 07:12:04PM -0400, Jeff Garzik wrote:
> > P.S.  Where are the MAINTAINERS entries for this driver, and
> > drivers/power in general?
> 
> Collecting acks. David?
> 
> From: Anton Vorontsov <cbou@mail.ru>
> Subject: [PATCH] MAINTAINERS: Add maintainers for power supply subsystem and drivers
> 
> Signed-off-by: Anton Vorontsov <cbou@mail.ru>

Looks good to me; except...

> +T:	git git.infradead.org/~cbou/battery2-2.6.git
> +T:	git git.infradead.org/~dwmw2/battery-2.6.git

Let's just use a single tree. I created
git://git.infradead.org/battery-2.6.git which is group-writable.
(it's in /srv/git on bombadil)

-- 
dwmw2

