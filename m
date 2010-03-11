Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305Ab0CKQwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:52:45 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:54143 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247Ab0CKQwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:52:44 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19zZFevME9U8XvNkZ4Y79oz
Date: Thu, 11 Mar 2010 08:53:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Message-ID: <20100311165359.GF2900@atomide.com>
References: <20100311151819.7c370c92.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311151819.7c370c92.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [100310 20:15]:
> Hi Tomi,
> 
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> drivers/video/omap2/vram.c between commit
> 4ff6baf45cd23593592e5786ccd607bdc8785f4c ("omap: Fix compile for
> early_param and omap_smc1") from the omap tree and commit
> 5c1f96f4cffbdde9e194f3ae5373953f3fa12836 ("OMAP: DSS2: VRAM: Fix
> early_param for vram") from the omap_dss2 tree.
> 
> Just two versions of the same fix to omap_vram_early_vram().  I used the
> omap tree version.

I'll split my patch in two parts, and let Tomi queue this fix.

Regards,

Tony
