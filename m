Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZHYNnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZHYNnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZHYNnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:43:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54959 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753480AbZHYNnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:43:39 -0400
Date: Tue, 25 Aug 2009 14:42:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
 possible
Message-ID: <20090825144210.7c77c083@lxorguk.ukuu.org.uk>
In-Reply-To: <4A93E908.6050908@redhat.com>
References: <82k50tjw7u.fsf@mid.bfk.de>
	<20090824130125.GG23677@mit.edu>
	<20090824195159.GD29763@elf.ucw.cz>
	<4A92F6FC.4060907@redhat.com>
	<20090824205209.GE29763@elf.ucw.cz>
	<4A930160.8060508@redhat.com>
	<20090824212518.GF29763@elf.ucw.cz>
	<20090824223915.GI17684@mit.edu>
	<20090824230036.GK29763@elf.ucw.cz>
	<20090825000842.GM17684@mit.edu>
	<20090825094244.GC15563@elf.ucw.cz>
	<4A93E908.6050908@redhat.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009 09:37:12 -0400
Ric Wheeler <rwheeler@redhat.com> wrote:

> I really think that the expectation that all OS's (windows, mac, even your ipod) 
> all teach you not to hot unplug a device with any file system. Users have an 
> "eject" or "safe unload" in windows, your iPod tells you not to power off or 
> disconnect, etc.

Agreed

> I don't object to making that general statement - "Don't hot unplug a device 
> with an active file system or actively used raw device" - but would object to 
> the overly general statement about ext3 not working on flash, RAID5 not working, 
> etc...

The overall general statement for all media and all OS's should be

"Do you have a backup, have you tested it recently"

