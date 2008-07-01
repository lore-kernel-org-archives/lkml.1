Return-Path: <linux-kernel-owner+w=401wt.eu-S1763278AbYGABOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763278AbYGABOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbYGABOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:14:06 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:22735 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbYGABOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:14:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 11/13] viafb: viafbdev.c, viafbdev.h
Date: Tue, 1 Jul 2008 09:14:01 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7CF1@exchtp03.taipei.via.com.tw>
In-Reply-To: <48693A5B.9040901@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 11/13] viafb: viafbdev.c, viafbdev.h
Thread-Index: Acja65zqoC5YUa8bTV2StzWbm+2x+AAK/2tQ
From: <JosephChan@via.com.tw>
To: <jirislaby@gmail.com>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 01 Jul 2008 01:14:03.0711 (UTC) FILETIME=[C04DBCF0:01C8DB17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m611ELfq006970

Jiri,

Thanks for your comments, I will let our engineers to check those items you mentioned. 

BRs,
Joseph Chan 


-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] 
Sent: Tuesday, July 01, 2008 3:56 AM
To: Joseph Chan
Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; geert@linux-m68k.org
Subject: Re: [PATCH 11/13] viafb: viafbdev.c, viafbdev.h

On 06/30/2008 09:46 AM, JosephChan@via.com.tw wrote:
> Initialization, remove and some other important functions of viafb.
> 
> Signed-off-by: Joseph Chan <josephchan@via.com.tw>
> 
> diff -Nur a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> --- a/drivers/video/via/viafbdev.c	1970-01-01 08:00:00.000000000 +0800
> +++ b/drivers/video/via/viafbdev.c	2008-06-30 08:53:33.000000000 +0800
> @@ -0,0 +1,2659 @@
[...]
> +static int timer_on;
> +struct timer_list timer_for3D;

Well the timer is neither inited nor used... ?

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
