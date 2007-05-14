Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbXENU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbXENU22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbXENU2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:28:21 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48310 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbXENU2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:28:19 -0400
Date: Mon, 14 May 2007 22:27:24 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
In-Reply-To: <46489D48.2040405@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0705142226270.9570@yvahk01.tjqt.qr>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
 <4647569D.7010709@imap.cc> <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
 <46489D48.2040405@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 19:32, Stefan Richter wrote:
>> 
>> As for NETDEV_1000 and _10000, I really wonder if we need anymore
>> help text than the option. I do not know what the minimum level
>> of user knowledge is that kconfig help texts need to support,
>> but maybe you can tell?
>
>The text "Ethernet (10000 Mbit)" _doesn't_ tell me that this option
>"does not affect the kernel build, it only lets [me] choose drivers".
>
>The "patches welcome" is quite appropriate.  On the other hand, visible
>Kconfig options without help text should almost never be allowed to go
>in in the first place, IMO.

Well, it was a conversion from "menu" to "menuconfig". Since
menus cannot(?) have a kconfig text, I did not transform one.

For the "config" to "menuconfig" conversions, the help text
was preserved, since there was something to preserve.


	Jan
-- 
