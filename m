Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0BRXnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:43:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37478
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab0BRXnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:43:47 -0500
Date: Thu, 18 Feb 2010 15:44:02 -0800 (PST)
Message-Id: <20100218.154402.202540963.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, mcarlson@broadcom.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 13/15] drivers/net/tg3.c: Use
 (pr|netdev)_<level> macro helpers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266471859.8446.256.camel@Joe-Laptop.home>
References: <cover.1266454575.git.joe@perches.com>
	<89936828c4a4c914b849cf8c96985d62fb612e55.1266454576.git.joe@perches.com>
	<1266471859.8446.256.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 17 Feb 2010 21:44:19 -0800

> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Remove #define PFX
> Use pr_<level>
> Use netdev_<level>
> Remove periods from most formats
> Coalesce long formats
> Use printk_once
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
