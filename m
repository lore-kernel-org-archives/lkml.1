Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXEQRjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXEQRjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbXEQRja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:39:30 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33740 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661AbXEQRj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:39:28 -0400
Date: Thu, 17 May 2007 19:14:47 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
cc: John Stoffel <john@stoffel.org>, Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
In-Reply-To: <20070516135318.GK5472@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0705171909310.3231@yvahk01.tjqt.qr>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org>
 <20070515191926.GB1220@lazybastard.org> <1179291255.2859.195.camel@shinybook.infradead.org>
 <20070516110933.GA5472@lazybastard.org> <20070516113434.GC20482@mail.shareable.org>
 <20070516115003.GD5472@lazybastard.org> <17995.2550.581854.8393@stoffel.org>
 <20070516135318.GK5472@lazybastard.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16 2007 15:53, Jörn Engel wrote:
>
>My experience is that no matter which name I pick, people will complain
>anyway.  Previous suggestions included:
[...]
>
>Plus today:
>FFFS
>flashfs
>fredfs
>bob
>shizzle
>
>Imo they all suck.  LogFS also sucks, but it allows me to make a stupid
>joke and keep my logfs.org domain.

Try woodfs! (log - wood - get it?)
But finding names can be so tiresome, just give it a Borg-style
designation - "filesystem 125" or so. fs2007q1, being this
quartal's new filesystem.


	Jan
-- 
