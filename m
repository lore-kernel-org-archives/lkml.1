Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZLND73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZLND73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZLND7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:59:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34158
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622AbZLND6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:58:13 -0500
Date: Sun, 13 Dec 2009 19:58:15 -0800 (PST)
Message-Id: <20091213.195815.245417086.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: chripell@fsfe.org, wg@grandegger.com, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: CAN_MCP251X should depend on HAS_DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0912132008100.21225@ayla.of.borg>
References: <alpine.DEB.2.00.0912132008100.21225@ayla.of.borg>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 13 Dec 2009 20:11:06 +0100 (CET)

> When building for Sun 3:
> 
> drivers/net/can/mcp251x.c:1074: undefined reference to `dma_free_coherent'
> drivers/net/can/mcp251x.c:976: undefined reference to `dma_alloc_coherent'
> drivers/net/can/mcp251x.c:1050: undefined reference to `dma_free_coherent'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
