Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZKFGxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZKFGxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 01:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZKFGxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 01:53:07 -0500
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:33574
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbZKFGxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 01:53:05 -0500
In-Reply-To: <200911041028.12098.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       liqin.gnu@gmail.com
MIME-Version: 1.0
Subject: Re: [PATCH] asm-generic: Fix typo in asm-generic/unistd.h.
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF2B2C42E6.2F1D2BE9-ON48257666.00247A2F-48257666.0025C58F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 6 Nov 2009 14:52:05 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/11/06 ?? 02:52:07,
	Serialize complete at 2009/11/06 ?? 02:52:07
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nA66rM16015322

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-11-04 17:28:11:

> I would recommend to look into this at some point in the future.
> Unlike the main glibc project, eglibc[1] is specifically there for
> supporting embedded architectures and already hosts ports for
> other platforms that are not in glibc itself, while it closely
> follows the main glibc development. Contributing there unfortunately
> requires some paperwork for copyright assignment, but it's probably
> worth it in the end.
> 
> You've done the right thing by merging your kernel code into the
> official Linux tree, porting your glibc code to the lastest 
> snapshot and submitting it into eglibc is the next big step.
> 

Hi Arnd£¬

Thank you for the above suggestions and comments,
We will evaluate your suggestions and continue upgrading.
to make linux/score platform work better.

Best Regards
Liqin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
