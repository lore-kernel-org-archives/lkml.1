Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab0BRBqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:46:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49366
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab0BRBqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:46:05 -0500
Date: Wed, 17 Feb 2010 17:46:15 -0800 (PST)
Message-Id: <20100217.174615.133415843.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, zambrano@broadcom.com, mchan@broadcom.com,
       eilong@broadcom.com, romieu@fr.zoreil.com,
       shemminger@linux-foundation.org, mcarlson@broadcom.com,
       dave@thedillows.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] drivers/net: Use
 (pr|netdev|netif)_<level> macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1266454575.git.joe@perches.com>
References: <cover.1266454575.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 17 Feb 2010 17:01:47 -0800

> Use the newly added netdev_<level> and netif_<level> logging macros
> in some of the drivers.
> 
> Adds some message logging consistency.
> 
> pci-skeleton had a checkpatch style cleaning as well.

The sis190.c and tg3.c changes didn't apply due to other
recent commits into the net-next-2.6 tree

I applied all of the others.

Thanks.
