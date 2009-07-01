Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZGAQTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZGAQTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZGAQTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:19:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48492 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZGAQTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:19:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A4B8C3F.60002@s5r6.in-berlin.de>
Date: Wed, 01 Jul 2009 18:18:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       tridge@samba.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu>
In-Reply-To: <20090701140503.GA21185@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> I'll note that many of the modern-day
> products actually use Linux (i.e., the Sony eReader, the Kindle,
> etc.

Many MP3/Video players surely do not run an embedded Linux.

Besides, it doesn't matter what "many" devices run if the talk is about 
defaults, or even about ripping the working, proven code out of the 
mainline.  (Well, that suggestion was absurd.)

> The other big user I can think of are digital cameras, but (a)
> normally most users read from them and then delete the pictures,

I use my SD cards not only in the camera but also as generic mobile 
storage with laptops and media player.

There is no way for software to detect that a medium is going to be used 
with a 8.3-only device exclusively.
-- 
Stefan Richter
-=====-==--= -=== ----=
http://arcgraph.de/sr/
