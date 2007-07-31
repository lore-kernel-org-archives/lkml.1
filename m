Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbXGaVJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbXGaVJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXGaVJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:09:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51263
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753078AbXGaVJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:09:25 -0400
Date: Tue, 31 Jul 2007 14:09:25 -0700 (PDT)
Message-Id: <20070731.140925.25232050.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, samuel@sortiz.org, nick@fedchik.org.ua
Subject: Re: [PATCH 41] drivers/net/irda/irda-usb.c: mostly kmalloc +
 memset conversion to k[cz]alloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707312020.37331.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312020.37331.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Tue, 31 Jul 2007 20:20:37 +0200

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Like the ATM patch, this one doesn't apply cleanly.

