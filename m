Return-Path: <linux-kernel-owner+w=401wt.eu-S1423120AbXDXVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423120AbXDXVGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423123AbXDXVGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:06:38 -0400
Received: from nlpi012.sbcis.sbc.com ([207.115.36.41]:33663 "EHLO
	nlpi012.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423120AbXDXVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:06:37 -0400
X-ORBL: [67.117.73.34]
Date: Tue, 24 Apr 2007 21:06:08 +0000
From: Tony Lindgren <tony@atomide.com>
To: Carlos Aguiar <carlos.aguiar@indt.org.br>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org,
       "Anderson F. Briglia" <anderson.briglia@indt.org.br>
Subject: Re: [PATCH 0/3] Aligning omap.c from Linux-OMAP to mainline kernel
Message-ID: <20070424210607.GA7700@atomide.com>
References: <462E6DE5.7090206@indt.org.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462E6DE5.7090206@indt.org.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Carlos Aguiar <carlos.aguiar@indt.org.br> [070424 21:01]:
> Hi Pierre,
> 
> Find in this series the pending patches from Linux-OMAP to mainline for
> drivers/mmc/omap.c
> 
> The patches series was applied against Linus' tree 2.6.21-rc7-git6.
> 
> Anyway, it was tested on OMAP H2 (using omap_h2_1610_defconfig available
> on linus' tree).

Can you please repost them by adding a second From: line above the
commit message to the top of the mail?

That way the commit goest to the original author when Pierre applies
them to his tree.

So, for example:

...

From: Arnaud Patard <arnaud.patard@rtp-net.org>

This patch add a missing '\n' at the end of the 'cover is open' string
in mmc_omap_switch_handler().

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>

...

Regards,

Tony
