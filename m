Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYGEOdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYGEOdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYGEOd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:33:28 -0400
Received: from ihemail4.lucent.com ([135.245.0.39]:62477 "EHLO
	ihemail4.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYGEOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:33:28 -0400
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Jul 2008 10:33:28 EDT
Message-ID: <008101c8deaa$52cf19d0$01fca8c0@microsof60b8d6>
From: "Gavin Shan" <gshan@alcatel-lucent.com>
To: <linux-kernel@vger.kernel.org>
Subject: Tough Issue: kernel instruction corruption
Date: Sat, 5 Jul 2008 22:20:46 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m65EXefq027954

Hello, I'm faced a tough issue recently: instructions of kernel
were corrupted. There has 2 PCI buses on my board and lots
of PCI devices with DMA capabality involved. I'm suspecting
the kernel instructions were corrupted by DMA operations driving
by those PCI devices with DMA capabality. 

Anybody have tried to protect kernel instructions from this case
or have any ideas to protect kernel text section?

Thanks in advance,
Gavinÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
