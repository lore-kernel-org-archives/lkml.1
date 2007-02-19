Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXBSLll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXBSLll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932120AbXBSLlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:41:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35765 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932119AbXBSLlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:41:39 -0500
Date: Mon, 19 Feb 2007 12:41:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Maxim <maximlevitsky@gmail.com>
Cc: netdev@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Subject:  [PATCH 2.6.20 004/005] dmfe: Add support for suspend/resume
Message-ID: <20070219114117.GB19184@elf.ucw.cz>
References: <200702152253.53680.maximlevitsky@gmail.com> <200702180029.03651.maximlevitsky@gmail.com> <20070217225215.GE14222@elf.ucw.cz> <200702181543.53296.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702181543.53296.maximlevitsky@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > and add space before */.
> > 
> > Congratulation, you passed coding-style-police-check ;-).
> > 									Pavel
> > 
> 
> Hello,
> 	Thanks for reply, I just want to ask one question:
> 
> 	Those patches are now merged in -mm, and I noticed that Andrew Morton after applying them did fix my bad coding style and check for CONFIG_PM=n that I didn't include
> 	Now should I resend two last patches or not ?

Well,  i guess you should wait for next -mm tree, and if you see some
problem you fixed and akpm did not, fix it and send a incremental
patch...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
