Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758905AbYLPXnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYLPXnx (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbYLPXnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:43:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35306
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756479AbYLPXnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:43:41 -0500
Date: Tue, 16 Dec 2008 15:43:43 -0800 (PST)
Message-Id: <20081216.154343.142632693.davem@davemloft.net>
To: julia@diku.dk
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/11] drivers/net/hamradio: Move a dereference below a
 NULL test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0812161613320.20444@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812161613320.20444@pc-004.diku.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 16 Dec 2008 16:13:50 +0100 (CET)

> In each case, if the NULL test is necessary, then the dereference should be
> moved below the NULL test.
> 
> The semantic patch that makes this change is as follows:
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied to net-next-2.6

