Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbYCXGvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbYCXGvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 02:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYCXGvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 02:51:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48055
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753318AbYCXGvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 02:51:11 -0400
Date: Sun, 23 Mar 2008 23:51:10 -0700 (PDT)
Message-Id: <20080323.235110.197600762.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com,
       lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SCTP: fix compile warning building without CONFIG_IPV6
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E74608.7080007@cn.fujitsu.com>
References: <47E74608.7080007@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m2O6pfnq007911

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Mon, 24 Mar 2008 14:11:20 +0800

> include/net/sctp/sctp.h: In function â€˜sctp_v6_pf_initâ€™:
> include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
> 
> This warning repeats several times.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Fixed in net-2.6 for several days already.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
