Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0BAOLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:11:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35181 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab0BAOLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:11:08 -0500
Date: Mon, 1 Feb 2010 15:10:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux@arm.linux.org.uk, eric.y.miao@gmail.com, tony@atomide.com,
       linux-kernel@vger.kernel.org, khilman@deeprootsystems.com,
       lethal@linux-sh.org, ben-linux@fluff.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/06] ARM: SuperH Mobile ARM, sh7367 and G3EVM support
Message-ID: <20100201141057.GB1340@ucw.cz>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se> <20100128124038.8982.82995.sendpatchset@rxone.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128124038.8982.82995.sendpatchset@rxone.opensource.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch contains the SuperH Mobile ARM base support together
> with sh7367 CPU and G3EVM board support. Only timer, serial
> console and NOR flash are supported at this point. Patches for
> the interrupt controller, pinmux support, clock framework and
> runtime pm will be submitted as feature patches on top of this.
...
>  arch/arm/mach-shmobile/Makefile.boot              |    9 
>  arch/arm/mach-shmobile/board-g3evm.c              |  127 +++++++++++

I guess I'm confused. I thought superh was architecture, like arm
is.....?

I superh actually manufacturer? And can we get shorter name than
mach-shmobile? mach-shm?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
