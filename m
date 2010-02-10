Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0BJVF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:05:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59528
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab0BJVF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:05:57 -0500
Date: Wed, 10 Feb 2010 13:06:10 -0800 (PST)
Message-Id: <20100210.130610.132690227.davem@davemloft.net>
To: amit.kucheria@canonical.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       s.hauer@pengutronix.de, gerg@uclinux.org,
       u.kleine-koenig@pengutronix.de, amit.kucheria@verdurent.com
Subject: Re: [PATCH 0/3] net: fec fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1265396105.git.amit.kucheria@canonical.com>
References: <cover.1265396105.git.amit.kucheria@canonical.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@canonical.com>
Date: Fri,  5 Feb 2010 10:56:19 -0800

> Some fixes to the fec driver to get it to work on the Freescale i.MX5 SoC
> platform
> 
> Amit Kucheria (2):
>   fec: Add LAN8700 phy support
>   fec: Add ARCH_MX5 as a dependency
> 
> Rob Herring (1):
>   fec: fix uninitialized rx buffer usage

All applied to net-next-2.6, thanks.

