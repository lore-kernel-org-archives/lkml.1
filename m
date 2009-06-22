Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZFVWDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZFVWDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZFVWCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:02:55 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:58133
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751535AbZFVWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:02:54 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432R98dR1805Mzz1202hzzz2fh6bh17ch61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4A3FFF7B.8050707@am.sony.com>
Date: Mon, 22 Jun 2009 15:02:35 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Marco Stornelli <marco.stornelli@gmail.com>,
       Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz> <4A3E6F28.4090404@gmail.com> <20090621205245.GC3254@elf.ucw.cz> <2ea1731b0906212333r20deb71q2f021fc79bcc8a8e@mail.gmail.com> <20090622172003.GB21149@elf.ucw.cz> <4A3FBFF0.40006@am.sony.com> <20090622173704.GC21299@elf.ucw.cz> <4A3FD388.6040801@am.sony.com> <20090622210231.GC24236@elf.ucw.cz>
In-Reply-To: <20090622210231.GC24236@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 22:02:36.0210 (UTC) FILETIME=[26B0F120:01C9F385]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> You are saying top goal is robustness, while the web page says (home
> page, stop using frames!):
> 
> "embedded systems have a block of non-volatile RAM seperate from
> normal system memory, i.e. of which the kernel maintains no memory
> page descriptors. For such systems it would be beneficial to mount a
> fast read/write filesystem over this "I/O memory", for storing
> frequently accessed data that must survive system reboots and power
> cycles"
> 
> Note the "frequently accessed" and "fast".
> 
> IOW the web page is confusing. It does not talk about robustness at
> all.

OK, thanks.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

