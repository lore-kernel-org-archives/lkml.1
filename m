Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZC0HR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZC0HR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZC0HRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:17:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42286
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbZC0HRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:17:15 -0400
Date: Fri, 27 Mar 2009 00:17:03 -0700 (PDT)
Message-Id: <20090327.001703.116902601.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: Add support for the OpenCores 10/100 Mbps
 Ethernet MAC.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1238062584-12685-1-git-send-email-thierry.reding@avionic-design.de>
References: <20090326080959.GA23013@avionic-design.de>
	<1238062584-12685-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>
Date: Thu, 26 Mar 2009 11:16:24 +0100

> This patch adds a platform device driver that supports the OpenCores 10/100
> Mbps Ethernet MAC.
> 
> The driver expects three resources: one IORESOURCE_MEM resource defines the
> memory region for the core's memory-mapped registers while a second
> IORESOURCE_MEM resource defines the network packet buffer space. The third
> resource, of type IORESOURCE_IRQ, associates an interrupt with the driver.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Florian Fainelli <florian@openwrt.org>

Applied, thanks.
