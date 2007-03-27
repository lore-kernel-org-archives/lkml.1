Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbXC0MJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbXC0MJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 08:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbXC0MJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 08:09:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46257 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753824AbXC0MJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 08:09:05 -0400
Date: Tue, 27 Mar 2007 14:08:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sergey Smirnov <svs1957@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HELP!!! SD and suspend damage i-node.
Message-ID: <20070327120854.GH5161@elf.ucw.cz>
References: <4602781C.9060804@gmail.com> <20070323225820.GA5121@ucw.cz> <46076CB8.9000005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46076CB8.9000005@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Suspend damage filesystem each times on 4G SD.
> I use bluetooth. But corruption doesn't depend on it.
> I also test 2.6.21-rc4-git7 kernel. The same problem.
> 512Mb SD works normal.

Try using smaller filesystem on 4G SD, and be sure to CC SD/MMC
maintainer next time.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
