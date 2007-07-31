Return-Path: <linux-kernel-owner+w=401wt.eu-S1764516AbXGaVSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764516AbXGaVSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbXGaVR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:17:57 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4348 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbXGaVRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:17:55 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 41] drivers/net/irda/irda-usb.c: mostly kmalloc + memset conversion to k[cz]alloc
Date: Tue, 31 Jul 2007 23:17:55 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, samuel@sortiz.org, nick@fedchik.org.ua
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312020.37331.m.kozlowski@tuxland.pl> <20070731.140925.25232050.davem@davemloft.net>
In-Reply-To: <20070731.140925.25232050.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312317.55885.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
> Like the ATM patch, this one doesn't apply cleanly.

Ok I'll give another k[czm]alloc run right after -mm2 shows up.

Thanks,

	Mariusz
