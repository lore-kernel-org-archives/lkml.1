Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZIOIhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZIOIhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZIOIg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:36:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37475
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbZIOIg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:36:57 -0400
Date: Tue, 15 Sep 2009 01:37:14 -0700 (PDT)
Message-Id: <20090915.013714.264392602.davem@davemloft.net>
To: wuzhangjin@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com, huhb@lemote.com, zhangfx@lemote.com,
       yanh@lemote.com
Subject: Re: [PATCH] ide: fixup for fujitsu disk
From: David Miller <davem@davemloft.net>
In-Reply-To: <1252661158-8219-1-git-send-email-wuzhangjin@gmail.com>
References: <1252661158-8219-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu <wuzhangjin@gmail.com>
Date: Fri, 11 Sep 2009 17:25:58 +0800

> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This patch will fix the following problem on Yeeloong netbook with
> fujitsu disk.
> 
> irq 14: nobody cared (try booting with the "irqpoll" option)
> Call Trace:
 ...
> References:
> 
> 1. commit 1fde02e7146d4a1bab80fd1506f9018fe71e8521 of
> git://dev.lemote.com/linux_loongson.git
> 2. 8bc1e5aa06a2a9a425c4a6795fc564cba1521487 (ide: respect quirk_drives[]
> list on all controllers)
> 
> Signed-off-by: Yan Hua <yanh@lemote.com>
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Applied, thank you.
