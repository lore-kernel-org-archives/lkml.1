Return-Path: <linux-kernel-owner+w=401wt.eu-S1162126AbXECP34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162126AbXECP34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162130AbXECP34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:29:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4842 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162126AbXECP3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:29:52 -0400
Date: Thu, 3 May 2007 12:06:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070503120637.GA3866@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704272107.28565.oliver@neukum.org> <84144f020704280222s42ff99ddg3eea3cb353c8882e@mail.gmail.com> <200704281537.53479.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704281537.53479.oliver@neukum.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The kernel can already do compression and encryption.
> > 
> > Yes, if we all could agree on _which_ compression and encryption
> 
> Any of those available in the kernel. Where's the problem?

gzip is too slow for this. lzf works okay. Oh and swsusp wants rsa
crypto.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
