Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab0BRXn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:43:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37483
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687Ab0BRXny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:43:54 -0500
Date: Thu, 18 Feb 2010 15:44:09 -0800 (PST)
Message-Id: <20100218.154409.154475074.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, romieu@fr.zoreil.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 09/15] drivers/net/sis190.c: Use
 (pr|netdev|netif)_<level> macro helpers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1266472817.8446.258.camel@Joe-Laptop.home>
References: <cover.1266454575.git.joe@perches.com>
	<a9449fa4b0219cd2e0699f3afe4f8ca811b72843.1266454576.git.joe@perches.com>
	<1266472817.8446.258.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 17 Feb 2010 22:00:17 -0800

> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Remove #define PFX
> Use pr_<level>
> Use netdev_<level>
> Use netif_<level> and netif_msg_<test>
> Remove local #define net_<test> macros
> Remove periods from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
