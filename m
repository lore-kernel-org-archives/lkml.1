Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZGVGIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZGVGIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 02:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbZGVGIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 02:08:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47997
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340AbZGVGIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 02:08:45 -0400
Date: Tue, 21 Jul 2009 23:08:51 -0700 (PDT)
Message-Id: <20090721.230851.178052748.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ide-tape: fix handling of postponed rqs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090722055657.GA15465@liondog.tnic>
References: <1247910917-5237-4-git-send-email-petkovbb@gmail.com>
	<20090721.204704.123531717.davem@davemloft.net>
	<20090722055657.GA15465@liondog.tnic>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n6M69CJ7014979

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Wed, 22 Jul 2009 07:56:57 +0200

> On Tue, Jul 21, 2009 at 08:47:04PM -0700, David Miller wrote:
> 
>> drivers/ide/ide-tape.c: In function â€˜ide_tape_stall_queueâ€™:
>> drivers/ide/ide-tape.c:379: warning: unused variable â€˜rqâ€™
> 
> Sorry about that, rq is used only in the debug statement and I forgot to
> do a non-debug build, my bad.

Applied, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
