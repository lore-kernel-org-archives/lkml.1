Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZI2MHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZI2MHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZI2MHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:07:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbZI2MHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:07:45 -0400
Date: Tue, 29 Sep 2009 14:07:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Imre Deak <imre.deak@nokia.com>
Cc: ext Peter Huewe <PeterHuewe@gmx.de>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Jonathan McDowell <noodles@earth.li>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Mike Wege <ext-mike.wege@nokia.com>,
       "Doyu Hiroshi (Nokia-D/Helsinki)" <hiroshi.doyu@nokia.com>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video/omap:  adding __init/__exit macros to various
 drivers
In-Reply-To: <20090929091853.GC9536@localhost>
Message-ID: <alpine.LSU.2.00.0909291401060.9280@wotan.suse.de>
References: <200909290318.07309.PeterHuewe@gmx.de> <20090929091853.GC9536@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009, Imre Deak wrote:

> > Trivial patch which adds the __init/__exit macros to the module_init/
> > module_exit functions of the following drivers in media/omap:
> > drivers/video/omap/lcd_ams_delta.c
> > drivers/video/omap/lcd_mipid.c
> > 
> > Please have a look at the small patch and either pull it through
> > your tree, or please ack' it so Jiri can pull it through the trivial tree.
> > 
> > linux version v2.6.32-rc1 - linus git tree, Di 29. Sep 01:10:18 CEST 2009
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> 
> Acked-by: Imre Deak <imre.deak@nokia.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
