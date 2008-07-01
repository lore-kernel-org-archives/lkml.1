Return-Path: <linux-kernel-owner+w=401wt.eu-S1762885AbYGABUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885AbYGABUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYGABUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:20:35 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:23509 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbYGABUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:20:34 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 7/13] viafb: iface.c, iface.h, ioctl.c, ioctl.h
Date: Tue, 1 Jul 2008 09:20:31 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7D07@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080630103939.23a24435@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 7/13] viafb: iface.c, iface.h, ioctl.c, ioctl.h
Thread-Index: AcjaoJjgbuPtQHU1QD+fliO/WtyDJwAd6jaA
From: <JosephChan@via.com.tw>
To: <alan@lxorguk.ukuu.org.uk>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 01 Jul 2008 01:20:32.0488 (UTC) FILETIME=[A8086680:01C8DB18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m611Kkfq007005

Alan,

Thanks to remind.
Is it good to add viafb_ , ex: viafb_get_memsize(void)?
It would be great to have your comment. Thanks again.

BRs,
Joseph Chan 

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Monday, June 30, 2008 5:40 PM
To: Joseph Chan
Cc: Joseph Chan; linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; geert@linux-m68k.org
Subject: Re: [PATCH 7/13] viafb: iface.c, iface.h, ioctl.c, ioctl.h


> +/* Get frame buffer size from VGA BIOS */
> +
> +unsigned int get_memsize(void)

Not a good name for a globally visible function!

> +unsigned long get_videobuf_addr(void) {

Ditto

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
