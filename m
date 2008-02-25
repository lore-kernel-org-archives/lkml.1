Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbYBYXGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbYBYXGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYBYXGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:06:06 -0500
Received: from sorrow.cyrius.com ([65.19.161.204]:3009 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYBYXGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:06:05 -0500
X-Greylist: delayed 1508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 18:06:05 EST
Date: Mon, 25 Feb 2008 23:39:17 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Byron Bradley <byron.bbradley@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, David Brownell <david-b@pacbell.net>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Message-ID: <20080225223917.GX17231@deprecation.cyrius.com>
References: <1203779614.3139.4.camel@localhost.localdomain> <47C08134.2030205@garzik.org> <alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802231229320.21332@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [2008-02-23 12:31]:
> I'm personally of the opinion that a new driver that doesn't add
> anything but itself (ie no infrastructure changes etc) is fine. I'd
> rather have a new, rough driver that might work, than no driver at
> all, and it's not like it can cause a regression if you don't enable
> it.

Maybe we can still get the new S-35390A RTC driver in then.  It has
been acked by Jean Delvare and David Brownell.  Byron or Jean, can you
try to submit it again?

It's needed by the QNAP TS-109/TS-209, a NAS device for which support
has been added in 2.6.25-rc1.
-- 
Martin Michlmayr
http://www.cyrius.com/
