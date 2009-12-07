Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbZLGFzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbZLGFzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZLGFzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:55:17 -0500
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:49770
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbZLGFzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:55:16 -0500
In-Reply-To: <200912031914.08975.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: What's in asm-generic.git
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF24184D8B.2F7F8AA9-ON48257685.002069EF-48257685.00207E45@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 7 Dec 2009 13:54:54 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/12/07 ?? 01:54:55,
	Serialize complete at 2009/12/07 ?? 01:54:55
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nB75to16014187

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2009-12-04 03:14:08:

> This is the contents of the "next" branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git,
> as currently found in linux-next.
> 
> Only two files are touched, most of the changes are bugfixes
> to the lib/checksum.c file that I introduced with the original
> asm-generic merge.
> 
> If anything is missing here, please tell me.
> 

Maybe you can add a __NR_set_thread_area define in asm-generic/unsitd.h
for tls used.

liqin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
