Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab0BRCIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:08:12 -0500
Received: from smtp.knology.net ([24.214.63.101]:56897 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab0BRCIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:08:09 -0500
Subject: Re: [PATCH net-next 00/15] drivers/net: Use
 (pr|netdev|netif)_<level> macros
From: David Dillow <dave@thedillows.org>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, netdev@vger.kernel.org, zambrano@broadcom.com,
       mchan@broadcom.com, eilong@broadcom.com, romieu@fr.zoreil.com,
       shemminger@linux-foundation.org, mcarlson@broadcom.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100217.174615.133415843.davem@davemloft.net>
References: <cover.1266454575.git.joe@perches.com>
	 <20100217.174615.133415843.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 21:00:47 -0500
Message-ID: <1266458447.5719.44.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 17:46 -0800, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Wed, 17 Feb 2010 17:01:47 -0800
> 
> > Use the newly added netdev_<level> and netif_<level> logging macros
> > in some of the drivers.
> > 
> > Adds some message logging consistency.
> > 
> > pci-skeleton had a checkpatch style cleaning as well.
> 
> The sis190.c and tg3.c changes didn't apply due to other
> recent commits into the net-next-2.6 tree
> 
> I applied all of the others.

Have you pushed? I'd rather some of the typhoon ones not go in.

