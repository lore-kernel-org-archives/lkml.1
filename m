Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbXEPNgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbXEPNgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbXEPNfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:35:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2063 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756234AbXEPNfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:35:38 -0400
Date: Tue, 15 May 2007 16:54:00 +0000
From: Pavel Machek <pavel@ucw.cz>
To: devzero@web.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Message-ID: <20070515165400.GH6816@ucw.cz>
References: <1785450541@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1785450541@web.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-05-12 12:41:03, devzero@web.de wrote:
> oh - and think of linux software suspend.
> take a notebook with 2 GB of ram - that takes a while to write that to disk and read that back again.
> using lzo compression for this may probably halve the time for suspend/resume

suspend.sf.net. We don't need lzo in kernel to do compressed
hibernation.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
