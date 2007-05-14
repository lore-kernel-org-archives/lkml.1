Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXENRVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXENRVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXENRVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:21:47 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52938 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXENRVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:21:46 -0400
Date: Mon, 14 May 2007 19:21:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <4647569D.7010709@imap.cc>
Message-ID: <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
 <4647569D.7010709@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 13 2007 20:19, Tilman Schmidt wrote:
>Am 13.05.2007 05:20 schrieb Linus Torvalds:
>> Ok, the merge window has closed, and 2.6.22-rc1 is out there.
>[...]
>> So give it a good testing.
>
>Would it be asking too much to have help texts on the following
>new (wrt 2.6.21) configuration options?
>
>ESP Scsi Driver Core (SCSI_ESP_CORE) [N/m] (NEW)
>Macintosh device drivers (MACINTOSH_DRIVERS) [Y/n] (NEW)
>Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)
>Ethernet (10000 Mbit) (NETDEV_10000) [Y/n] (NEW)
>
>Those for the latter three could/should say something like the
>one for the WLAN_80211 option.

"Patches welcome" ;-)

As for NETDEV_1000 and _10000, I really wonder if we need anymore
help text than the option. I do not know what the minimum level
of user knowledge is that kconfig help texts need to support,
but maybe you can tell?


	Jan
-- 
