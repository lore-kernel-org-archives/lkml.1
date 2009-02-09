Return-Path: <linux-kernel-owner+w=401wt.eu-S1754295AbZBIBAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbZBIBAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbZBIBA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:00:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55574
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbZBIBA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:00:26 -0500
Date: Sun, 08 Feb 2009 17:00:20 -0800 (PST)
Message-Id: <20090208.170020.93114261.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/6] drivers/atm: introduce missing kfree
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0902082243200.25891@ask.diku.dk>
References: <Pine.LNX.4.64.0902082243200.25891@ask.diku.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 8 Feb 2009 22:44:16 +0100 (CET)

> Error handling code following a kmalloc should free the allocated data.
...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks Julia.
