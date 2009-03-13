Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZCMSc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZCMSc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 14:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZCMScP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 14:32:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51314
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbZCMScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 14:32:14 -0400
Date: Fri, 13 Mar 2009 11:31:59 -0700 (PDT)
Message-Id: <20090313.113159.63670407.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH net-next 0/10] cxgb3: driver updates
From: David Miller <davem@davemloft.net>
In-Reply-To: <49BA07B4.30706@chelsio.com>
References: <49BA07B4.30706@chelsio.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2DIWVqu012292

From: Divy Le Ray <divy@chelsio.com>
Date: Fri, 13 Mar 2009 00:13:56 -0700

> Iâ€™m submitting 10 patches targeted for net-next-2.6.
> 
> Here is a brief description of the patch series:
> - ring receive rings door bells less aggressively
> - drop page reference when dma mapping fails
> - fix skb truesize when coalescing fragments of a jumbo frame
> - eliminate a cache miss in the GRO section of the driver
> - segregate Rx and Tx credit reclaim timers
> - poll for HW alert status when intrs would happen too frequently
> - update the xgmac hang workaround for the chip's rev 3
> - detect mac link faults
> - update the FW rev to 7.1
> - update the driver rev to 1.1.2

All applied, thanks Divy.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
