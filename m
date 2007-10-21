Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbXJUUFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbXJUUFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXJUUEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:04:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57757 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXJUUEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:04:52 -0400
Date: Sun, 21 Oct 2007 22:04:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net, mwallis@serialmonkey.com
Subject: ISSC W89C35 802.11bg (was Re: rt73usb: support for wireless in
	Kohjinsha subnotebook)
Message-ID: <20071021200457.GA29024@elf.ucw.cz>
References: <20071020184100.GA11640@elf.ucw.cz> <efe7343f0710210802v6abc54d9k19293942477dabcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efe7343f0710210802v6abc54d9k19293942477dabcc@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This device is NOT a Ralink USB wifi adapter!
> 
> Get the windows driver in this link and see for yourself.
> http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
> (ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))

You are right, sorry for confusion.

Now, the strange part comes. They have linux sources on their web
pages... for 2.6.9 and 2.6.11. If anyone ported them forward, please
let me know, otherwise I'll take a look at porting them.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
