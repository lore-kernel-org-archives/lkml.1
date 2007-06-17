Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXFXPUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXFXPUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 11:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXFXPUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 11:20:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1812 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750927AbXFXPUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 11:20:05 -0400
Date: Sun, 17 Jun 2007 19:19:23 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: Li Yang-r58472 <LeoLi@freescale.com>, linux-kernel@vger.kernel.org,
       TripleX Chung <xxx.phy@gmail.com>, Maggie Chen <chenqi@beyondsoft.com>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Message-ID: <20070617191923.GA3920@ucw.cz>
References: <11822628633463-git-send-email-leoli@freescale.com> <989B956029373F45A0B8AF0297081890D82D5F@zch01exm26.fsl.freescale.net> <20070619153111.GA24521@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619153111.GA24521@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I see no reason why it can not go in, I'll add it to my queue and you
> will get an automated email when it is applied.

Again, what is advantage of having this in tree? Maintainers can't
grep & update translations, you probably did not verify translation to
be accurate (and still you are applying it), ...

Code merged in-tree has to be reviewed by relevant maintainers. This
is not. For in-tree code, hackers are expected to fix whatever they
break. You can't realisticaly expect me updating HOWTO to update
translations as well.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
