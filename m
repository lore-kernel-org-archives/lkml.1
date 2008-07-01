Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbYGABM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbYGABM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbYGABMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:12:48 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:22469 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbYGABMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:12:48 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 1/13] viafb: viafb.modes, viafb.txt
Date: Tue, 1 Jul 2008 09:12:44 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7CEA@exchtp03.taipei.via.com.tw>
In-Reply-To: <Pine.LNX.4.64.0806301902390.26408@anakin>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/13] viafb: viafb.modes, viafb.txt
Thread-Index: Acja1Bu9wEQvKWQYTQe2oBeFJ1vFZwAQ1qVg
From: <JosephChan@via.com.tw>
To: <geert@linux-m68k.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 01 Jul 2008 01:12:46.0674 (UTC) FILETIME=[9262D320:01C8DB17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m611Cxfq006962

Hi Geert,

I'll check the possibility with our engineer. Thanks for your comment.

BRs,
Joseph Chan 
-----Original Message-----
From: geert@linux-m68k.org [mailto:geert@linux-m68k.org] 
Sent: Tuesday, July 01, 2008 1:09 AM
To: Joseph Chan
Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org
Subject: Re: [PATCH 1/13] viafb: viafb.modes, viafb.txt

On Mon, 30 Jun 2008, JosephChan@via.com.tw wrote:
> +[Bootup with viafb]:
> +--------------------
> +    Add the following line to your grub.conf:
> +    append = "video=viafb:viafb_mode=1024x768,via_fb_bpp=32,viafb_refresh=85"

Why not support simply video=1024x768-32@85 (or video=viafb:1024x768-32@85, if you have other video cards too), as can be parsed by fb_find_mode()?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
