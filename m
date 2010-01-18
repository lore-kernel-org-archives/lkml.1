Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004Ab0ARI3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0ARI3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572Ab0ARI3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:29:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59442
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab0ARI3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:29:22 -0500
Date: Mon, 18 Jan 2010 00:29:31 -0800 (PST)
Message-Id: <20100118.002931.55279267.davem@davemloft.net>
To: julia@diku.dk
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/9] drivers/net: Eliminate useless code
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1001180911080.12648@ask.diku.dk>
References: <Pine.LNX.4.64.1001161657400.28745@ask.diku.dk>
	<20100117.193140.153138395.davem@davemloft.net>
	<Pine.LNX.4.64.1001180911080.12648@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Mon, 18 Jan 2010 09:12:21 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> The variable qdev is initialized twice to the same (side effect-free)
> expression.  Drop one initialization.
> 
> A simplified version of the semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks.
