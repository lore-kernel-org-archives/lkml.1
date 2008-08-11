Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbYHKMHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbYHKMHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYHKMHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:07:07 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:35722 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYHKMHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:07:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 1/13 v2] viafb: viafb.modes, viafb.txt
Date: Mon, 11 Aug 2008 20:07:03 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078F49C6@exchtp03.taipei.via.com.tw>
In-Reply-To: <Pine.LNX.4.64.0808081724210.420@anakin>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/13 v2] viafb: viafb.modes, viafb.txt
Thread-Index: Acj5auxL+4qHqRawTuyL2BH3C4K0vgCP3REg
From: <JosephChan@via.com.tw>
To: <geert@linux-m68k.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 11 Aug 2008 12:07:04.0804 (UTC) FILETIME=[C4FDD240:01C8FBAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7BC7Ndq000686

Hi Geert,

> Please send an incremental patch.
Do you mean that I can send a signle patch for fixing this issue. (v2 -> v3)
And the subject of this mail should be " [PATCH 1/13 v3] viafb: viafb.modes, viafb.txt"
Thanks.

BRs,
Joseph Chan 
-----Original Message-----
From: geert@linux-m68k.org [mailto:geert@linux-m68k.org] 
Sent: Friday, August 08, 2008 11:25 PM
To: Joseph Chan
Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org
Subject: RE: [PATCH 1/13 v2] viafb: viafb.modes, viafb.txt

On Fri, 8 Aug 2008, JosephChan@via.com.tw wrote:
> It should be my carelessness. The check has been added in viafbdev.c already. 

OK.

> Do I need to re-send the patch for the documentation? Thanks for your reminding.

Please send an incremental patch. Andrew is good in folding ;-)

> 
> 
> 
> On Fri, 8 Aug 2008, JosephChan@via.com.tw wrote:
> > +    4. VX800 2D accelerator hasn't been supported in this driver yet. When
> > +       using driver on VX800, one should add parameter "viafb_accel=0" to
> > +       disable 2D accelerator.
> 
> Can't the driver detect this automatically, and disable the 2D 
> accelerator when running on a VX800?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
