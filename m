Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab0CMUWL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 15:22:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53217
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759075Ab0CMUWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 15:22:05 -0500
Date: Sat, 13 Mar 2010 12:22:26 -0800 (PST)
Message-Id: <20100313.122226.91435148.davem@davemloft.net>
To: julia@diku.dk
Cc: mcarlson@broadcom.com, mchan@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/net/tg3.c: change the field used with the
 TG3_FLAG_10_100_ONLY constant
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.1003131000420.30245@ask.diku.dk>
References: <Pine.LNX.4.64.1003131000420.30245@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 13 Mar 2010 10:01:09 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> The constant TG3_FLAG_10_100_ONLY should be used with the tg3_flags field,
> not the tg3_flags2 field, as done elsewhere in the same file.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks a lot Julia.
