Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZIFL1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZIFL1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 07:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZIFL1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 07:27:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50949
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752235AbZIFL1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 07:27:40 -0400
Date: Sun, 06 Sep 2009 04:27:55 -0700 (PDT)
Message-Id: <20090906.042755.131133892.davem@davemloft.net>
To: ijc@hellion.org.uk
Cc: stable@kernel.org, rjw@sisk.pl, walt@holmansrus.com,
       kernel-testers@vger.kernel.org, khc@pm.waw.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug #14057] Strange network timeouts w/ e100
From: David Miller <davem@davemloft.net>
In-Reply-To: <1252236178.7811.28024.camel@localhost.localdomain>
References: <200908262312.04000.rjw@sisk.pl>
	<20090826.151153.169388217.davem@davemloft.net>
	<1252236178.7811.28024.camel@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n86BRu16020078

From: Ian Campbell <ijc@hellion.org.uk>
Date: Sun, 06 Sep 2009 12:22:58 +0100

> On Wed, 2009-08-26 at 15:11 -0700, David Miller wrote: 
>> From: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Date: Wed, 26 Aug 2009 23:12:03 +0200
>> 
>> >> Krzysztof has a patch which has corrected this issue for me.  Thanks,
>> > 
>> > Thanks for the update.
>> > 
>> > Do you have a pointer to the patch, please?
>> 
>> commit 6ff9c2e7fa8ca63a575792534b63c5092099c286
>> Author: Krzysztof HaÅ‚asa <khc@pm.waw.pl>
>> Date:   Sun Aug 23 19:02:13 2009 -0700
>> 
>>     E100: fix interaction with swiotlb on X86.
> 
> This fixes 303d67c2 which has been included in at least the 2.6.27.29
> and 2.6.30.5 stable releases so I think this should be a candidate for
> those stable branches too.

Absolutely, I'll take care of this.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
