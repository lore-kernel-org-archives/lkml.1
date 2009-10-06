Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZJFIkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZJFIkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZJFIkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:40:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57804
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716AbZJFIkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:40:07 -0400
Date: Tue, 06 Oct 2009 01:40:01 -0700 (PDT)
Message-Id: <20091006.014001.227720618.davem@davemloft.net>
To: bebarino@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, zbr@ioremap.net,
       philipp.reisner@linbit.com
Subject: Re: [PATCH] connector: Fix incompatible pointer type warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1254817417-16157-1-git-send-email-bebarino@gmail.com>
References: <1254817417-16157-1-git-send-email-bebarino@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n968fw16010062

From: Stephen Boyd <bebarino@gmail.com>
Date: Tue,  6 Oct 2009 01:23:37 -0700

> Commit 7069331 (connector: Provide the sender's credentials to the
> callback, 2009-10-02) changed callbacks to take two arguments but missed
> this one.
> 
> drivers/connector/cn_proc.c: In function â€˜cn_proc_initâ€™:
> drivers/connector/cn_proc.c:263: warning: passing argument 3 of
> â€˜cn_add_callbackâ€™ from incompatible pointer type
> 
> Signed-off-by: Stephen Boyd <bebarino@gmail.com>

Applied, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
