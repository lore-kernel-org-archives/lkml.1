Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0BQVic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:38:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44218
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756878Ab0BQVia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:38:30 -0500
Date: Wed, 17 Feb 2010 13:38:46 -0800 (PST)
Message-Id: <20100217.133846.181531049.davem@davemloft.net>
To: joe@perches.com
Cc: david-b@pacbell.net, gregkh@suse.de, tilman@imap.cc,
       netdev@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net-next 0/2] usbnet: Use (netdev|netif)_<level>
 macros 
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1266438216.git.joe@perches.com>
References: <20100217.000422.246530855.davem@davemloft.net>
	<cover.1266438216.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 17 Feb 2010 12:30:22 -0800

> Sorry 'bout that.
> I'll try to improve my insufficient grep and build testing.

'allmodconfig' works well for build testing.  :-)

> Added drivers/net/wireless/rndis_wlan.c to conversions.
> 
> After this conversion, no uses of the old macros exist in-tree.
> 
> Joe Perches (2):
>   usbnet: Convert dev(dbg|err|warn|info) macros to netdev_<level>
>   drivers/net/usb: Use netif_<level> logging facilities

All applied, thanks.
