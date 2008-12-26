Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYL1How@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYL1How (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 02:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYL1HoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 02:44:00 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36709 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbYL1Hn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 02:43:57 -0500
Date: Fri, 26 Dec 2008 20:26:19 +0100
From: Pavel Machek <pavel@suse.cz>
To: Evgeniy Polyakov <zbe@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pohmelfs@ioremap.net, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [0/9] pohmelfs: The Great Southern Trendkill release.
Message-ID: <20081226192618.GC1761@ucw.cz>
References: <1230301130-1325-1-git-send-email-zbe@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230301130-1325-1-git-send-email-zbe@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> POHMELFS stands for Parallel Optimized Host Message Exchange Layered File System.
> 
> This is a high performance network filesystem with local coherent cache of
> data and metadata. Its main goal is distributed parallel processing of data.
> 
> POHMELFS is a kernel client for the developed distributed parallel internet
> filesystem. As it exists today, it is a high-performance parallel network
> filesystem with ability to balance reading from multiple hosts and simultaneously
> write data to multiple hosts.

So ocfs2 -alike fs?

> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

Do you think its ready for -mm?

Can it survive test such as paralel kernel compilation(s), fsx, etc?

How fast is it compared to nfs? to ext3 over fast network?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
