Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZCTIVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZCTIVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZCTIUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:20:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38377
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755410AbZCTIUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:20:34 -0400
Date: Fri, 20 Mar 2009 01:20:20 -0700 (PDT)
Message-Id: <20090320.012020.100200198.davem@davemloft.net>
To: cywang@google.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto/scatterwalk.c to skip unnecessary
 flush_dcache_page() calls which may cause kernel panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <9c0b8b730903200115i7ae4512di97418958e05f6a0e@mail.gmail.com>
References: <9c0b8b730903200115i7ae4512di97418958e05f6a0e@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=big5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2K8LMqu001768

From: Chung-Yih Wang (¤ı±RÅt) <cywang@google.com>
Date: Fri, 20 Mar 2009 16:15:16 +0800

> Below is my patch for fixing this bug for  CONFIG_DEBUG_VM=y.

This exact change is already in the tree, and it's been there
for at least a month.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
