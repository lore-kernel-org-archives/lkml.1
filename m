Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbZACUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbZACUph (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbZACUp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:45:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40916 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755935AbZACUp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:45:28 -0500
Date: Sat, 3 Jan 2009 20:45:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Mohr <andi@lisas.de>, Sriram V <vshrirama@gmail.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090103204535.1a91cbcb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090103204329.GD1666@elf.ucw.cz>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com>
	<20090102102152.GA26603@rhlx01.hs-esslingen.de>
	<20090102172407.GD1555@ucw.cz>
	<alpine.LFD.2.00.0901031217261.3179@localhost.localdomain>
	<20090103204329.GD1666@elf.ucw.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [Now, olympus uses VFAT and probably will not write to the filesystem
> unless you take a picture... with mp3 player, I'd expect mtime to be
> updated on the playlist files...]

Some of the MP3/OGG players (especially the bigger disk based ones) use
the file system to store their own metadata so yes it makes a nasty mess.

