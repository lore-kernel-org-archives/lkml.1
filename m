Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZFJCmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZFJCmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 22:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZFJCmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 22:42:13 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:51021 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZFJCmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 22:42:13 -0400
X-Greylist: delayed 1290 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 22:42:12 EDT
In-Reply-To: <200906091837.28897.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 0/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF02E4B434.8757FEB7-ON482575D1.000B2BB7-482575D1.000CB7AE@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 10 Jun 2009 10:14:34 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/10 ?? 10:14:35,
	Serialize complete at 2009/06/10 ?? 10:14:35
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5A2h754030586

Thanks Arnd, tglx, Sam and all who pay attention to score code.

We will update score arch code to catch up the 
linux/kernel code level. The next patches will
send out soon.

Best Regards
liqin

--


Arnd Bergmann <arnd@arndb.de> Ð´ÓÚ 2009-06-10 00:37:28:

> On Monday 08 June 2009, liqin.chen@sunplusct.com wrote:
> > Thanks Arnd, our MIS help me solve the download problem.
> > 
> > > Feel free to base you code on top of asm-generic.git#next, but tell 
me
> > > when you intend to do that so I can warn you of possibly rebases.
> > 
> > Last week, I had updated score code base on asm-generic.git#next.
> > 
> > and I will apply a account on kernel.org, But before I get the 
account,
> > can you let score code merge in asm-generic.git?
> 
> I can take your patches and apply them to a new branch in my tree
> if that helps. I hope that Linus can pull my tree early in the
> merge window so your architecture port and the microblaze changes
> based on it can also get in soon.
> 
> I guess for the new architecture, it makes sense to combine all
> your patches into a single changeset in git, since they don't
> make sense until you have the complete set, and your changeset
> comments are rather boring so far anyway.
> 
> Can you write a few paragraphs of text about your architecture
> for the initial changeset comment? I think it would be good
> to permanently store some facts in there, e.g. in which ways
> the architecture is different from others, where to get a
> toolchain and what kinds of hardware exist for it.
> 
> I'll go through the patches once more and see if I find anything
> that should still be changed before the code goes in, but
> from a brief look, the code looks pretty good now.
> 
>    Arnd <><

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
