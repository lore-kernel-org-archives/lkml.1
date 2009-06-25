Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbZFYDGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbZFYDGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZFYDF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:05:58 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:38134 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZFYDF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:05:57 -0400
In-Reply-To: <20090624070708.GI6760@one.firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
       linux-arch@vger.kernel.org, linux-arch-owner@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Subject: Re: S+core architecture (arch/score/) support files
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFBE328A69.2A153130-ON482575E0.000D6758-482575E0.0010F631@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Thu, 25 Jun 2009 11:00:22 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/25 ?? 11:00:23,
	Serialize complete at 2009/06/25 ?? 11:00:23
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5P36p54009897

linux-arch-owner@vger.kernel.org Ğ´ÓÚ 2009-06-24 15:07:08:

> The problem is just that if the code is not tested in its
> current configuration it will most likely not work (unless you're a 
perfect 
> coder, but most of us are not). And merging code that doesn't work 
doesn't
> make sense.
> 
> The need for a full retest after the changes inspired by review
> feedback is somewhat annoying -- I agree -- but there's really
> no way around it that I know.
> 
> BTW I'm not saying that LTP is the perfect user test (it's definitely
> not), but it's a relatively useful basic sanity check and you
> should pass something like this at least. Other real user testing would
> be still needed too of course then.

Thanks Andi,

In fact, what I worry about is leaving score outside upstream,
Few person will pay attation to asm-generic/score patches.
When score kernel/glibc finish its update and passed LTP,
We still could not catch up people's suggestion.

Best Regards
Liqin

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
