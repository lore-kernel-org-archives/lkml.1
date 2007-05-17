Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbXEQRgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbXEQRgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbXEQRgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:36:01 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58973 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbXEQRf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:35:59 -0400
Date: Thu, 17 May 2007 19:07:32 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: CaT <cat@zip.com.au>
cc: J??rn Engel <joern@lazybastard.org>, Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       Ingo Oeser <ioe-lkml@rameria.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
In-Reply-To: <20070516120624.GA18926@zip.com.au>
Message-ID: <Pine.LNX.4.61.0705171902530.3231@yvahk01.tjqt.qr>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org>
 <20070515191926.GB1220@lazybastard.org> <1179291255.2859.195.camel@shinybook.infradead.org>
 <20070516110933.GA5472@lazybastard.org> <20070516113434.GC20482@mail.shareable.org>
 <20070516115003.GD5472@lazybastard.org> <20070516120624.GA18926@zip.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16 2007 22:06, CaT wrote:
>On Wed, May 16, 2007 at 01:50:03PM +0200, J??rn Engel wrote:
>> On Wed, 16 May 2007 12:34:34 +0100, Jamie Lokier wrote:
>> > 
>> > But if akpm can't pronounce it, how about FFFS for faster flash
>> > filesystem.... ;-)
>> 
>> How many of you have worked for IBM before?  Vowels are not evil. ;)
>> 
>> Grouping four or more consonants to name anything will cause similar
>> expressions on people's faces.  Numbers don't help much either.
>> 
>> Ext2 is a great name, because "ext" actually is a pronouncable syllable.
>> MinixFS, ChunkFS, TileFS are great too.  XFS and JFS are ok, at least
>> they only have three consonants.  But FFS exists, so I'd rather go for a
>> syllable.
>
>FlashFS?

Or just try once dropping all those redundant 'fs' suffixes.
bdev, proc, cpuset, devpts, mqueue, fuse(blk|ctl), vfat, iso9660, etc.
Then there's much more space for innovative names.


	Jan
-- 
