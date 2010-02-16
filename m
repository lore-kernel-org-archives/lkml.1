Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab0BPXQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:16:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32822
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933354Ab0BPXQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:16:41 -0500
Date: Tue, 16 Feb 2010 15:16:56 -0800 (PST)
Message-Id: <20100216.151656.123276889.davem@davemloft.net>
To: lrodriguez@atheros.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, espy@canonical.com,
       ken.wu@atheros.com, graham.richards@atheros.com, scott.tan@atheros.com,
       mcgrof@gmail.com, chris.snook@gmail.com
Subject: Re: [PATCH] atl1c: Add support for Atheros AR8152 and AR8152
From: David Miller <davem@davemloft.net>
In-Reply-To: <1265934812-14157-1-git-send-email-lrodriguez@atheros.com>
References: <1265934812-14157-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 11 Feb 2010 19:33:32 -0500

> AR8151 is a Gigabit Ethernet device. AR8152 devices are
> Fast Ethernet devices, there are two revisions, a 1.0
> and a 2.0 revision.
> 
> This has been tested against these devices:
> 
> Driver	Model-name	vendor:device	Type
> atl1c 	AR8131		1969:1063	Gigabit Ethernet
> atl1c	AR8132		1969:1062	Fast Ethernet
> atl1c	AR8151(v1.0)	1969:1073	Gigabit Ethernet
> atl1c	AR8152(v1.1)	1969:2060	Fast Ethernet
> 
> This device has no hardware available yet so it goes untested,
> but it should work:
> 
> atl1c	AR8152(v2.0)	1969:2062	Fast Ethernet
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Applied to net-next-2.6, thanks.

