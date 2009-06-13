Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbZFMGlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbZFMGlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZFMGlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:41:01 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58735 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZFMGlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:41:00 -0400
In-Reply-To: <200906091918.20558.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 06/27] score: create head files delay.h device.h div64.h
 dma-mapping.h dma.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF676F75F6.AE51CF2E-ON482575D4.00241202-482575D4.0024AEE4@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sat, 13 Jun 2009 14:36:13 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/13 ?? 02:36:14,
	Serialize complete at 2009/06/13 ?? 02:36:14
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5D6fk54011714

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-06-10 01:18:20:

> On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> 
> Having a working udelay() function is required for many
> drivers that are sensitive to timing, you should probably
> implement that at some point in the future.

Add udelay() implement in code.

> 
> This indicates that you allow DMA to certain devices only in the first
> 16MB of memory, like an ISA floppy or parallel port. Do you actually 
have
> any devices with this behaviour?
> 

No, I had removed it.

Best Regards
Liqin
--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
