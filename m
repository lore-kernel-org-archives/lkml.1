Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYHNJ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYHNJ63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYHNJ6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:58:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:30951 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYHNJ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=s2LymALSgxfYi7d0AjiyctKRlxvl/RNFdwIW/vH19JH4xdvZVVsgBjgIyZSyZNhXrq
         tU2Q9WRLUshDIsXtJZ4DG2EepaJO+UBfb63KlRDHQS0TKzjUYip76u/2S2ZZCe7VxwXq
         TXJSuVCOQXESoIqJ1CQWVjBwkQ71VKaJUXq0A=
Message-ID: <d82e647a0808140258x118d0cafld51e57a043e4f3c8@mail.gmail.com>
Date: Thu, 14 Aug 2008 17:58:06 +0800
From: "Ming Lei" <tom.leiming@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG : lockdep link failed
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7E9wqdq012579

kernel revision : commit b635acec48bcaa9183fcbf4e3955616b0d4119b5...WARNING: modpost: Found 22 section mismatch(es).To see full details build your kernel with:'make CONFIG_DEBUG_SECTION_MISMATCH=y'  GEN     .version  CHK     include/linux/compile.h  UPD     include/linux/compile.h  CC      init/version.o  LD      init/built-in.o  LD      .tmp_vmlinux1kernel/built-in.o: In function `lockdep_stats_show':lockdep_proc.c:(.text+0x2e7a9): undefined reference to`lockdep_count_forward_deps'kernel/built-in.o: In function `l_show':lockdep_proc.c:(.text+0x2ea9b): undefined reference to`lockdep_count_forward_deps'lockdep_proc.c:(.text+0x2eab7): undefined reference to`lockdep_count_backward_deps'make: *** [.tmp_vmlinux1] ´íÎó 1

-- Lei Mingÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
